//
//  MealPlanError.swift
//  Mensa KA
//
//  Created by Yilmaz, Ihsan on 20.06.23.
//

import Foundation

struct UnknownError: Error {
    var description = "An unknown error has occured."
}

enum MealPlanError: Error {
    case urlRequestError
    case downloadError(Error)
    case noOpenLines
    case noDays
    case parsingError(Error)
    
    var description: String? {
        switch self {
        case .noOpenLines:
            return "There are no open lines on this day."
        case .parsingError(let error):
            return "An error has been occurd whilst parsing the scrapped HTML string:\n\(error)"
        case .noDays:
            return "No open days were listed for the calendar week."
        default:
            return nil
        }
    }
}
