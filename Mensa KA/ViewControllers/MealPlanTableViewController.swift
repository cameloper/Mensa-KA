//
//  MealPlanTableViewController.swift
//  Mensa KA
//
//  Created by Yilmaz, Ihsan on 20.06.23.
//

import UIKit

class MealPlanTableViewController: UITableViewController, SettingsDelegate {
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    var segmentedControl = UISegmentedControl()
    
    var mensa: Mensa = UserDefaults.standard.getMensa()
    var priceCategory: Meal.PriceCategory = UserDefaults.standard.getPriceCategory()
    var date = Date(day: 2, in: 27) // TODO: For debugging only, do not forget to change back

    let mealPlanManager = MealPlanManager()
    var dayPlan: [LinePlan]?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        getMealPlan()
        setupSegmentedControl()
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
        return dayPlan?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dayPlan?[section].meals.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "mealCell", for: indexPath) as? MealTableViewCell else {
                return UITableViewCell()
        }
        
        cell.setupCell(meal: (dayPlan?[indexPath.section].meals[indexPath.row])!, priceCategory: priceCategory)

        return cell
    }
    
    func setupSegmentedControl() {
        segmentedControl.insertSegment(withTitle: "Mo", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Di", at: 1, animated: false)
        segmentedControl.insertSegment(withTitle: "Mi", at: 2, animated: false)
        segmentedControl.insertSegment(withTitle: "Do", at: 3, animated: false)
        segmentedControl.insertSegment(withTitle: "Fr", at: 4, animated: false)
        
        navigationItem.titleView = segmentedControl
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "mealPlanToSettingsSegue",
           let settingsVc = segue.destination as? SettingsViewController {
            settingsVc.setup(lastSelectedMensa: mensa, lastSelectedDate: date, lastSelectedPriceCategory: priceCategory, delegate: self)
        } else if segue.identifier == "mealPlanToMealDetailsSegue",
                  let mealDetailsVc = segue.destination as? MealDetailsTableViewController,
                  let selectedCellIndex = tableView.indexPathForSelectedRow,
                  let selectedMeal = dayPlan?[selectedCellIndex.section].meals[selectedCellIndex.row] {
            mealDetailsVc.setup(withMeal: selectedMeal)
            tableView.deselectRow(at: selectedCellIndex, animated: true)
        }
    }
    
}
