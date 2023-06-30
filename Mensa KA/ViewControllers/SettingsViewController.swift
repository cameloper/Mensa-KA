//
//  SettingsViewController.swift
//  Mensa KA
//
//  Created by Yilmaz, Ihsan on 20.06.23.
//

import UIKit

protocol SettingsDelegate {
    func settings(didChangeMensa mensa: Mensa)
    func settings(didChangeDate date: Date)
    func settings(didChangePriceCategory priceCategory: Meal.PriceCategory)
}

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var mensaPicker: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var priceCategoryControl: UISegmentedControl!
    
    var settingsDelegate: SettingsDelegate?
    
    var lastSelectedMensa: Mensa?
    var lastSelectedDate: Date?
    var lastSelectedPriceCategory: Meal.PriceCategory?
    
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
        
        priceCategoryControl.removeAllSegments()
        for priceCategory in Meal.PriceCategory.all {
            priceCategoryControl.insertSegment(withTitle: priceCategory.description, at: priceCategory.index, animated: false)
        }
        
        if let lastSelectedPriceCategory = lastSelectedPriceCategory {
            priceCategoryControl.selectedSegmentIndex = lastSelectedPriceCategory.index
        }
    }
    
    func setup(lastSelectedMensa: Mensa, lastSelectedDate: Date, lastSelectedPriceCategory: Meal.PriceCategory, delegate: SettingsDelegate) {
        self.lastSelectedMensa = lastSelectedMensa
        self.lastSelectedDate = lastSelectedDate
        self.lastSelectedPriceCategory = lastSelectedPriceCategory
        
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
    
    @IBAction func dateChanged(_ sender: Any) {
        if datePicker.date.isDMKA {
            dismiss(animated: false)
            performSegue(withIdentifier: "dmkaSegue", sender: self)
            datePicker.date = Date()
            return
        }
        
        lastSelectedDate = datePicker.date
        settingsDelegate?.settings(didChangeDate: datePicker.date)
    }

    @IBAction func priceCategoryChanged(_ sender: Any) {
        lastSelectedPriceCategory = Meal.PriceCategory.all[priceCategoryControl.selectedSegmentIndex]
        settingsDelegate?.settings(didChangePriceCategory: self.lastSelectedPriceCategory!)
    }
    
    @IBAction func userTappedDone(_ sender: Any) {
        presentingViewController?.dismiss(animated: true)
    }
}
