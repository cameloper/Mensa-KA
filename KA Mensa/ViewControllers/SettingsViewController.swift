//
//  SettingsViewController.swift
//  KA Mensa
//
//  Created by Yilmaz, Ihsan on 20.06.23.
//

import UIKit

protocol SettingsDelegate {
    func settings(didChangeMensa mensa: Mensa)
    func settings(didChangeDate date: Date)
}

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var mensaPicker: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var settingsDelegate: SettingsDelegate?
    
    var lastSelectedMensa: Mensa?
    var lastSelectedDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mensaPicker.delegate = self
        mensaPicker.dataSource = self
        // Do any additional setup after loading the view.
        if let lastSelectedMensa = lastSelectedMensa {
            mensaPicker.selectRow(lastSelectedMensa.index, inComponent: 0, animated: false)
        }
        
        if let lastSelectedDate = lastSelectedDate {
            datePicker.date = lastSelectedDate
        }
    }
    
    func setup(lastSelectedMensa: Mensa, lastSelectedDate: Date, delegate: SettingsDelegate) {
        self.lastSelectedMensa = lastSelectedMensa
        self.lastSelectedDate = lastSelectedDate
        
        settingsDelegate = delegate
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Mensa.all.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Mensa.all[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        settingsDelegate?.settings(didChangeMensa: Mensa.all[row])
    }
    
    @IBAction func datePickerDidChange(_ sender: Any) {
        lastSelectedDate = datePicker.date
        settingsDelegate?.settings(didChangeDate: datePicker.date)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
