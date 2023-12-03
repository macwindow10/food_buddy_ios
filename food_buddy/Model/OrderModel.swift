//
//  OrderModel.swift
//  food_buddy
//
//  Created by Mac on 03/12/2023.
//

class OrderModel: Codable {
    var id: String = ""
    var user_id: String = ""
    var menu_id: String = ""
    var dt: String = ""
    var preparation_instructions: String = ""
    var order_status: Int = 0
    var special_dietary_requirements: String = ""
    var any_allergy: String = ""
}
