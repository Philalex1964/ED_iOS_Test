//
//  ShopService.swift
//  MealDealTest
//
//  Created by Alexander Filippov on 31/05/2019.
//  Copyright © 2019 Philalex. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData
import Alamofire

class ShopService {
    
//
    
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "ItemModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    public func fetchAndInsertItems() {
//        ApiClient().getItems()
//        let items = [Item]()
//        let item = ItemMO()
//        
//        for i in items {
//            items[i].itemDescription = item.itemDescription
//            item.retailer = items[i].retailer
//            item.imageURL = items[i].imageURL
//            item.price = items[i].price
//            item.discount = items[i].discount
//        }
//        AppDelegate().saveContext()
    }
    
    public func getItems(completion: ((Swift.Result<[Item], Error>) -> Void)? = nil) {
        let baseUrl = "https://api.edadev.ru"
        let path = "/intern/"
        
        
        Alamofire.request(baseUrl + path, method: .get).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                var items = json.arrayValue.map { Item($0) }
                completion?(.success(items))
            case .failure(let error):
                completion?(.failure(error))
                print(error)
            }
        }
    }
    
    public func addItem() {
        
    }
    
    public func deleteItem() {
        
    }
    
//    init(_ json: JSON) {
//       
//    }
    
//    public func getItems(completion: ((Swift.Result<[Item], Error>) -> Void)? = nil) {
//        let baseUrl = "https://api.edadev.ru"
//        let path = "/intern/"
//
//        Alamofire.request(baseUrl + path, method: .get).responseJSON { response in
//            switch response.result {
//            case .success(let value):
//                let json = JSON(value)
//                let items = json.arrayValue.map { Item($0) }
//                completion?(.success(items))
//                print(json)
    
//            case .failure(let error):
//                completion?(.failure(error))
//                print(error)
//            }
//        }
//    }

    
//    public func saveJsonData() {
//        let item = ItemMO(context:  self.persistentContainer.viewContext)
//        let json = JSON(NSValue())
//        
//        
//        item.itemDescription = json["description"].stringValue
//        item.retailer = json["retailer"].stringValue
//        item.imageURL = json["image"].stringValue
//        item.price = json["price"].double!
//        item.discount = json["discount"].int16!
//        
//        AppDelegate().saveContext()
//        
//        
//    }

}
