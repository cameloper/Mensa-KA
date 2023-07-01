//
//  Utils.swift
//  MensaKA
//
//  Created by Yilmaz, Ihsan on 20.06.23.
//

import Foundation

extension Date {
    /// Initializes a `Date` instance of the given day of  week in the given week of year.
    ///  - Parameters:
    ///     - day: Day of week. Accepts value between 1 and 7, defaults to 1.
    ///     - calendarWeek: Week of year. Accepts value between 1 and 52. Defaults to 1.
    ///
    ///  - Returns: `Date` instance of given day and week at noon.
    init(day: Int, in calendarWeek: Int) {
        var dateComponents = Calendar.current.dateComponents(Set([.year]), from: Date())
        dateComponents.weekOfYear = (1...52).contains(calendarWeek) ? calendarWeek : 1
        dateComponents.weekday = (1...7).contains(day) ? day : 1
        dateComponents.hour = 12
        
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
    
    var isDMKA: Bool {
        return self.dayId == "2020-09-14"
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
    
    func debug(_ message: @autoclosure () -> Any, file: String = #file, line: Int = #line, function: String = #function) {
        log(message(), level: .debug, file: file, line: line, function: function)
    }
    
    func error(_ message: @autoclosure () -> Any, file: String = #file, line: Int = #line, function: String = #function) {
        log(message(), level: .error, file: file, line: line, function: function)
    }
    
    func info(_ message: @autoclosure () -> Any, file: String = #file, line: Int = #line, function: String = #function) {
        log(message(), level: .info, file: file, line: line, function: function)
    }
    
    private func log(_ message: @autoclosure () -> Any, level: Level, file: String, line: Int, function: String) {
        let fileName = file.split(separator: "/").last!
        print("\(level.prefix) [\(fileName):\(line) \(function)] \(message())")
    }
}

let log = Log()
