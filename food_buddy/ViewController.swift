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
        
        buttonManageRestaurant.isHidden = true
        sleep(3)
    
    }
    
    @IBAction func buttonClick_OrderFood(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "vcRestaurants") as! RestaurantsViewController
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    @IBAction func buttonClick_ManageFood(_ sender: UIButton) {
    }
}

