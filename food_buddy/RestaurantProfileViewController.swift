//
//  RestaurantProfileViewController.swift
//  food_buddy
//
//  Created by Mac on 15/10/2023.
//

import UIKit

class RestaurantProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var restaurant: RestaurantModel = RestaurantModel()
    var restaurantReviews: [RestaurantReviewModel] = []
    
    @IBOutlet var tableRestaurantReviews: UITableView!
    @IBOutlet var imageRestaurant: UIImageView!
    @IBOutlet var labelName: UILabel!
    @IBOutlet var labelContact: UILabel!
    @IBOutlet var labelAddress: UILabel!
    @IBOutlet var labelRating: UILabel!
    @IBOutlet var labelCity: UILabel!
    @IBOutlet var labelCusine: UILabel!
    
    override func viewDidLoad() {
        
        imageRestaurant.image = UIImage(named: restaurant.image_filename)
        labelName.text = restaurant.name
        labelCusine.text = "Cusine: \(restaurant.cuisine)"
        labelContact.text = "Contact: \(restaurant.contact)"
        labelRating.text = "Rating: \(restaurant.rating)"
        labelAddress.text = "Address: \(restaurant.address)"
        labelCity.text = "City: \(restaurant.city)"
        
        populateRestaurantReviews()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.restaurantReviews.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableRestaurantReviews.dequeueReusableCell(withIdentifier: "cell2", for: indexPath);
        if (indexPath.row < 0 || indexPath.row >= self.restaurantReviews.count) {
            return cell
        }
        cell.textLabel?.text = "Feedback: \(self.restaurantReviews[indexPath.row].feedback). Rating: \(self.restaurantReviews[indexPath.row].rating). Delivery Service: \(self.restaurantReviews[indexPath.row].delivery_service). Overall Experience: \(self.restaurantReviews[indexPath.row].overall_experience). Date: \(self.restaurantReviews[indexPath.row].dt).";
        
        cell.textLabel?.numberOfLines = 0
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
              return 150
        }
        return 150
    }
    
    @objc func populateRestaurantReviews() {
        var components = URLComponents(string: Common.BaseURL + "food_buddy_api/api.php")!
        components.queryItems = [
            URLQueryItem(name: "action", value: "get_restaurant_reviews"),
            URLQueryItem(name: "restaurant_id", value: restaurant.id)
        ]
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        let request = URLRequest(url: components.url!)
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            
            do {
                self.restaurantReviews = []
                let s = String(bytes: data!, encoding: .utf8)
                let json = try JSONSerialization.jsonObject(with: data!) as! NSDictionary
                print(json)
                if (json.count == 3 && (json["status"] as! String) == "true")
                {
                    let reviews = json["restaurant_reviews"] as! NSArray
                    for i in 0..<reviews.count {
                        let item = reviews[i] as! Dictionary<String, String>
                        let review = RestaurantReviewModel()
                        review.id = item["id"] ?? "0"
                        review.feedback = item["feedback"] ?? ""
                        review.rating = item["rating"] ?? ""
                        review.delivery_service = item["delivery_service"] ?? ""
                        review.overall_experience = item["overall_experience"] ?? ""
                        review.dt = item["dt"] ?? ""
                        review.dtDate = Common.toDate2(dateString: review.dt)
                    
                        self.restaurantReviews.append(review)
                    }
                    self.restaurantReviews.sort(by: { $0.dtDate.compare($1.dtDate) == .orderedDescending })
                    
                    DispatchQueue.main.async {
                        self.tableRestaurantReviews.dataSource = self;
                        self.tableRestaurantReviews.delegate = self;
                        self.tableRestaurantReviews.reloadData()
                    }
                }
                
            } catch {
                print("error")
            }
        });
        task.resume();
    }
}
