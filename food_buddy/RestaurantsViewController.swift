//
//  RestaurantsViewController.swift
//  food_buddy
//
//  Created by Mac on 10/10/2023.
//

import Foundation
import UIKit

class RestaurantsViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableRestaurants: UITableView!
    
    var restaurants: [RestaurantModel] = []
    
    override func viewDidLoad() {
        // self.navigationItem.title = "Your Title"
        // self.title = "Restaurants"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(self.onBack))
        
        let cell = UINib(nibName: "RestaurantTableViewCell", bundle: nil)
        self.tableRestaurants.register(cell, forCellReuseIdentifier: "cell")
        
        populateRestaurants()
        /*
            var rest: Restaurant = Restaurant()
            rest.id = 1
            rest.name = "Salt n Pepper"
            rest.address = "Liberty"
            rest.image_filename = "salt_n_pepper.jpg"
            self.restaurants.append(rest)
            
            rest = Restaurant()
            rest.id = 2
            rest.name = "Haveli"
            rest.address = "Opposite Badshahi Mosque"
            rest.image_filename = "haveli.jpg"
            self.restaurants.append(rest)
            
            self.tableRestaurants.dataSource = self;
            self.tableRestaurants.delegate = self;
            self.tableRestaurants.reloadData()
            */
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
                        restaurant.address = item["address"] ?? ""
                        restaurant.address = restaurant.address + ", " + item["city"]!
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
        return restaurants.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableRestaurants.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RestaurantTableViewCell;
        print(indexPath.row)
        if (indexPath.row < 0 || indexPath.row >= self.restaurants.count) {
            return cell
        }
        cell.labelName?.text = self.restaurants[indexPath.row].name;
        cell.labelCuisine?.text = "Cuisine: \(self.restaurants[indexPath.row].cuisine)"
        cell.labelLocation?.text = self.restaurants[indexPath.row].address;
        var img = UIImage(named: self.restaurants[indexPath.row].image_filename)
        if (img == nil) {
            cell.imagePicture.image = UIImage(named: "restaurant1")
        } else {
            cell.imagePicture.image = img
        }
        
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
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
