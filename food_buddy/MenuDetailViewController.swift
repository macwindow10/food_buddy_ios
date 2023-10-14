//
//  MenuDetailViewController.swift
//  food_buddy
//
//  Created by Mac on 14/10/2023.
//

import UIKit

class MenuDetailViewController : UIViewController {
    
    @IBOutlet var imageMenu: UIImageView!
    @IBOutlet var labelName: UILabel!
    
    var menu: MenuModel = MenuModel()
    
    override func viewDidLoad() {
        imageMenu.image = UIImage(named: menu.image_filename)
        imageMenu.contentMode = .scaleAspectFit
        imageMenu.layer.cornerRadius = 60
        imageMenu.clipsToBounds = true
    }
}
