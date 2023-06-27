//
//  MealDetailsTableViewController.swift
//  Mensa KA
//
//  Created by Yilmaz, Ihsan on 26.06.23.
//

import UIKit

class MealDetailsTableViewController: UITableViewController {
    var nutritionalFacts: NutritionFacts?
    var tags: [Tag]?

    func setup(withMeal meal: Meal) {
        tags = meal.tags
        nutritionalFacts = meal.nutritionalFacts
        navigationItem.title = meal.name
    }
    
    private func tags(forSection section: Int) -> [Tag]? {
        if let tags = tags {
            return tags.tags(withCategory: tags.presentCategories[section - 1])
        }
        
        return nil
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // First section will be for static meal deatils like name and nutritional velus
        // then one section each for allergens additives and optional indications
        return 1 + (tags?.presentCategories.count ?? 0)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return nutritionalFacts?.nutritionValues.count ?? 0
        } else {
            return tags(forSection: section)?.count ?? 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0,
           let nutritionalValue = nutritionalFacts?.nutritionValues.arrayInViewOrder[indexPath.row],
           let cell = tableView.dequeueReusableCell(withIdentifier: "nutritionValueCell", for: indexPath) as? NutritionValueTableViewCell {
            cell.setup(withType: nutritionalValue.key, andValue: nutritionalValue.value)
            return cell
        } else if indexPath.section >= 1,
           let cell = tableView.dequeueReusableCell(withIdentifier: "tagCell", for: indexPath) as? TagTableViewCell,
           let tags = tags(forSection: indexPath.section) {
            cell.setup(withTag: tags[indexPath.row])
            return cell
        }
        
        fatalError()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return !(nutritionalFacts?.nutritionValues.isEmpty ?? true) ? "Nährwertangaben" : nil
        } else {
            return tags?.presentCategories[section - 1].description
        }
    }
}
