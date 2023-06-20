//
//  MealPlanDownloader.swift
//  MensaKA
//
//  Created by Yilmaz, Ihsan on 19.06.23.
//

import Foundation
import SwiftSoup

class MealPlanDownloader {
    typealias GetCWPlanCompletionHandler = ( _ data: CWPlan? ) -> Void
    private let endpoint = "https://www.sw-ka.de/de/hochschulgastronomie/speiseplan"
    private let entryDateFormatter = DateFormatter()
    
    let mensa: Mensa
    let cw: Int
    
    init(mensa: Mensa, cw: Int) {
        self.mensa = mensa
        self.cw = cw
        entryDateFormatter.dateFormat = "yyyy-MM-dd"
    }
    
    func getCWPlan(completion: @escaping GetCWPlanCompletionHandler) {
        print("Getting meal plan for \(cw)")
        guard let baseURL = URL(string: endpoint) else {
            fatalError("Could not build url")
        }
        
        var reqURL = baseURL.appending(path: mensa.id)
        reqURL.append(queryItems: [
            URLQueryItem(name: "kw", value: String(cw))
        ])
        
        let task = URLSession.shared.dataTask(with: reqURL) { data, response, error in
            if let data = data,
               let htmlString = String(bytes: data, encoding: .utf8) {
                print("Received data! 🥳")
                completion(self.parse(htmlString))
            } else if let error = error {
                fatalError("Could not download HTML: \(error)")
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
                print("Parsing day plan for day \(dayId)")
                if let dayPlan = try parseDay(dayElement) {
                    dayPlans[entryDateString] = dayPlan
                } else {
                    print("Could not parse plan element for day \(dayId)")
                }
            }
            
            return CWPlan(days: dayPlans)
        } catch let error {
            print(error)
        }
        
        return nil
        
    }
    
    func parseDay(_ element: Element) throws -> [LinePlan]? {
        var linePlans = [LinePlan]()
        let lineElements = try element.getElementsByClass("mensatype_rows")
        for lineElement in lineElements {
            print("Parsing line plan")
            if let linePlan = try parseLine(lineElement) {
                linePlans.append(linePlan)
            } else {
                print("Could not parse line plan element")
            }
        }
        
        return linePlans
    }
    
    func parseLine(_ element: Element) throws -> LinePlan? {
        var meals = [Meal]()
        let lineTitle = try element.getElementsByClass("mensatype").first()!.children().first()!.text()
        
        guard let mealDetailTableElement = try element.getElementsByClass("meal-detail-table").first()?.getElementsByTag("tbody").first() else {
            print("Could not retrieve meal detail table for \(lineTitle)")
            return nil
        }
        
        let mealElements = try mealDetailTableElement.children().filter { element in
            return try element.className().prefix(3) == "mt-"
        }
        
        for mealElement in mealElements {
            print("Parsing meal \(try mealElement.className())")
            if let meal = try parseMeal(mealElement) {
                meals.append(meal)
            } else {
                print("Could not parse meal element")
            }
        }
        
        return LinePlan(name: lineTitle, meals: meals)
    }
    
    func parseMeal(_ element: Element) throws -> Meal? {
        var tags = [Tag]()
        var prices = [Meal.PriceCategory: Double]()
        
        let dataSections = element.children()
        
        let iconSection = dataSections[0]
        if let icon = try iconSection.getElementsByTag("img").first() {
            let src = try icon.attr("src")
            let extensionIndex = src.index(src.endIndex, offsetBy: -4)
            let iconName = src.split(separator: "/").last![..<extensionIndex]
            if let tag = Tag(rawValue: String(iconName)) {
                tags.append(tag)
            }
        }
        
        let titleSection = dataSections[1]
        guard let name = try titleSection.getElementsByTag("span").first()?.text() else {
            print("Could not get title. All meals should have a title!")
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
        
        return Meal(name: name, tags: tags, prices: prices)
    }
}
