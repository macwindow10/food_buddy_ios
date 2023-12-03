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
}
