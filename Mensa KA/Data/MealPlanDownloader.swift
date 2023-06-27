//
//  MealPlanDownloader.swift
//  MensaKA
//
//  Created by Yilmaz, Ihsan on 19.06.23.
//

import Foundation
import SwiftSoup

class MealPlanDownloader {
    private let endpoint = "https://www.sw-ka.de/de/hochschulgastronomie/speiseplan"
    private let entryDateFormatter = DateFormatter()
    
    let mensa: Mensa
    let calendarWeek: Int
    
    init(forMensa mensa: Mensa, forCalendarWeek calendarWeek: Int) {
        self.mensa = mensa
        self.calendarWeek = calendarWeek
        entryDateFormatter.dateFormat = "yyyy-MM-dd"
    }
    
    func getCWPlan(completion: @escaping MealPlanManagerCompletion<CWPlan>) {
        guard let baseURL = URL(string: endpoint) else {
            completion(nil, MealPlanError.urlRequestError)
            return
        }
        
        var reqURL = baseURL.appending(path: mensa.rawValue)
        reqURL.append(queryItems: [
            URLQueryItem(name: "kw", value: String(calendarWeek))
        ])
        
        let task = URLSession.shared.dataTask(with: reqURL) { data, response, error in
            if let data = data,
               let htmlString = String(bytes: data, encoding: .utf8) {
                log.debug("Download successful for \(self.mensa) CW\(self.calendarWeek), parsing HTML...")
                let cwPlan = self.parse(htmlString)
                guard let dayCount = cwPlan?.days.count,
                      dayCount > 0 else {
                    completion(nil, MealPlanError.noDays)
                    return
                }
                
                log.info("Parsed meal plan of CW\(self.calendarWeek) with \(dayCount) days.")
                completion(cwPlan, error)
            } else if let error = error {
                log.error(MealPlanError.downloadError(error))
                completion(nil, error)
            }
        }
        
        task.resume()
    }
    
    private func parse(_ html: String) -> CWPlan? {
        do {
            let document = try SwiftSoup.parse(html)
            
            var dayPlans = [String: [LinePlan]]()
            
            let dayElements = try document.getElementsByClass("canteen-day")
            for dayElement in dayElements {
                let dayId = Int(dayElement.id().suffix(1))!
                let entryDateString = try dayElement.parent()!.getElementById("canteen_day_nav_\(dayId)")!.attr("rel")
                log.debug("Parsing day plan for day \(dayId).")
                
                let dayPlan = try parseDay(dayElement)
                dayPlans[entryDateString] = dayPlan
            }
            return CWPlan(mensa: mensa, calendarWeek: calendarWeek, days: dayPlans)
            
        } catch let error {
            log.error(MealPlanError.parsingError(error))
            return nil
        }
    }
    
    func parseDay(_ element: Element) throws -> [LinePlan] {
        var linePlans = [LinePlan]()
        let lineElements = try element.getElementsByClass("mensatype_rows")
        for lineElement in lineElements {
            let lineName = try lineElement.children().first()?.text()
            log.debug("Parsing line plan \(lineName ?? "").")
            
            if let linePlan = try parseLine(lineElement) {
                linePlans.append(linePlan)
            } else {
                log.error("Could not parse element for line \(lineName ?? "")")
            }
        }
        
        return linePlans
    }
    
