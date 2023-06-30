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
    case healthKitPermissionError(Error?)
    case healthKitSavingError(Error?)
    
    var description: String? {
        switch self {
        case .noOpenLines:
            return "There are no open lines on this day."
        case .parsingError(let error):
            return "An error has been occurd whilst parsing the scrapped HTML string:\n\(error)"
        case .noDays:
            return "No open days were listed for the calendar week."
        case .downloadError(let error):
            return "Could not download meal plan:\n\(error)"
        case .healthKitPermissionError(let error):
            return "Failed to get authorisation for HealthKit access:\n\(error?.localizedDescription ?? "")"
        case .healthKitSavingError(let error):
            return "Failed to save data in HealthKit. More detailed explanation might be in the given error:\n\(error?.localizedDescription ?? "")"
        default:
            return nil
        }
    }
}
