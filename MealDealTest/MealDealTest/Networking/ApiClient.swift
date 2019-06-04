//
//  ApiClient.swift
//  MealDealTest
//
//  Created by Alexander Filippov on 31/05/2019.
//  Copyright © 2019 Philalex. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import CoreData

class ApiClient {

    static let shared = ApiClient()
    
    public func getItems(completion: ((Swift.Result<[Item], Error>) -> Void)? = nil) {
        let baseUrl = "https://api.edadev.ru"
        let path = "/intern/"

        
        Alamofire.request(baseUrl + path, method: .get).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let items = json.arrayValue.map { Item($0) }
                completion?(.success(items))
                //print(json)
                //print(items[0].itemDescription)
//                let item = ItemMO(context:  AppDelegate().persistentContainer.viewContext)
//                
//                for _ in items {
//                    item.itemDescription = items[0].itemDescription
//                    item.retailer = items[0].retailer
//                    item.imageURL = items[0].imageURL
//                    item.price = items[0].price
//                    item.discount = items[0].discount
//                }
//                AppDelegate().saveContext()
                
//                self.saveJsonData()
            case .failure(let error):
                completion?(.failure(error))
                print(error)
            }
        }
    }
    
//    public func saveJsonData() {
//        let item = ItemMO(context:  self.persistentContainer.viewContext)
//        let json = JSON((Any).self)
//
//        item.itemDescription = json["description"].stringValue
//        item.retailer = json["retailer"].stringValue
//        item.imageURL = json["image"].stringValue
//        item.price = json["price"].double ?? 0
//        item.discount = json["discount"].int16 ?? 0
////
//        AppDelegate().saveContext()
//
//
//    }
}
