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

//    // MARK: - Core Data stack
//
//    lazy var persistentContainer: NSPersistentContainer = {
//
//        let container = NSPersistentContainer(name: "ItemModel")
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//        return container
//    }()
    
//    public func fetchAndInsertItems() {
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
//    }
    
    public func getItems(completion: ((Swift.Result<[Item], Error>) -> Void)? = nil) {
        let baseUrl = "https://api.edadev.ru"
        let path = "/intern/"
        
        
        Alamofire.request(baseUrl + path, method: .get).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let items = json.arrayValue.map { Item($0) } as NSArray
                completion?(.success(items as! [Item]))
                
                for dict in items {
                    //let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let context = AppDelegate().persistentContainer.viewContext
                    let entity = NSEntityDescription.entity(forEntityName: "Item", in: context)!
                    let item = ItemMO(entity: entity,
                                      insertInto: context)
                    let itemDict = dict as! [String : Any]
                    
                    item.itemDescription = itemDict["itemDescription"] as? String
                    item.retailer = itemDict["retailer"] as? String
                    item.imageURL = itemDict["imageURL"] as? String
                    item.price = itemDict["price"] as? Double ?? 0
                    item.discount = itemDict["discount"] as? Int16 ?? 0
                    
                }
                AppDelegate().saveContext()
                
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
