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
    
    var restaurants: [Restaurant] = []
    
    override func viewDidLoad() {
        // self.navigationItem.title = "Your Title"
        // self.title = "Restaurants"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(self.onBack))
        
        tableRestaurants.register(UITableViewCell.self,
                               forCellReuseIdentifier: "TableViewCell")
        
        // populateRestaurants()
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
            print(response!)
            do {
                self.restaurants = []
                let json = try JSONSerialization.jsonObject(with: data!) as! Array<Any>
                print(json)
                for i in 0..<json.count {
                    let item = json[i] as! Dictionary<String, Any>
                    // self.restaurants.append(item["name"] as! String)
                }
                DispatchQueue.main.async {
                    self.tableRestaurants.dataSource = self;
                    self.tableRestaurants.delegate = self;
                    self.tableRestaurants.reloadData()
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
        cell.name?.text = self.restaurants[indexPath.row].name;
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
              return 80
        }


       // Use the default size for all other rows.
       //return UITableView.automaticDimension
        return 80
    }
    
}
