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
    
    @IBOutlet var textUsername: UITextField!
    @IBOutlet var textPassword: UITextField!
    @IBOutlet var textName: UITextField!
    @IBOutlet var textMobile: UITextField!
    @IBOutlet var textAddress: UITextField!
    @IBOutlet var pickerView: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
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
    
    @IBAction func buttonClicked_SignUp(_ sender: UIButton) {
        if (textUsername.text! == "" || textPassword.text! == "" ||
            textName.text! == "" || textMobile.text! == "") {
            return
        }
        
        let Url = String(format: Common.BaseURL + "food_buddy_api/api.php")
            guard let serviceUrl = URL(string: Url) else { return }
        let parameterDictionary = [
            "action": "signup",
            "username": textUsername.text!,
            "password": textPassword.text!,
            "name": textName.text!,
            "mobile": textMobile.text!,
            "address": textAddress.text!,
            "user_type": selectedUserType
        ]
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: []) else {
                return
            }
        request.httpBody = httpBody
            
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            
            print(response!)
            do {
                let s = String(bytes: data!, encoding: .utf8)
                let json = try JSONSerialization.jsonObject(with: data!) as! NSDictionary
                print(json)
                if (json.count == 3 && (json["status"] as! String) == "true")
                {
                
                    DispatchQueue.main.async {
                        
                    }
                }
                
            } catch {
                print("error")
            }
        });
        task.resume();
    }
}
