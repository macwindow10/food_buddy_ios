//
//  RegisterViewController.swift
//  food_buddy
//
//  Created by Mac on 11/25/23.
//

import UIKit

class AdminAddMenuViewController: UIViewController {
    
    @IBOutlet var labelRestaurantName: UILabel!
    @IBOutlet var textMenuName: UITextField!
    @IBOutlet var textPreparationTime: UITextField!
    @IBOutlet var textDescription: UITextView!
    @IBOutlet var textPrice: UITextField!
    
    let defaults = UserDefaults.standard
    var restaurant_id = ""
    var restaurant_name = ""
    var user_id = "1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelRestaurantName.text = restaurant_name
        user_id = UserDefaults.standard.string(forKey: UserDefaultKeys.keyUserId) ?? "1"
    }
    
    @IBAction func buttonClick_AddMenu(_ sender: UIButton) {
        
        if (textMenuName.text! == "" || textDescription.text! == "" ||
            textPreparationTime.text! == "" || textPrice.text! == "") {
            return
        }
        
        let Url = String(format: Common.BaseURL + "food_buddy_api/api.php")
            guard let serviceUrl = URL(string: Url) else { return }
        let parameterDictionary = [
            "action": "add_menu",
            "user_id": user_id,
            "restaurant_id": restaurant_id,
            "name": textMenuName.text!,
            "description": textDescription.text!,
            "preparation_time": textPreparationTime.text!,
            "price": textPrice.text!
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
                        let alert = UIAlertController(title: "Information", message: "Menu created successfully", preferredStyle: .alert)
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
