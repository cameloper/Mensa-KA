//
//  MealPlanTableViewController.swift
//  Mensa KA
//
//  Created by Yilmaz, Ihsan on 20.06.23.
//

import UIKit

class MealPlanTableViewController: UITableViewController, SettingsDelegate {
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    var mensa: Mensa = UserDefaults.standard.getMensa()
    var priceCategory: Meal.PriceCategory = UserDefaults.standard.getPriceCategory()
    var date = Date()

    let mealPlanManager = MealPlanManager()
    var dayPlan: [LinePlan]?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        getMealPlan()
    }
    
    func getMealPlan() {
        navigationItem.title = mensa.shortName
        mealPlanManager.getNonEmptyLinePlans(forMensa: mensa, forDate: date) { dayPlan, error in
            self.dayPlan = dayPlan
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    func settings(didChangeMensa mensa: Mensa) {
        self.mensa = mensa
        getMealPlan()
        UserDefaults.standard.setMensa(mensa)
    }
    
    func settings(didChangeDate date: Date) {
        self.date = date
        getMealPlan()
    }
    
    func settings(didChangePriceCategory priceCategory: Meal.PriceCategory) {
        self.priceCategory = priceCategory
        UserDefaults.standard.setPriceCategory(priceCategory)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dayPlan?[section].name
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return dayPlan?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dayPlan?[section].meals.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "mealCell", for: indexPath) as? MealTableViewCell else {
                return UITableViewCell()
        }
        
        cell.setupCell(meal: (dayPlan?[indexPath.section].meals[indexPath.row])!, priceCategory: priceCategory)

        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "mealPlanToSettingsSegue",
           let settingsVc = segue.destination as? SettingsViewController {
            settingsVc.setup(lastSelectedMensa: mensa, lastSelectedDate: date, lastSelectedPriceCategory: priceCategory, delegate: self)
        }
    }
    
}
