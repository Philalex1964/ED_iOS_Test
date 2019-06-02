//
//  AppDelegate.swift
//  MealDealTest
//
//  Created by Александр Филиппов on 16.04.2019.
//  Copyright © 2019 Philalex. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "ItemModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ItemSavingManager().savePlist()
//        ItemSavingManager().loadFromFile()
        ItemSavingManager().insertItemData()
//       let item = ItemMO(context: self.persistentContainer.viewContext)

//        item.itemDescription = json["description"].stringValue
//        item.retailer = json["retailer"].stringValue
//        item.imageURL = json["image"].stringValue
//        item.price = json["price"].double
//        item.discount = json["discount"].int16
        
        
//        item.itemDescription = "Кока-Кола"
//        item.retailer = "Ашан"
//        item.price = 59.99
//        item.discount = 20
//        item.imageURL = "20"
//        
//        saveContext()
        
//        ShopService().getItems()
//        ApiClient().saveJsonData()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
       
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
     
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
      
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }

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
 
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

