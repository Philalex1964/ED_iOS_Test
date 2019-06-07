//
//  Item.swift
//  MealDealTest
//
//  Created by Александр Филиппов on 16.04.2019.
//  Copyright © 2019 Philalex. All rights reserved.
//

import UIKit
import SwiftyJSON

class Item: Codable {
    let itemDescription: String
    let retailer: String
    let imageURL: String
    let price: Double
    let discount: Int16
    var addedItem: Bool?    
    
    init(_ json: JSON) {
        self.itemDescription = json["description"].stringValue
        self.retailer = json["retailer"].stringValue
        self.imageURL = json["image"].stringValue
        self.price = json["price"].double ?? 0
        self.discount = json["discount"].int16 ?? 0
        self.addedItem = addedItem ?? false
        }
}
