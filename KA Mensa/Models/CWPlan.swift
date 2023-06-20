//
//  CWPlan.swift
//  MensaKA
//
//  Created by Yilmaz, Ihsan on 19.06.23.
//

import Foundation

class CWPlan {
    let days: [String: [LinePlan]]
    
    init(days: [String: [LinePlan]]) {
        self.days = days
    }
}
