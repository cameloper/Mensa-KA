//
//  SettingsManager.swift
//  Mensa KA
//
//  Created by Yilmaz, Ihsan on 01.07.23.
//

import Foundation

class SettingsManager {
    var mensa: Mensa {
        didSet {
            postNotification()
        }
    }
    var priceCategory: Meal.PriceCategory {
        didSet {
            postNotification()
        }
    }
    
    static var main = SettingsManager()
    
    init() {
        self.mensa = UserDefaults.standard.getMensa()
        self.priceCategory = UserDefaults.standard.getPriceCategory()
    }
    
    func postNotification() {
        log.debug("Settings did change!")
        NotificationCenter.default.post(name: .settingsDidChange, object: nil)
    }
    
}

extension Notification.Name {
    static var settingsDidChange: Notification.Name {
        return .init("settingsDidUpdate")
    }
}

extension UserDefaults {
    static private let mensaKey = "userMensa"
    static private let priceCategoryKey = "priceCategory"
    
    fileprivate func getMensa() -> Mensa {
        if let value = UserDefaults.standard.string(forKey: UserDefaults.mensaKey),
            let mensa = Mensa(rawValue: value) {
            return mensa
        } else {
            setMensa(.adenauerring)
            return .adenauerring
        }
    }
    
    fileprivate func setMensa(_ mensa:  Mensa) {
        UserDefaults.standard.set(mensa.rawValue, forKey: UserDefaults.mensaKey)
    }
    
    fileprivate func getPriceCategory() -> Meal.PriceCategory {
        if let value = UserDefaults.standard.string(forKey: UserDefaults.priceCategoryKey),
           let priceCategory = Meal.PriceCategory(rawValue: value) {
            return priceCategory
        } else {
            setPriceCategory(.student)
            return .student
        }
    }
    
    fileprivate func setPriceCategory(_ priceCategory: Meal.PriceCategory) {
        UserDefaults.standard.set(priceCategory.rawValue, forKey: UserDefaults.priceCategoryKey)
    }
}
