//
//  MealPlanTableViewController.swift
//  KA Mensa
//
//  Created by Yilmaz, Ihsan on 20.06.23.
//

import UIKit

class MealPlanTableViewController: UITableViewController, SettingsDelegate {
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    var mensa: Mensa = UserDefaults.standard.getMensa()
    var date = Date()
    var mealPlanDownloader: MealPlanDownloader?
    var cwPlan: CWPlan?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
        downloadCWPlan()
    }
    
    func downloadCWPlan() {
        if cwPlan?.calendarWeek == date.calendarWeek,
           cwPlan?.mensa == mensa {
            self.tableView.reloadData()
        } else {
            mealPlanDownloader = MealPlanDownloader(mensa: mensa, cw: date.calendarWeek)
            mealPlanDownloader?.getCWPlan { newPlan in
                self.cwPlan = newPlan
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    var linePlans: [LinePlan]? {
        return cwPlan?.days[date.dayId]?.filter { !$0.meals.isEmpty }
    }

    func settings(didChangeMensa mensa: Mensa) {
        self.mensa = mensa
        downloadCWPlan()
        UserDefaults.standard.setMensa(mensa)
    }
    
    func settings(didChangeDate date: Date) {
        self.date = date
        downloadCWPlan()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return linePlans?[section].name
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return linePlans?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return linePlans?[section].meals.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "mealCell", for: indexPath) as? MealTableViewCell else {
                return UITableViewCell()
        }
        
        cell.setupCell(meal: (linePlans?[indexPath.section].meals[indexPath.row])!)

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "mealPlanToSettingsSegue",
           let settingsVc = segue.destination as? SettingsViewController {
            settingsVc.setup(lastSelectedMensa: mensa, lastSelectedDate: date, delegate: self)
        }
    }
    
}
