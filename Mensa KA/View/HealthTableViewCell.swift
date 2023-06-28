//
//  HealthTableViewCell.swift
//  Mensa KA
//
//  Created by Yilmaz, Ihsan on 28.06.23.
//

import UIKit

class HealthTableViewCell: UITableViewCell {
    @IBOutlet weak var portionLabel: UILabel!
    @IBOutlet weak var innerView: UIView!
    
    private var portionCount = 0 {
        didSet {
            portionLabel.text = String(portionCount)
        }
    }
    
    var addToHealthClosure: ((Int) -> Void)?
    
    @IBAction func healthButtonDidTouch(_ sender: Any) {
        addToHealthClosure?(portionCount)
    }
    
    @IBAction func stepperValueChanged(_ sender: Any) {
        let stepper = sender as! UIStepper
        portionCount = Int(stepper.value)
    }
}
