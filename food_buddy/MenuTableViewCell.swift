//
//  MenuTableViewCell.swift
//  food_buddy
//
//  Created by Mac on 13/10/2023.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet var imagePicture: UIImageView!
    @IBOutlet var labelName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
