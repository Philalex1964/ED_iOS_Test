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
                
                let appDelegate = (UIApplication.shared.delegate as? AppDelegate)
                let context = appDelegate!.persistentContainer.viewContext
               
                let oldIdentifiers = NSMutableArray()
                if let allItems : [ItemMO] = self.allItemsIn(context: context) {
                    for oldItem in allItems {
                        if oldItem.addedItem {
                            oldIdentifiers.add("\(oldItem.itemDescription ?? "")\(oldItem.retailer ?? "")")
                        }
                    }
                }
                
                self.deleteItemsIn(context: context)
                
                let entity = NSEntityDescription.entity(forEntityName: "Item", in: context)!
                for plainItem: Item in items {
                    let managedItem = ItemMO(entity: entity,
                                             insertInto: context)
                    
                    managedItem.itemDescription = plainItem.itemDescription
                    managedItem.retailer = plainItem.retailer
                    managedItem.imageURL = plainItem.imageURL
                    managedItem.price = plainItem.price
                    managedItem.discount = plainItem.discount
                    let identifier = "\(plainItem.itemDescription)\(plainItem.retailer)"
                    if oldIdentifiers.contains(identifier) {
                        managedItem.addedItem = true
                    }
                }
                AppDelegate.shared.saveContext()
                completion?(.success(items))
            case .failure(let error):
                completion?(.failure(error))
                print(error)
            }
        }
    }
    
    public func allItemsIn(context:NSManagedObjectContext) -> [ItemMO]? {
        let fetchRequest: NSFetchRequest<ItemMO> = ItemMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "itemDescription", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchResultsController = NSFetchedResultsController(fetchRequest:fetchRequest,
                                                                managedObjectContext: context,
                                                                sectionNameKeyPath: nil,
                                                                cacheName: nil)
        do {
            try fetchResultsController.performFetch()
        } catch {
            print(error)
        }
        return fetchResultsController.fetchedObjects
    }
    
    public func deleteItemsIn(context : NSManagedObjectContext) {
        if let fetchedObjects = self.allItemsIn(context: context) {
            for item in fetchedObjects {
                context.delete(item)
            }
        }
    }
}
