//
//  SettingsViewController.swift
//  Mensa KA
//
//  Created by Yilmaz, Ihsan on 20.06.23.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var mensaPicker: UIPickerView!
    @IBOutlet weak var priceCategoryControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mensaPicker.delegate = self
        mensaPicker.dataSource = self
        
        mensaPicker.selectRow(SettingsManager.main.mensa.index, inComponent: 0, animated: false)
        
        priceCategoryControl.removeAllSegments()
        for priceCategory in Meal.PriceCategory.all {
            priceCategoryControl.insertSegment(withTitle: priceCategory.description, at: priceCategory.index, animated: false)
        }
        
        priceCategoryControl.selectedSegmentIndex = SettingsManager.main.priceCategory.index
        
        
        navigationController?.navigationBar.prefersLargeTitles = true
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
        SettingsManager.main.mensa = Mensa.all[row]
    }

    @IBAction func priceCategoryChanged(_ sender: Any) {
        SettingsManager.main.priceCategory = Meal.PriceCategory.all[priceCategoryControl.selectedSegmentIndex]
    }
}
