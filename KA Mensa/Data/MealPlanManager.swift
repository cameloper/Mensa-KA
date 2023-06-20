//
//  MealPlanManager.swift
//  KA Mensa
//
//  Created by Yilmaz, Ihsan on 20.06.23.
//

import Foundation

typealias MealPlanManagerCompletion<T> = (_ data: T?, _ error: Error?) -> Void
class MealPlanManager {
    private var downloadedMealPlans = [CWPlan]()
    
    func getNonEmptyLinePlans(forMensa mensa: Mensa, forDate date: Date, completion: @escaping MealPlanManagerCompletion<[LinePlan]>) {
        self.getMealPlan(forMensa: mensa, forDate: date) { dayPlan, error in
            completion(dayPlan!.filter { !$0.meals.isEmpty }, error)
        }
    }
    
    private func getMealPlan(forMensa mensa: Mensa, forDate date: Date, completion: @escaping MealPlanManagerCompletion<[LinePlan]>) {
        let calendarWeek = date.calendarWeek
        
        if let cwPlan = getDownloadedMealPlan(forMensa: mensa, forCalendarWeek: calendarWeek),
           let dayPlan = cwPlan.days[date.dayId] {
            completion(dayPlan, nil)
            return
        }
        
        let mealPlanDownloader = MealPlanDownloader(mensa: mensa, cw: calendarWeek)
        mealPlanDownloader.getCWPlan { data in
            if let cwPlan = data {
                self.downloadedMealPlans.append(cwPlan)
                if let dayPlan = cwPlan.days[date.dayId] {
                    completion(dayPlan, nil)
                }
            }
        }
    }
    
    private func downloadMealPlan(forMensa mensa: Mensa, forCalendarWeek calendarWeek: Int) {
        
    }
    
    private func getDownloadedMealPlan(forMensa mensa: Mensa, forCalendarWeek calendarWeek: Int) -> CWPlan? {
        return downloadedMealPlans.first { cwPlan in
            return cwPlan.mensa == mensa && cwPlan.calendarWeek == calendarWeek
        }
    }
}
