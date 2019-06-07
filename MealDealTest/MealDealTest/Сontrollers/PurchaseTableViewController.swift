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
    
    lazy var fetchResultsController: NSFetchedResultsController<ItemMO>? = {
        let fetchRequest: NSFetchRequest<ItemMO> = ItemMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "itemDescription", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = NSPredicate(format: "addedItem == true")
        guard let appDelegate : AppDelegate = UIApplication.shared.delegate as? AppDelegate else {return nil}
        let context = appDelegate.persistentContainer.viewContext
        let fetchResultsController = NSFetchedResultsController(fetchRequest:fetchRequest,
                                                                managedObjectContext: context,
                                                                sectionNameKeyPath: nil,
                                                                cacheName: nil)
        fetchResultsController.delegate = self
        return fetchResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.fetchData()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fetchResultsController?.fetchedObjects?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PurchaseCell.reuseId, for: indexPath) as? PurchaseCell else { fatalError("Cell cannot be dequeued")}
        
        guard let item : ItemMO = self.fetchResultsController?.object(at: indexPath) else {return cell}
        cell.purchaseDescriptionLabel.text = item.itemDescription
        cell.purchaseItemImage.kf.setImage(with: URL(string: item.imageURL ?? ""))
        cell.purchaseRetailerLabel.text = item.retailer
        cell.purchasePriceLabel.text = "\(item.price)"
        cell.purchaseDiscountLabel.text = String(format:"%d", item.discount)
        
        cell.indexPath = indexPath
        cell.actionBlock = { (selectedIndexPath: IndexPath?) in
            self.deleteFromCart(selectedIndexPath: selectedIndexPath)
        }
        
        return cell
    }
    
    public func deleteFromCart(selectedIndexPath: IndexPath?) {
        guard let item: ItemMO = self.fetchResultsController?.object(at: selectedIndexPath!) else {return}
        item.addedItem = false
        let appDelegate = (UIApplication.shared.delegate as? AppDelegate)
        appDelegate?.saveContext()
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
    
    // MARK: - Private
    private func fetchData() {
        do {
            try self.fetchResultsController?.performFetch()
        } catch {
            print(error)
        }
    }
}

