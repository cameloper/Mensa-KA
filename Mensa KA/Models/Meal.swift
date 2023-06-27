//
//  Meal.swift
//  MensaKA
//
//  Created by Yilmaz, Ihsan on 20.06.23.
//

import Foundation

class Meal: Codable {
    enum PriceCategory: String, Codable {
        case student = "price_1"
        case guest = "price_2"
        case employee = "price_3"
        case pupil = "price_4"
        
        var description: String {
            switch self {
            case .student:
                return "Studierende"
            case .guest:
                return "Gast"
            case .employee:
                return "Mitarbeiter"
            case .pupil:
                return "Schüler*in"
            }
        }
        
        var index: Int {
            return PriceCategory.all.firstIndex(of: self) ?? 0
        }
        
        static var all: [PriceCategory] {
            return [.student, .guest, .employee, .pupil]
        }
    }
    
    enum EnvScore: Int, Codable {
        case none
        case oneStar
        case twoStars
        case threeStars
    }
    
    let name: String
    let tags: [Tag]
    let prices: [PriceCategory: Double]
    let envScore: EnvScore?
    var nutritionalFacts: NutritionFacts? = nil
    
    init(name: String, tags: [Tag], prices: [PriceCategory : Double], envScore: EnvScore?) {
        self.name = name
        self.tags = tags
        self.prices = prices
        self.envScore = envScore
    }
    
    var imageName: String? {
        self.tags.tags(withCategory: .optional).first?.imageName
    }
}
