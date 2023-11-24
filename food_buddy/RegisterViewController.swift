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
    
    @IBAction func buttonClicked_SignUp(_ sender: UIButton) {
        if (textUsername.text! == "" || textPassword.text! == "" ||
            textName.text! == "" || textMobile.text! == "") {
            return
        }
        var components = URLComponents(string: Common.BaseURL + "food_buddy_api/api.php")!
        components.queryItems = [
            URLQueryItem(name: "action", value: "signup"),
            URLQueryItem(name: "username", value: textUsername.text!),
            URLQueryItem(name: "password", value: textPassword.text!),
            URLQueryItem(name: "name", value: textName.text!),
            URLQueryItem(name: "mobile", value: textMobile.text!),
            URLQueryItem(name: "address", value: textAddress.text!),
            URLQueryItem(name: "user_type", value: selectedUserType)
        ]
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        let request = URLRequest(url: components.url!)
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            
            //print(response!)
            do {
                
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
