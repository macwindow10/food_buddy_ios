//
//  MenuDetailViewController.swift
//  food_buddy
//
//  Created by Mac on 14/10/2023.
//

import UIKit

class MenuDetailViewController : UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var imageMenu: UIImageView!
    @IBOutlet var labelName: UILabel!
    @IBOutlet var labelPreparationTime: UILabel!
    @IBOutlet var labelIngredientsCount: UILabel!
    @IBOutlet var labelDetail: UILabel!
    @IBOutlet var labelPrice: UILabel!
    @IBOutlet var textPreparationInstructions: UITextView!
    @IBOutlet weak var pickerPortionSize: UIPickerView!
    @IBOutlet var textAnyAllergy: UITextField!
    @IBOutlet var textSpecialDietaryRequirement: UITextField!
    
    var portionSizeOptions: [String] = ["Full", "Half"]
    var menu: MenuModel = MenuModel()
    var ingredients: [IngredientModel] = []
    var selectedPortionSize = "Full"
    var cart: [OrderModel] = []
    var user_id: String = ""
    
    override func viewDidLoad() {
        
        populateIngredients()
        
        if let data = UserDefaults.standard.data(forKey: UserDefaultKeys.keyCart) {
            do {
                let decoder = JSONDecoder()
                cart = try decoder.decode([OrderModel].self, from: data)
            } catch {
                print("Unable to Decode Cart (\(error))")
            }
        }
        user_id = UserDefaults.standard.string(forKey: UserDefaultKeys.keyUserId) ?? "1"
        
        imageMenu.image = UIImage(named: menu.image_filename)
        imageMenu.contentMode = .scaleAspectFit
        imageMenu.layer.cornerRadius = 60
        imageMenu.clipsToBounds = true
        
        labelName.text = menu.name
        labelDetail.lineBreakMode = .byWordWrapping
        labelDetail.numberOfLines = 0
        labelDetail.text = menu.description
        labelPreparationTime.text = menu.preparation_time
        labelPrice.text = "Rs. \(menu.price)"
        
        labelIngredientsCount.text = "\(self.ingredients.count) Ingredients"
        
        textPreparationInstructions!.layer.borderWidth = 1
        textPreparationInstructions!.layer.borderColor = UIColor.black.cgColor
    
        pickerPortionSize.delegate = self
        pickerPortionSize.dataSource = self
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        portionSizeOptions.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return portionSizeOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
            selectedPortionSize = "Full"
            labelPrice.text = "Rs. \(menu.price)"
        } else if row == 1 {
            selectedPortionSize = "Half"
            labelPrice.text = "Rs. \(Int(menu.price)! / 2)"
        }
    }
    
    @IBAction func buttonPlaceOrder_Click(_ sender: UIButton) {
        
        if (textPreparationInstructions.text! == "" || textAnyAllergy.text! == "" ||
            textSpecialDietaryRequirement.text! == "") {
            let alert = UIAlertController(title: "Error", message: "Fill missing information", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let order = OrderModel()
        order.user_id = user_id
        order.menu_id = menu.id
        order.menu_name = menu.name
        order.dt = Common.getCurrentDateTimeInString()
        order.order_status = 1
        order.preparation_instructions = textPreparationInstructions.text!
        order.any_allergy = textAnyAllergy.text!
        order.special_dietary_requirements = textSpecialDietaryRequirement.text!
        order.portionSize = selectedPortionSize
        order.price = (Int(menu.price)) ?? 0
        cart.append(order)
        do {
            let encoder = JSONEncoder()
            let cartEncoded = try encoder.encode(cart)
            UserDefaults.standard.set(cartEncoded, forKey: UserDefaultKeys.keyCart)
        } catch {
            print("error")
        }
        
        let alert = UIAlertController(title: "Information", message: "Added to your Cart", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func populateIngredients() {
        let sem = DispatchSemaphore.init(value: 0)
        var components = URLComponents(string: Common.BaseURL + "food_buddy_api/api.php")!
        components.queryItems = [
            URLQueryItem(name: "action", value: "get_menu_ingredients"),
            URLQueryItem(name: "menu_id", value: menu.id)
        ]
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        let request = URLRequest(url: components.url!)
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            
            defer { sem.signal() }
            //print(response!)
            do {
                self.ingredients = []
                let json = try JSONSerialization.jsonObject(with: data!) as! NSDictionary
                
                if (json.count == 3 && (json["status"] as! String) == "true")
                {
                    let ingredients = json["menu_ingredients"] as! NSArray
                    for i in 0..<ingredients.count {
                        let item = ingredients[i] as! Dictionary<String, String>
                        let ingredient = IngredientModel()
                        ingredient.id = item["id"] ?? "0"
                        ingredient.name = item["name"] ?? ""
                        
                        self.ingredients.append(ingredient)
                    }
                }
            } catch {
                print("error")
            }
        });
        task.resume();
        sem.wait()
    }
}
