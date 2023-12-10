//
//  CartViewController.swift
//  food_buddy
//
//  Created by Mac on 03/12/2023.
//

import Foundation
import UIKit

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var tableCart: UITableView!
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var labelDeliveredToAddress: UILabel!
    @IBOutlet var labelTotal: UILabel!
    
    var paymentMethodOptions: [String] = ["Cash On Delivery", "Stripe"]
    var selectedPaymentMethod: String = "Cash On Delivery"
    var cart: [OrderModel] = []
    var user_id: String = ""
    var total = 0.0
    
    override func viewDidLoad() {
        if let data = UserDefaults.standard.data(forKey: UserDefaultKeys.keyCart) {
            do {
                let decoder = JSONDecoder()
                cart = try decoder.decode([OrderModel].self, from: data)
                if cart.count == 0 {
                    self.navigationController?.popViewController(animated: true)
                    return
                }
                
                total = 0.0
                for o in cart {
                    total = total + Double(o.price)
                }
                labelTotal.text = "Total: \(total)"
                
                self.tableCart.dataSource = self;
                self.tableCart.delegate = self;
                self.tableCart.reloadData()
                
            } catch {
                print("Unable to Decode Cart (\(error))")
            }
        }
        user_id = UserDefaults.standard.string(forKey: UserDefaultKeys.keyUserId) ?? "1"
        
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cart.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableCart.dequeueReusableCell(withIdentifier: "cell2", for: indexPath);
        if (indexPath.row < 0 || indexPath.row >= self.cart.count) {
            return cell
        }
        cell.textLabel?.text = "Food Item: \(self.cart[indexPath.row].menu_name). Date: \(self.cart[indexPath.row].dt). Preparation Instructions: \(self.cart[indexPath.row].preparation_instructions). Special Dietary Requirements: \(self.cart[indexPath.row].special_dietary_requirements). Any Allergy: \(self.cart[indexPath.row].any_allergy). Price: \(self.cart[indexPath.row].price).";
        
        cell.textLabel?.numberOfLines = 0
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
              return 150
        }
        return 150
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        paymentMethodOptions.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return paymentMethodOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedPaymentMethod = paymentMethodOptions[row]
    }
    
    @IBAction func buttonClicked_PlaceOrder(_ sender: UIButton) {
        for order in cart {
            placeOrder(order: order)
        }
        
        // clear the cart after older placement
        do {
            cart = []
            let encoder = JSONEncoder()
            let cartEncoded = try encoder.encode(cart)
            UserDefaults.standard.set(cartEncoded, forKey: UserDefaultKeys.keyCart)
        } catch {
            print("error")
        }
        
        /*
            let alert = UIAlertController(title: "Information", message: "Order placed successfully", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                // self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
            */
        
        if selectedPaymentMethod == "Stripe" {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "vcStripePayment") as! StripePaymentViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func placeOrder(order: OrderModel) {
        let sem = DispatchSemaphore.init(value: 0)
        var components = URLComponents(string: Common.BaseURL + "food_buddy_api/api.php")!
        components.queryItems = [
            URLQueryItem(name: "action", value: "place_order"),
            URLQueryItem(name: "menu_id", value: order.menu_id),
            URLQueryItem(name: "user_id", value: order.user_id),
            URLQueryItem(name: "date_time", value: order.dt),
            URLQueryItem(name: "portionSize", value: order.portionSize),
            URLQueryItem(name: "preparation_instructions", value: order.preparation_instructions),
            URLQueryItem(name: "special_dietary_requirements", value: order.special_dietary_requirements),
            URLQueryItem(name: "any_allergy", value: order.any_allergy),
            URLQueryItem(name: "order_status", value: String(order.order_status)),
            URLQueryItem(name: "price", value: String(order.price))
        ]
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        let request = URLRequest(url: components.url!)
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            
            defer { sem.signal() }
            //print(response!)
            do {
                let s = String(bytes: data!, encoding: .utf8)
                let json = try JSONSerialization.jsonObject(with: data!) as! NSDictionary
                
                if (json.count == 3 && (json["status"] as! String) == "true")
                {
                    
                }
            } catch {
                print("error")
            }
        });
        task.resume();
        sem.wait()
    }
}
