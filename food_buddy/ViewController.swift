//
//  ViewController.swift
//  food_buddy
//
//  Created by Mac on 10/10/2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var buttonOrderFood: UIButton!
    @IBOutlet var buttonManageRestaurant: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sleep(3)
        
        buttonOrderFood.titleLabel?.font =  UIFont(name: "Helvetica", size: 32)
        buttonManageRestaurant.titleLabel?.font =  UIFont(name: "Helvetica", size: 32)
    }
}

