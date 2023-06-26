//
//  TagTableViewCell.swift
//  Mensa KA
//
//  Created by Yilmaz, Ihsan on 26.06.23.
//

import UIKit

class TagTableViewCell: UITableViewCell {
    @IBOutlet weak var tagImageView: UIImageView!
    @IBOutlet weak var tagLabel: UILabel!
    
    func setup(withTag tag: Tag) {
        if let imageName = tag.imageName,
            let image = UIImage(named: imageName){
            tagImageView.image = image
            tagImageView.isHidden = false
        } else {
            tagImageView.isHidden = true
        }
        
        tagLabel.text = tag.description
    }

    override func prepareForReuse() {
        tagImageView.image = nil
        tagLabel.text = nil
    }

}