    func parseLine(_ element: Element) throws -> LinePlan? {
        var meals = [Meal]()
        let lineTitle = try element.getElementsByClass("mensatype").first()!.children().first()!.text()
        
        guard let mealDetailTableElement = try element.getElementsByClass("meal-detail-table").first()?.getElementsByTag("tbody").first() else {
            log.error("Could not retrieve meal detail table for \(lineTitle).")
            return nil
        }
        
        let mealElements = try mealDetailTableElement.children().filter { element in
            return try element.className().prefix(3) == "mt-"
        }
        
        for mealElement in mealElements {
            let mealClassName = try mealElement.className()
            log.debug("Parsing meal with class \(mealClassName)")
            if let meal = try parseMeal(mealElement) {
                if let mealDetailsElement = try mealElement.nextElementSibling(),
                   let nutritionFactsRowElement = try mealDetailsElement.getElementsByClass("nutrition_facts_row").first() {
                    log.debug("Found nutrition facts row for meal \(mealClassName), trying to parse.")
                    if let nutritionFacts = try parseNutritionFacts(nutritionFactsRowElement, mealClassName) {
                        meal.nutritionalFacts = nutritionFacts
                    }
                }
                
                meals.append(meal)
            } else {
                log.error("Could not parse element for meal with class \(mealClassName)")
            }
        }
        
        return LinePlan(name: lineTitle, meals: meals)
    }
    
    func parseMeal(_ element: Element) throws -> Meal? {
        let mealClassName = try element.className()
        var tags = [Tag]()
        var prices = [Meal.PriceCategory: Double]()
        
        let dataSections = element.children()
        
        let iconSection = dataSections[0]
        for icon in try iconSection.getElementsByTag("img") {
            let src = try icon.attr("src")
            let extensionIndex = src.index(src.endIndex, offsetBy: -4)
            let iconName = src.split(separator: "/").last![..<extensionIndex]
            if let tag = Tag(rawValue: String(iconName)) {
                tags.append(tag)
            }
        }
        
        let titleSection = dataSections[1]
        guard let name = try titleSection.getElementsByTag("span").first()?.text() else {
            log.error("Could not get title for meal with class \(mealClassName). All meals should have a title!")
            return nil
        }
        
        if let tagsString = try titleSection.getElementsByTag("sup").first()?.text() {
            let tagStrings = tagsString.trimmingCharacters(in: CharacterSet(charactersIn: "[]")).split(separator: ",")
            tags.append(contentsOf: tagStrings.compactMap { Tag(rawValue: String($0)) })
        }
        
        let priceEnvSection = dataSections[2]
        let priceElements = try priceEnvSection.getElementsByClass("bgp")
        for priceElement in priceElements {
            guard let priceCategoryString = try priceElement.classNames().last,
               let priceCategory = Meal.PriceCategory(rawValue: priceCategoryString) else {
                continue
            }
            
            let priceString = try priceElement.text().trimmingCharacters(in: CharacterSet(charactersIn: " €"))
            if let price = priceString.doubleValue {
                prices[priceCategory] = price
            }
            
        }
        
        var envScore: Meal.EnvScore? = nil
        if let envScoreElement = try priceEnvSection.getElementsByClass("enviroment_score").first() {
            let envScoreString = try envScoreElement.attr("data-rating")
            if let envScoreInt = Int(envScoreString) {
                envScore = Meal.EnvScore(rawValue: envScoreInt)
            }
        }
        
        return Meal(name: name, tags: tags, prices: prices, envScore: envScore)
    }
    
    func parseNutritionFacts(_ element: Element, _ mealClassName: String) throws -> NutritionFacts? {
        var nutritionValues = NutritionValues()
        
        for nutritionType in NutritionFacts.NutritionValueType.all {
            if let typeDiv = try element.getElementsByClass(nutritionType.rawValue).first(),
               let valueDiv = typeDiv.children().last(),
               valueDiv.hasText() {
                let valueDivString = try valueDiv.text()
                if let valueString = valueDivString.split(separator: " ").first,
                   let value = String(valueString).doubleValue {
                    nutritionValues[nutritionType] = value
                }
            }
        }
        
        return NutritionFacts(nutritionValues: nutritionValues)
    }
}

extension String {
    static fileprivate let numberFormatter = NumberFormatter()
    fileprivate var doubleValue: Double? {
        String.numberFormatter.decimalSeparator = ","
        return String.numberFormatter.number(from: self)?.doubleValue
    }
}
