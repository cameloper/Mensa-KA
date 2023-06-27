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
        
        var description: String {
            switch self {
            case .energy:
                return "🔥 Energie"
            case .protein:
                return "💪🏻 Proteine"
            case .carbonhydrate:
                return "🌾 Kohlenhydrate"
            case .sugar:
                return " - davon Zucker"
            case .fat:
                return "🧈 Fett"
            case .saturatedFat:
                return " - davon gesättigt"
            case .salt:
                return "🧂 Salz"
            }
        }
        
        var unit: String {
            switch self {
            case .energy:
                return "kcal"
            default:
                return "g"
            }
        }
        
        static var all: [NutritionValueType] {
            return [.energy, .protein, .carbonhydrate, .sugar, .fat, .saturatedFat, .salt]
        }
    }
    
    var nutritionValues: NutritionValues
}

extension NutritionValues {
    var arrayInViewOrder: [(key: NutritionFacts.NutritionValueType, value: Double)] {
        NutritionFacts.NutritionValueType.all.compactMap { type in
            if let value = self[type] {
                return (type, value)
            } else {
                return nil
            }
        }
    }
}
