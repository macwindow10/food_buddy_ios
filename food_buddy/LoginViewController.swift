//
//  ViewController.swift
//  food_buddy
//
//  Created by Mac on 10/10/2023.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var textUsername: UITextField!
    @IBOutlet var textPassword: UITextField!
    @IBOutlet var buttonLogin: UIButton!
    @IBOutlet var buttonSignUp: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sleep(3)
    }
    
    @IBAction func buttonClick_OrderFood(_ sender: UIButton) {
        
        if (textUsername.text! == "" || textPassword.text! == "") {
            return
        }
        var components = URLComponents(string: Common.BaseURL + "food_buddy_api/api.php")!
        components.queryItems = [
            URLQueryItem(name: "action", value: "login"),
            URLQueryItem(name: "username", value: textUsername.text!),
            URLQueryItem(name: "password", value: textPassword.text!)
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
                    let item = json["users"] as! Dictionary<String, String>
                    let userId = item["id"] ?? ""
                    let userUserName = item["username"] ?? ""
                    let userName = item["name"] ?? ""
                    let userAddress = item["address"] ?? ""
                    let userMobile = item["mobile"] ?? ""
                    let userType = item["user_type"] ?? ""
                    let defaults = UserDefaults.standard
                    defaults.set(userId, forKey: UserDefaultKeys.keyUserId)
                    defaults.set(userUserName, forKey: UserDefaultKeys.keyUserName)
                    defaults.set(userName, forKey: UserDefaultKeys.keyName)
                    defaults.set(userAddress, forKey: UserDefaultKeys.keyAddress)
                    defaults.set(userMobile, forKey: UserDefaultKeys.keyMobile)
                    defaults.set(userType, forKey: UserDefaultKeys.keyType)
                    

                    DispatchQueue.main.async {
                        if (userType == "user") {
                            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let newViewController = storyBoard.instantiateViewController(withIdentifier: "vcRestaurants") as! RestaurantsViewController
                            self.navigationController?.pushViewController(newViewController, animated: true)
                        } else {
                            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let newViewController = storyBoard.instantiateViewController(withIdentifier: "vcAdminPanel") as! AdminRestaurantsViewController
                            self.navigationController?.pushViewController(newViewController, animated: true)
                        }
                    }
                }
                
            } catch {
                print("error")
            }
        });
        task.resume();
    }
    
    @IBAction func buttonClick_SignUp(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "vcSignUp") as! RegisterViewController
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
}

