//
//  Item.swift
//  MealDealTest
//
//  Created by Александр Филиппов on 16.04.2019.
//  Copyright © 2019 Philalex. All rights reserved.
//

import UIKit
import SwiftyJSON

class Item {
    let description: String
    let retailer: String
    let imageURL: String
    let price: Double?
    let discount: Int16?
    
    
    init(_ json: JSON) {
        self.description = json["description"].stringValue
        self.retailer = json["retailer"].stringValue
        self.imageURL = json["image"].stringValue
        self.price = json["price"].double
        self.discount = json["discount"].int16
        }    
}

//{
//    "description": "Колбаса п/к \"Прима\" Дороничи",
//    "price": 99.9,
//    "discount": 23,
//    "image": "https://yastatic.net/q/edadeal-leonardo/re/300x300/items/155/orig/1187061.jpg?sig=9bbe6f8f22",
//    "retailer": "Суджук"
//},

//struct Item {
//    let description: String
//    let price: Decimal
//    let discount: Int
//    var itemImageName: String?
//    var retailer: String?
//}
