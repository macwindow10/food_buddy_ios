//
//  RestaurantTableViewCell.swift
//  food_buddy
//
//  Created by Mac on 13/10/2023.
//

import UIKit

class RestaurantTableViewCell: UITableViewCell {

    @IBOutlet var labelName: UILabel!
    @IBOutlet var labelCuisine: UILabel!
    @IBOutlet var labelLocation: UILabel!
    @IBOutlet var imagePicture: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
