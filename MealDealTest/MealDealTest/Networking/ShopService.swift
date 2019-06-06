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
    
    static let shared = ShopService()
    
    public func getItems(completion: ((Swift.Result<[Item], Error>) -> Void)? = nil) {
        let baseUrl = "https://api.edadev.ru"
        let path = "/intern/"
        
        Alamofire.request(baseUrl + path, method: .get).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let items = json.arrayValue.map { Item($0) }
                completion?(.success(items))
                
                for plainItem: Item in items {
                    let appDelegate = (UIApplication.shared.delegate as? AppDelegate)
                    let context = appDelegate!.persistentContainer.viewContext
                    let entity = NSEntityDescription.entity(forEntityName: "Item", in: context)!
                    let managedItem = ItemMO(entity: entity,
                                      insertInto: context)
                    
                    managedItem.itemDescription = plainItem.itemDescription
                    managedItem.retailer = plainItem.retailer
                    managedItem.imageURL = plainItem.imageURL
                    managedItem.price = plainItem.price
                    managedItem.discount = plainItem.discount
                }
                AppDelegate.shared.saveContext()
                
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
}
