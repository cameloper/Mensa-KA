//
//  NutritionFacts.swift
//  Mensa KA
//
//  Created by Yilmaz, Ihsan on 27.06.23.
//

import Foundation

typealias NutritionValues = [NutritionFacts.NutritionValueType: Double]
struct NutritionFacts: Codable {
    enum NutritionValueType: String, Codable {
        case energy = "energie"
        case protein = "proteine"
        case carbonhydrate = "kohlenhydrate"
        case sugar = "zucker"
        case fat = "fett"
        case saturatedFat = "gesaettigt"
        case salt = "salz"
        
        static var all: [NutritionValueType] {
            return [.energy, .protein, .carbonhydrate, .sugar, .fat, .saturatedFat, .salt]
        }
    }
    
    var nutritionValues = NutritionValues()
}
