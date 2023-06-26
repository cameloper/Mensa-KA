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
        tagImageView.image = tag.image
        tagLabel.text = tag.description
    }

    override func prepareForReuse() {
        tagImageView.image = nil
        tagLabel.text = nil
    }

}
