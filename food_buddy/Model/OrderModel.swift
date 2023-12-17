//
//  OrderModel.swift
//  food_buddy
//
//  Created by Mac on 03/12/2023.
//

import Foundation

class OrderModel: Codable {
    var id: String = ""
    var user_id: String = ""
    var menu_id: String = ""
    var menu_name: String = ""
    var dt: String = ""
    var dtDate: Date = Date()
    var preparation_instructions: String = ""
    var order_status: Int = 0
    var special_dietary_requirements: String = ""
    var any_allergy: String = ""
    var portionSize: String = ""
    var price: Int = 0
    var latitude: Float = 33.00
    var longitude: Float = 73.00
}
