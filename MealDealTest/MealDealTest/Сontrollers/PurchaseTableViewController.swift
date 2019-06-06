//
//  PurchaseTableViewController.swift
//  MealDealTest
//
//  Created by Александр Филиппов on 16.04.2019.
//  Copyright © 2019 Philalex. All rights reserved.
//

import UIKit
import CoreData
import Kingfisher

class PurchaseTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
        
    @IBOutlet weak var purchaseTableView: UITableView!
    
    var item: ItemMO!
    
    public var items: [ItemMO] = []
    
    var fetchResultController: NSFetchedResultsController<ItemMO>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //MARK: - Fetch data from data store
        let fetchRequest: NSFetchRequest<ItemMO> = ItemMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "itemDescription", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = NSPredicate(format: "addedItem == true")
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(fetchRequest:
                fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil,
                              cacheName: nil)
            fetchResultController.delegate = self
            do {
                try fetchResultController.performFetch()
                if let fetchedObjects = fetchResultController.fetchedObjects {
                    items = fetchedObjects
                    tableView.reloadData()
                }
            } catch {
                print(error)
            }
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PurchaseCell.reuseId, for: indexPath) as? PurchaseCell else { fatalError("Cell cannot be dequeued")}

        cell.purchaseDescriptionLabel.text = items[indexPath.row].itemDescription
        cell.purchaseItemImage.kf.setImage(with: URL(string: items[indexPath.row].imageURL ?? ""))
        cell.purchaseRetailerLabel.text = items[indexPath.row].retailer
        cell.purchasePriceLabel.text = "\(items[indexPath.row].price)"
        cell.purchaseDiscountLabel.text = String(format:"%d", items[indexPath.row].discount)
        
        cell.indexPath = indexPath
        cell.actionBlock = { (selectedIndexPath: IndexPath?) in
            self.deleteFromCart(selectedIndexPath: selectedIndexPath)
        }

        return cell
    }
  
    public func deleteFromCart(selectedIndexPath: IndexPath?) {
        let appDelegate = (UIApplication.shared.delegate as? AppDelegate)
        let context = appDelegate!.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Item", in: context)!
        
        var itemAdded: ItemMO?
        
        itemAdded = items[selectedIndexPath!.row]
        
        itemAdded?.addedItem = false
        
        AppDelegate.shared.saveContext()
        viewWillAppear(true)
      
    }
}

