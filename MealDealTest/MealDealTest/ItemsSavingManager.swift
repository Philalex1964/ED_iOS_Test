//
//  ItemsSavingManager.swift
//  MealDealTest
//
//  Created by Alexander Filippov on 01/06/2019.
//  Copyright © 2019 Philalex. All rights reserved.


import Foundation
import UIKit
import CoreData

class ItemSavingManager {
    
//    static let shared = ItemSavingManager()
//
//    init() {}
    
    var items  = [Item]()
    
    func savePlist() {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("ItemsArray.plist")
        print(path)
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(items)
            try data.write(to: path, options: .atomic)
        } catch {
            print("Error encoding item array")
        }
    }
    
    func loadFromFile() {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("ItemsArray.plist")
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            do {
                items = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding item array")
            }
        }
    }
    
    func deleteFileWith() {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("ItemsArray.plist")
        do {
            try FileManager.default.removeItem(at: path)
        } catch {
            print("Error while deleting category nested list")
        }
    }
    
    func insertItemData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetch: NSFetchRequest<ItemMO> = ItemMO.fetchRequest()
        fetch.predicate = NSPredicate(format: "itemDescription != nil")
        
        let count = try! context.count(for: fetch)
        
        if count > 0 {
            print(count)
            // SampleData.plist data already in Core Data
            return
        }
        
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("ItemsArray.plist")
        guard let dataArray = NSArray(contentsOf: path) else { return }
        
        for dict in dataArray {
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
    }
}

