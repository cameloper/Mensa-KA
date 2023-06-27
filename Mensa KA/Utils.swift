//
//  Utils.swift
//  MensaKA
//
//  Created by Yilmaz, Ihsan on 20.06.23.
//

import Foundation

extension UserDefaults {
    static private let mensaKey = "userMensa"
    static private let priceCategoryKey = "priceCategory"
    
    func getMensa() -> Mensa {
        if let value = UserDefaults.standard.string(forKey: UserDefaults.mensaKey),
            let mensa = Mensa(rawValue: value) {
            return mensa
        } else {
            return .adenauerring
        }
    }
    
    func setMensa(_ mensa:  Mensa) {
        UserDefaults.standard.set(mensa.rawValue, forKey: UserDefaults.mensaKey)
    }
    
    func getPriceCategory() -> Meal.PriceCategory {
        if let value = UserDefaults.standard.string(forKey: UserDefaults.priceCategoryKey),
           let priceCategory = Meal.PriceCategory(rawValue: value) {
            return priceCategory
        } else {
            return .student
        }
    }
    
    func setPriceCategory(_ priceCategory: Meal.PriceCategory) {
        UserDefaults.standard.set(priceCategory.rawValue, forKey: UserDefaults.priceCategoryKey)
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

struct Log {
    private enum Level: String {
        case debug
        case error
        case info
        
        var prefix: String {
            return "[\(self.rawValue.uppercased())]"
        }
    }
    
    func debug(file: String = #file, line: Int = #line, function: String = #function, _ items: Any...) {
        log(level: .debug, file: file, line: line, function: function, items)
    }
    
    func error(file: String = #file, line: Int = #line, function: String = #function, _ items: Any...) {
        log(level: .error, file: file, line: line, function: function, items)
    }
    
    func info(file: String = #file, line: Int = #line, function: String = #function, _ items: Any...) {
        log(level: .info, file: file, line: line, function: function, items)
    }
    
    private func log(level: Level, file: String, line: Int, function: String, _ items: Any...) {
        let fileName = file.split(separator: "/").last!
        print("\(level.prefix) [\(fileName):\(line) \(function)] \(items)")
    }
}

let log = Log()
