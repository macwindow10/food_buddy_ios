//
//  RegisterViewController.swift
//  food_buddy
//
//  Created by Mac on 11/25/23.
//

import UIKit

class RegisterViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var userTypeOptions: [String] = ["user", "restaurant_owner"]
    var selectedUserType = "user"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerPortionSize.delegate = self
        pickerPortionSize.dataSource = self
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        userTypeOptions.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return userTypeOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
            selectedUserType = "user"
        } else if row == 1 {
            selectedUserType = "restaurant_owner"
        }
    }
    
}
