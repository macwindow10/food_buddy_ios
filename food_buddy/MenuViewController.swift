//
//  MenuViewController.swift
//  food_buddy
//
//  Created by Mac on 13/10/2023.
//

import Foundation
import UIKit

class MenuViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableMenus: UITableView!
    
    var menus: [MenuModel] = []
    var restaurant_id: String = ""
    
    override func viewDidLoad() {
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(self.onBack))
        
        let cell = UINib(nibName: "MenuTableViewCell", bundle: nil)
        self.tableMenus.register(cell, forCellReuseIdentifier: "cell2")
        
        populateMenus()
    }
    
    func populateMenus() {
        var components = URLComponents(string: Common.BaseURL + "food_buddy_api/api.php")!
        components.queryItems = [
            URLQueryItem(name: "action", value: "get_menus"),
            URLQueryItem(name: "restaurant_id", value: self.restaurant_id)
        ]
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        let request = URLRequest(url: components.url!)
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            
            //print(response!)
            do {
                self.menus = []
                let json = try JSONSerialization.jsonObject(with: data!) as! NSDictionary
                //print(json)
                if (json.count == 3 && (json["status"] as! String) == "true")
                {
                    let menus = json["menus"] as! NSArray
                    for i in 0..<menus.count {
                        let item = menus[i] as! Dictionary<String, String>
                        let menu = MenuModel()
                        menu.id = item["id"] ?? "0"
                        menu.name = item["name"] ?? ""
                        menu.description = item["description"] ?? ""
                        menu.preparation_time = item["preparation_time"] ?? ""
                        menu.price = item["price"] ?? ""
                        menu.image_filename = item["image_filename"] ?? ""
                        
                        self.menus.append(menu)
                    }
                    DispatchQueue.main.async {
                        self.tableMenus.dataSource = self;
                        self.tableMenus.delegate = self;
                        self.tableMenus.reloadData()
                    }
                }
                
            } catch {
                print("error")
            }
        });
        task.resume();
    }
    
    @objc func onBack() {
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableMenus.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! MenuTableViewCell;
        print(indexPath.row)
        if (indexPath.row < 0 || indexPath.row >= self.menus.count) {
            return cell
        }
        cell.labelName?.text = self.menus[indexPath.row].name
        let img = UIImage(named: self.menus[indexPath.row].image_filename)
        if (img == nil) {
            cell.imagePicture.image = UIImage(named: "restaurant1")
        } else {
            cell.imagePicture.image = img
        }
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
              return 100
        }
        return 100
    }
}
