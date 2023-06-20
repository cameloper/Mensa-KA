//
//  CWPlan.swift
//  MensaKA
//
//  Created by Yilmaz, Ihsan on 19.06.23.
//

import Foundation

class CWPlan {
    let mensa: Mensa
    let calendarWeek: Int
    let days: [String: [LinePlan]]
    
    init(mensa: Mensa, calendarWeek: Int, days: [String: [LinePlan]]) {
        self.mensa = mensa
        self.calendarWeek = calendarWeek
        self.days = days
    }
}
