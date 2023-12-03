//
//  RegisterViewController.swift
//  food_buddy
//
//  Created by Mac on 11/25/23.
//

import UIKit

class AdminAddRestaurantViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var textRestaurantName: UITextField!
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var textContactNo: UITextField!
    @IBOutlet var textAddress: UITextField!
    @IBOutlet var textCity: UITextField!
    
    var user_id = "1"
    let defaults = UserDefaults.standard
    var restaurantTypeOptions: [String] = ["Continental", "Fast Food"]
    var selectedRestaurantType = "Continental"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        user_id = UserDefaults.standard.string(forKey: UserDefaultKeys.keyUserId) ?? "1"
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        restaurantTypeOptions.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return restaurantTypeOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
            selectedRestaurantType = "Continental"
        } else if row == 1 {
            selectedRestaurantType = "Fast Food"
        }
    }
    
    @IBAction func buttonClick_AddRestaurant(_ sender: UIButton) {
        if (textRestaurantName.text! == "" || textContactNo.text! == "" ||
            textAddress.text! == "" || textCity.text! == "") {
            return
        }
        
        let Url = String(format: Common.BaseURL + "food_buddy_api/api.php")
            guard let serviceUrl = URL(string: Url) else { return }
        let parameterDictionary = [
            "action": "add_restaurant",
            "user_id": user_id,
            "name": textRestaurantName.text!,
            "contact_number": textContactNo.text!,
            "address": textAddress.text!,
            "city": textCity.text!,
            "restaurant_type": selectedRestaurantType
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
            
            // print(response!)
            do {
                let s = String(bytes: data!, encoding: .utf8)
                let json = try JSONSerialization.jsonObject(with: data!) as! NSDictionary
                print(json)
                if (json.count == 2 && (json["status"] as! String) == "true")
                {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Information", message: "Restaurant created successfully", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                            self.navigationController?.popViewController(animated: true)
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                
            } catch {
                print("error")
            }
        });
        task.resume();
    }
    
}
