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
    
    override func prepareForReuse() {
        iconView.image = nil
        nameLabel.text = nil
        priceLabel.text = nil
        starStackView.isHidden = true
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
        
        if let envScore = meal.envScore {
            starStackView.isHidden = false
            let emptyStar = UIImage(systemName: "star")
            let filledStar = UIImage(systemName: "star.fill")
            for subview in starStackView.arrangedSubviews.enumerated() {
                guard let starView = subview.element as? UIImageView else {
                    print("StarStackView shouldn't have any other subviews!")
                    break
                }
                
                starView.image = subview.offset <= envScore.rawValue - 1 ? filledStar : emptyStar
            }
        } else {
            starStackView.isHidden = true
        }
    }

}
