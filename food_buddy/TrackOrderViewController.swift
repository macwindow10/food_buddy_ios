//
//  TrackOrderViewController.swift
//  food_buddy
//
//  Created by Mac on 03/12/2023.
//

import Foundation
import UIKit
import MapKit

class TrackOrderViewController: UIViewController {
    
    @IBOutlet private var mapView: MKMapView!

    var timer = Timer()
    var initialLocation = CLLocation(latitude: 31.5539, longitude: 74.33294)
    var orderId: String = "1"
    
    override func viewDidLoad() {
        
        mapView.mapType = .standard
        mapView.isZoomEnabled = true;
        mapView.isScrollEnabled = true;
        mapView.showsCompass = true
        mapView.showsUserLocation = true
        mapView.showsTraffic = true
        mapView.showsScale = true
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { _ in
            self.updateLocation()
        })
    }
    
    func updateLocation() {
        
        var components = URLComponents(string: Common.BaseURL + "food_buddy_api/api.php")!
        components.queryItems = [
            URLQueryItem(name: "action", value: "get_order_location"),
            URLQueryItem(name: "order_id", value: orderId)
        ]
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        let request = URLRequest(url: components.url!)
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            
            //print(response!)
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! NSDictionary
                //print(json)
                if (json.count == 3 && (json["status"] as! String) == "true")
                {
                    let order_locations = json["order_location"] as! NSArray
                    for i in 0..<order_locations.count {
                        let item = order_locations[i] as! Dictionary<String, String>
                        
                        let latitude = Double(item["latitude"]!)!
                        let longitude = Double(item["longitude"]!)!
                        self.initialLocation = CLLocation(latitude: latitude, longitude: longitude)
                        
                        DispatchQueue.main.async {
                            
                            self.mapView.removeAnnotations(self.mapView.annotations)
                            
                            self.mapView.centerToLocation(self.initialLocation, regionRadius: 10000)
                            let annotation = MKPointAnnotation()
                            annotation.title = "Rider location"
                            annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
                            self.mapView.addAnnotation(annotation)
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

private extension MKMapView {
  func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}
