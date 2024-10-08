//
//  Common.swift
//  food_buddy
//
//  Created by Mac on 10/10/2023.
//

import Foundation

class Common {
    static var BaseURL: String = "http://127.0.0.1/"
    
    public static func getCurrentDateTimeInString() -> String {
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString = df.string(from: date)
        return dateString
    }
    
    public static func toDate(dateString dateString: String) -> Date {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm"
        let date = df.date(from: dateString)
        return date!
    }
    
    public static func toDate2(dateString dateString: String) -> Date {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = df.date(from: dateString)
        return date!
    }
    
    public static func getOrderStatus(orderStatus: Int) -> String {
        switch(orderStatus) {
        case 1: return "Order Placed";
        case 2: return "Preparing";
        case 3: return "Out for Delivery";
        case 4: return "Delivered";
        default: return "Order Placed";
        }
    }
    
    public static func isLoggedIn() -> Bool {
        let user_id = UserDefaults.standard.string(forKey: UserDefaultKeys.keyUserId)
        if user_id == nil {
            return false
        }
        return true
    }
}
