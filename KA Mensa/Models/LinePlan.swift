//
//  LinePlan.swift
//  MensaKA
//
//  Created by Yilmaz, Ihsan on 20.06.23.
//

import Foundation

class LinePlan: Codable {
    let name: String
    let meals: [Meal]
    
    init(name: String, meals: [Meal]) {
        self.name = name
        self.meals = meals
    }
}
