//
//  OrderFeedbackViewController.swift
//  food_buddy
//
//  Created by Mac on 17/12/2023.
//

import UIKit

class OrderFeedbackViewController: UIViewController {
    
    @IBOutlet var textViewFeedback: UITextView!
    @IBOutlet var segmentRestaurant: UISegmentedControl!
    @IBOutlet var segmentDelivery: UISegmentedControl!
    @IBOutlet var segmentOverallExperience: UISegmentedControl!
    
    var order_id: String = "1"
    
    override func viewDidLoad() {
        segmentRestaurant.selectedSegmentIndex = 2
        segmentDelivery.selectedSegmentIndex = 2
        segmentOverallExperience.selectedSegmentIndex = 2
    }
    
    func getRating(option option: String) -> String {
        if (option == "restaurant") {
            return String(segmentRestaurant.selectedSegmentIndex + 1)
        } else if (option == "delivery") {
            return String(segmentDelivery.selectedSegmentIndex + 1)
        } else if (option == "overall") {
            return String(segmentOverallExperience.selectedSegmentIndex + 1)
        }
        return "2"
    }
    
    @IBAction func buttonClick_Save(_ sender: UIButton) {
        if (textViewFeedback.text! == "") {
            return
        }
        
        let Url = String(format: Common.BaseURL + "food_buddy_api/api.php")
            guard let serviceUrl = URL(string: Url) else { return }
        let parameterDictionary = [
            "action": "order_feedback",
            "order_id": self.order_id,
            "feedback": textViewFeedback.text!,
            "restaurant_rating": getRating(option: "restaurant"),
            "delivery_rating": getRating(option: "delivery"),
            "overall_rating": getRating(option: "overall")
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
                if (json.count == 2 && (json["status"] as! String) == "true")
                {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Information", message: "User registered successfully", preferredStyle: .alert)
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
    
    @IBAction func buttonClick_Cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
