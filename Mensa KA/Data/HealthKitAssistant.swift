//
//  HealthKitAssistant.swift
//  Mensa KA
//
//  Created by Yilmaz, Ihsan on 30.06.23.
//

import Foundation
import HealthKit

class HealthKitAssistant {
    private struct HKNutritionValue {
        let type: NutritionFacts.NutritionValueType
        let value: Double
        let hkType: HKQuantityType
        
        init?(type: NutritionFacts.NutritionValueType, value: Double) {
            self.type = type
            self.value = value
            let id: HKQuantityTypeIdentifier
            switch type {
            case .energy:
                id = .dietaryEnergyConsumed
            case .protein:
                id = .dietaryProtein
            case .carbonhydrate:
                id = .dietaryCarbohydrates
            case .sugar:
                id = .dietarySugar
            case .fat:
                id = .dietaryFatTotal
            case .saturatedFat:
                id = .dietaryFatSaturated
            default:
                return nil
            }
            
            guard let hkType = HKQuantityType.quantityType(forIdentifier: id) else {
                return nil
            }
            
            self.hkType = hkType
        }
        
        var unit: HKUnit {
            return HKUnit(from: type.unit)
        }
    }
    
    static let main = HealthKitAssistant()
    private let healthStore = HKHealthStore()
    
    func save(nutritionValues: NutritionValues, portions: Double) {
        let hkNutritionValues = nutritionValues.compactMap { HKNutritionValue(type: $0.key, value: $0.value) }
        
        healthStore.requestAuthorization(toShare: Set(hkNutritionValues.map { $0.hkType }), read: nil) { (success, error) in
            if !success,
                let error = error {
                log.error(MealPlanError.healthKitPermissionError(error))
                return
            }
            
            for hkNutritionValue in hkNutritionValues {
                let unit = hkNutritionValue.unit
                let startDate = self.mensaStartTimeToday
                let endDate = self.mensaEndTimeToday
                let quantity = HKQuantity(unit: unit, doubleValue: hkNutritionValue.value)
                let hkSample = HKQuantitySample(type: hkNutritionValue.hkType, quantity: quantity, start: startDate, end: endDate)
                
                self.healthStore.save(hkSample) { (sucess, error) in
                    if !success {
                        log.error(MealPlanError.healthKitSavingError(error))
                    } else {
                        log.info("Successfuly saved \(hkNutritionValue.type) in HealthKit")
                    }
                }
            }
        }
    }
    
    private var mensaStartTimeToday: Date {
        var dateComponents = DateComponents()
        dateComponents.hour = 11
        dateComponents.minute = 0
        dateComponents.second = 0
        return Calendar.current.date(from: dateComponents)!
    }
    
    private var mensaEndTimeToday: Date {
        var dateComponents = DateComponents()
        dateComponents.hour = 14
        dateComponents.minute = 0
        dateComponents.second = 0
        return Calendar.current.date(from: dateComponents)!
    }
}
