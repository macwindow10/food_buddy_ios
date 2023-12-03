//
//  CartViewController.swift
//  food_buddy
//
//  Created by Mac on 03/12/2023.
//

import Foundation
import UIKit

class CartViewController: UIViewController {
    
    var cart: [OrderModel] = []
    var user_id: String = ""
    
    override func viewDidLoad() {
        if let data = UserDefaults.standard.data(forKey: UserDefaultKeys.keyCart) {
            do {
                let decoder = JSONDecoder()
                cart = try decoder.decode([OrderModel].self, from: data)
            } catch {
                print("Unable to Decode Cart (\(error))")
            }
        }
        user_id = UserDefaults.standard.string(forKey: UserDefaultKeys.keyUserId) ?? "1"
    }
}
