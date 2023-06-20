//
//  Utils.swift
//  MensaKA
//
//  Created by Yilmaz, Ihsan on 20.06.23.
//

import Foundation

extension UserDefaults {
    static private let mensaKey = "uerMensa"
    static private let priceCategoryKey = "priceCategory"
    
    func getMensa() -> Mensa {
        UserDefaults.standard.object(forKey: UserDefaults.mensaKey) as? Mensa ?? .mensa_adenauerring
    }
    
    func setMensa(_ mensa:  Mensa) {
        UserDefaults.standard.set(mensa, forKey: UserDefaults.mensaKey)
    }
    
    func getPriceCategory() -> Meal.PriceCategory {
        UserDefaults.standard.object(forKey: UserDefaults.priceCategoryKey) as? Meal.PriceCategory ?? .student
    }
    
    func setPriceCategory(_ priceCategory: Meal.PriceCategory) {
        UserDefaults.standard.set(priceCategory, forKey: UserDefaults.priceCategoryKey)
    }
}

extension Date {
    /// Initializes a `Date` instance of the given day of  week in the given week of year.
    ///  - Parameters:
    ///     - day: Day of week. Accepts value between 1 and 7, defaults to 1.
    ///     - calendarWeek: Week of year. Accepts value between 1 and 52. Defaults to 1.
    ///
    ///  - Returns: `Date` instance of given day and week at noon.
    init(day: Int, in calendarWeek: Int) {
        var dateComponents = DateComponents()
        dateComponents.weekOfYear = (1...52).contains(calendarWeek) ? calendarWeek : 1
        dateComponents.weekday = (1...7).contains(day) ? day : 1
        
        self = Calendar.current.date(from: dateComponents)!
    }
    
    var calendarWeek: Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "w"
        return Int(dateFormatter.string(from: self))!
    }
    
    var weekday: Int {
        return Calendar.current.dateComponents([.weekday], from: self).weekday!
    }
    
    static private let idDateFormatter = DateFormatter()
    var dayId: String {
        Date.idDateFormatter.dateFormat = "yyyy-MM-dd"
        return Date.idDateFormatter.string(from: self)
    }
}

extension String {
    static private let numberFormatter = NumberFormatter()
    var doubleValue: Double? {
        String.numberFormatter.decimalSeparator = ","
        return String.numberFormatter.number(from: self)?.doubleValue
    }
}
