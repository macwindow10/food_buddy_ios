//
//  RestaurantTableViewCell.swift
//  food_buddy
//
//  Created by Mac on 13/10/2023.
//

import UIKit

protocol CustomCellDelegate: AnyObject {
    func cell(_ cell: RestaurantTableViewCell, didTap button: UIButton)
}

class RestaurantTableViewCell: UITableViewCell {

    weak var delegateParentViewController: CustomCellDelegate?
    
    @IBOutlet var labelName: UILabel!
    @IBOutlet var labelCuisine: UILabel!
    @IBOutlet var labelLocation: UILabel!
    @IBOutlet var imagePicture: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configure(delegate: CustomCellDelegate) {
        self.delegateParentViewController = delegate
    }
    
    @IBAction func buttonViewProfile_Click(_ sender: UIButton) {
        delegateParentViewController?.cell(self, didTap: sender)
    }
    
}
