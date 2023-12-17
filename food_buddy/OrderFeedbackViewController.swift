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
    
    override func viewDidLoad() {
        segmentRestaurant.selectedSegmentIndex = 3
        segmentDelivery.selectedSegmentIndex = 3
        segmentOverallExperience.selectedSegmentIndex = 3
    }
    
    @IBAction func buttonClick_Save(_ sender: UIButton) {
    }
    
    @IBAction func buttonClick_Cancel(_ sender: UIButton) {
    }
    
}
