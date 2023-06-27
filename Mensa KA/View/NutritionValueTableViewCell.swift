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
        valueLabel.text = "\(value.description) \(type.unit)"
    }
}

extension Double {
    static fileprivate let numberFormatter = NumberFormatter()
    fileprivate var description: String {
        Double.numberFormatter.numberStyle = .decimal
        Double.numberFormatter.maximumFractionDigits = 2
        return Double.numberFormatter.string(from: NSNumber(value: self))!
    }
}
