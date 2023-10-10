//
//  RestaurantsViewController.swift
//  food_buddy
//
//  Created by Mac on 10/10/2023.
//

import Foundation
import UIKit

class RestaurantsViewController : UIViewController {
    
    override func viewDidLoad() {
        // self.navigationItem.title = "Your Title"
        // self.title = "Restaurants"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(self.onBack))
    }
    
    @objc func onBack() {
        _ = navigationController?.popToRootViewController(animated: true)
    }
}
