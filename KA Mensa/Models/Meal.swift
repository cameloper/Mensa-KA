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
    }
    
    let name: String
    let tags: [Tag]
    let prices: [PriceCategory: Double]
    
    init(name: String, tags: [Tag], prices: [PriceCategory : Double]) {
        self.name = name
        self.tags = tags
        self.prices = prices
    }
    
    var imageName: String? {
        self.tags.first {
            switch $0.category {
            case .optional:
                return true
            default:
                return false
            }
        }?.rawValue
    }
}
