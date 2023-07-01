//
//  MealPlanTableViewController.swift
//  Mensa KA
//
//  Created by Yilmaz, Ihsan on 20.06.23.
//

import UIKit

class MealPlanTableViewController: UITableViewController {
    var segmentedControl = UISegmentedControl()
    var date = Date(day: 2, in: 27)

    let mealPlanManager = MealPlanManager()
    var dayPlan: [LinePlan]?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        getMealPlan()
        setupSegmentedControl()
        
        NotificationCenter.default.addObserver(self, selector: #selector(settingsDidChange), name: .settingsDidChange, object: nil)
    }
    
    func getMealPlan() {
        let mensa = SettingsManager.main.mensa
        navigationItem.title = mensa.shortName
        mealPlanManager.getNonEmptyLinePlans(forMensa: mensa, forDate: date) { dayPlan, error in
            self.dayPlan = dayPlan
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    @objc func settingsDidChange() {
        getMealPlan()
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
        
        cell.setupCell(meal: (dayPlan?[indexPath.section].meals[indexPath.row])!, priceCategory: SettingsManager.main.priceCategory)

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
        if segue.identifier == "mealPlanToMealDetailsSegue",
                  let mealDetailsVc = segue.destination as? MealDetailsTableViewController,
                  let selectedCellIndex = tableView.indexPathForSelectedRow,
                  let selectedMeal = dayPlan?[selectedCellIndex.section].meals[selectedCellIndex.row] {
            mealDetailsVc.setup(withMeal: selectedMeal)
            tableView.deselectRow(at: selectedCellIndex, animated: true)
        }
    }
    
}
