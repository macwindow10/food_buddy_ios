//
//  CartViewController.swift
//  food_buddy
//
//  Created by Mac on 03/12/2023.
//

import Foundation
import UIKit

class OrdersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableOrders: UITableView!
    @IBOutlet var buttonToggleOrders: UIButton!
    
    var orders: [OrderModel] = []
    var user_id: String = ""
    var selectedOrderId: String = "0"
    var isFeedbackDialogPresented = 0;
    var showCompletedOrders: Bool = false
    
    override func viewDidLoad() {
        user_id = UserDefaults.standard.string(forKey: UserDefaultKeys.keyUserId) ?? "1"
        Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(populateOrders), userInfo: nil, repeats: true)
        populateOrders()
        
        buttonToggleOrders.titleLabel?.text = "Show Completed Orders"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if self.orders.count > 0
        {
            tableView.separatorStyle = .singleLine
            numOfSections = 1
            tableView.backgroundView = nil
        }
        else
        {
            let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text = "No order"
            noDataLabel.textColor = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView = noDataLabel
            tableView.separatorStyle = .none
        }
        return numOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orders.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableOrders.dequeueReusableCell(withIdentifier: "cell2", for: indexPath);
        if (indexPath.row < 0 || indexPath.row >= self.orders.count) {
            return cell
        }
        cell.textLabel?.text = "Food Item: \(self.orders[indexPath.row].menu_name). Date: \(self.orders[indexPath.row].dt). Status: \(Common.getOrderStatus(orderStatus: self.orders[indexPath.row].order_status)).";
        
        if (self.orders[indexPath.row].order_status == 1) {
            cell.backgroundColor = .clear
        } else if (self.orders[indexPath.row].order_status == 2) {
            cell.backgroundColor = UIColor.yellow
        } else if (self.orders[indexPath.row].order_status == 3) {
            cell.backgroundColor = .systemTeal
        } else if (self.orders[indexPath.row].order_status == 4) {
            cell.backgroundColor = .green
        }
        
        cell.textLabel?.numberOfLines = 0
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
              return 100
        }
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected row \(indexPath.row)")
        selectedOrderId = self.orders[indexPath.row].id
    }
    
    @IBAction func buttonClicked_ToggleOrders(_ sender: UIButton) {
        
        if (showCompletedOrders) {
            showCompletedOrders = false
            buttonToggleOrders.titleLabel?.text = "Show Completed Orders"
        } else {
            showCompletedOrders = true
            buttonToggleOrders.titleLabel?.text = "Hide Completed Orders"
        }
    }
    
    @IBAction func buttonClicked_TrackOrder(_ sender: UIButton) {
        if (selectedOrderId == "0") {
            let alert = UIAlertController(title: "Information", message: "Please select an order", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "vcTrackOrder") as! TrackOrderViewController
        vc.orderId = selectedOrderId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func populateOrders() {
        var components = URLComponents(string: Common.BaseURL + "food_buddy_api/api.php")!
        components.queryItems = [
            URLQueryItem(name: "action", value: "get_orders"),
            URLQueryItem(name: "user_id", value: user_id)
        ]
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        let request = URLRequest(url: components.url!)
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            
            do {
                self.orders = []
                let s = String(bytes: data!, encoding: .utf8)
                let json = try JSONSerialization.jsonObject(with: data!) as! NSDictionary
                // print(json)
                if (json.count == 3 && (json["status"] as! String) == "true")
                {
                    let orders = json["orders"] as! NSArray
                    for i in 0..<orders.count {
                        let item = orders[i] as! Dictionary<String, String>
                        let order = OrderModel()
                        order.id = item["id"] ?? "0"
                        order.menu_id = item["menu_id"] ?? ""
                        order.menu_name = item["menu_name"] ?? ""
                        order.dt = item["date_time"] ?? ""
                        order.dtDate = Common.toDate(dateString: order.dt)
                        order.order_status = Int(item["order_status"] ?? "1") ?? 1
                        order.latitude = Float(item["latitude"] ?? "33.00") ?? 33.00
                        order.longitude = Float(item["longitude"] ?? "73.00") ?? 73.00
                        order.is_feedback_given = Int(item["is_feedback_given"] ?? "0") ?? 0
                        
                        self.orders.append(order)
                    }
                    self.orders.sort(by: { $0.dtDate.compare($1.dtDate) == .orderedAscending })
                    
                    DispatchQueue.main.async {
                        self.tableOrders.dataSource = self;
                        self.tableOrders.delegate = self;
                        self.tableOrders.reloadData()
                        
                        let completedOrders = self.orders.filter({$0.order_status == 4 && $0.is_feedback_given == 0})
                        if (completedOrders.count > 0 && self.isFeedbackDialogPresented == 0) {
                            self.isFeedbackDialogPresented = 1
                            
                            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyBoard.instantiateViewController(withIdentifier: "vcOrderFeedback") as! OrderFeedbackViewController
                            vc.menu_id = completedOrders[0].menu_id
                            vc.order_id = completedOrders[0].id
                            self.navigationController?.pushViewController(vc, animated: true)
                            
                        }
                    }
                }
                
            } catch {
                print("error")
            }
        });
        task.resume();
    }
}
