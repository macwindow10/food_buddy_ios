//
//  RestaurantsViewController.swift
//  food_buddy
//
//  Created by Mac on 10/10/2023.
//

import Foundation
import UIKit

class AdminRestaurantsViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableRestaurants: UITableView!
    
    var userType: String
    let defaults = UserDefaults.standard
    var restaurants: [RestaurantModel] = []
    
    override func viewDidLoad() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(self.onBack))
        userType = UserDefaults.standard.string(forKey: UserDefaultKeys.keyType) ?? "user"
        populateRestaurants()
    }
    
    func populateRestaurants() {
        var components = URLComponents(string: Common.BaseURL + "food_buddy_api/api.php")!
        components.queryItems = [
            URLQueryItem(name: "action", value: "get_restaurants"),
            URLQueryItem(name: "name", value: "")
        ]
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        let request = URLRequest(url: components.url!)
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            
            //print(response!)
            do {
                self.restaurants = []
                let json = try JSONSerialization.jsonObject(with: data!) as! NSDictionary
                //print(json)
                if (json.count == 3 && (json["status"] as! String) == "true")
                {
                    let restaurants = json["restaurants"] as! NSArray
                    for i in 0..<restaurants.count {
                        let item = restaurants[i] as! Dictionary<String, String>
                        let restaurant = RestaurantModel()
                        restaurant.id = item["id"] ?? "0"
                        restaurant.name = item["name"] ?? ""
                        restaurant.rating = item["rating"] ?? ""
                        restaurant.address = item["address"] ?? ""
                        restaurant.city = item["city"] ?? ""
                        restaurant.contact = item["contact_number"]!
                        restaurant.cuisine = item["restaurant_type"] ?? ""
                        restaurant.image_filename = item["image_filename"] ?? ""
                        
                        self.restaurants.append(restaurant)
                    }
                    DispatchQueue.main.async {
                        self.tableRestaurants.dataSource = self;
                        self.tableRestaurants.delegate = self;
                        self.tableRestaurants.reloadData()
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
        return self.restaurants.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableRestaurants.dequeueReusableCell(withIdentifier: "cell", for: indexPath);
        if (indexPath.row < 0 || indexPath.row >= self.restaurants.count) {
            return cell
        }
        cell.textLabel?.text = self.restaurants[indexPath.row].name +
        ". Cuisine: \(self.restaurants[indexPath.row].cuisine). Rating: \(self.restaurants[indexPath.row].rating). Contact: \(self.restaurants[indexPath.row].contact). Address: \(self.restaurants[indexPath.row].address). City: \(self.restaurants[indexPath.row].city)";
        
        cell.textLabel?.numberOfLines = 0
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
              return 150
        }
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("selected cell \(indexPath.row)")
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "vcMenu") as! MenuViewController
        vc.restaurant_id = "\(self.restaurants[indexPath.row].id)"
        tableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
