//
//  NutritionValueTableViewCell.swift
//  Mensa KA
//
//  Created by Yilmaz, Ihsan on 27.06.23.
//

import UIKit

class NutritionValueTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    func setup(withType type: NutritionFacts.NutritionValueType, andValue value: Double) {
        nameLabel.text = type.description
        valueLabel.text = "\(value) \(type.unit)"
    }
}
