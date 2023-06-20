//
//  MealTableViewCell.swift
//  KA Mensa
//
//  Created by Yilmaz, Ihsan on 20.06.23.
//

import UIKit

class MealTableViewCell: UITableViewCell {
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var starStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(meal: Meal) {
        if let imageName = meal.imageName,
           let image = UIImage(named: imageName) {
            iconView.image = image
        } else {
            iconView.image = nil
        }
        
        nameLabel.text = meal.name
        if let price = meal.prices[UserDefaults.standard.getPriceCategory()] {
            priceLabel.text = String(format: "%.2f €", price)
        } else {
            priceLabel.text = nil
        }
    }

}
