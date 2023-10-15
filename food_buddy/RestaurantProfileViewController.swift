//
//  RestaurantProfileViewController.swift
//  food_buddy
//
//  Created by Mac on 15/10/2023.
//

import UIKit

class RestaurantProfileViewController: UIViewController {
    
    var restaurant: RestaurantModel = RestaurantModel()
    
    @IBOutlet var imageRestaurant: UIImageView!
    @IBOutlet var labelName: UILabel!
    @IBOutlet var labelContact: UILabel!
    @IBOutlet var labelAddress: UILabel!
    @IBOutlet var labelRating: UILabel!
    @IBOutlet var labelCity: UILabel!
    @IBOutlet var labelCusine: UILabel!
    
    override func viewDidLoad() {
        
        imageRestaurant.image = UIImage(named: restaurant.image_filename)
        labelName.text = restaurant.name
        labelCusine.text = "Cusine: \(restaurant.cuisine)"
        labelContact.text = "Contact: \(restaurant.contact)"
        labelRating.text = "Rating: \(restaurant.rating)"
        labelAddress.text = "Address: \(restaurant.address)"
        labelCity.text = "City: \(restaurant.city)"
    }
}
