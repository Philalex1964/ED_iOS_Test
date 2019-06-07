//
//  SearchTableViewController.swift
//  MealDealTest
//
//  Created by Александр Филиппов on 16.04.2019.
//  Copyright © 2019 Philalex. All rights reserved.
//

import UIKit
import CoreData
import Kingfisher

class SearchTableViewController: UITableViewController, UISearchBarDelegate, NSFetchedResultsControllerDelegate  {
    
    @IBOutlet weak var searchTableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    
    lazy var fetchResultsController: NSFetchedResultsController<ItemMO>? = {
        let fetchRequest: NSFetchRequest<ItemMO> = ItemMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "itemDescription", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        guard let appDelegate : AppDelegate = UIApplication.shared.delegate as? AppDelegate else {return nil}
        let context = appDelegate.persistentContainer.viewContext
        let fetchResultsController = NSFetchedResultsController(fetchRequest:fetchRequest,
                                                                managedObjectContext: context,
                                                                sectionNameKeyPath: nil,
                                                                cacheName: nil)
        fetchResultsController.delegate = self
        return fetchResultsController
    }()
    
    public var items: [ItemMO] = []

    var searchItems = [ItemMO]()
    var searching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchItems = items
        
        //MARK: - Fetch data from data store
        let fetchRequest: NSFetchRequest<ItemMO> = ItemMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "itemDescription", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,                                                     managedObjectContext: context,                                                  sectionNameKeyPath: nil,
                                                               cacheName: nil)
            fetchResultsController?.delegate = self
            do {
                try fetchResultsController.performFetch()
                if let fetchedObjects = fetchResultsController.fetchedObjects {
                    items = fetchedObjects
                }
            } catch {
                print(error)
            }
        }

        let tapGR = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        
        searchTableView.addGestureRecognizer(tapGR)
        searchTableView.tableHeaderView = searchBar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchItems.count
        } else {
            return items.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ItemCell.reuseId, for: indexPath) as? ItemCell else { fatalError("Cell cannot be dequeued")}
        if searching {
            cell.itemDescriptionLabel.text = searchItems[indexPath.row].itemDescription
            cell.itemImage.kf.setImage(with: URL(string: items[indexPath.row].imageURL ?? ""))
            cell.retailerLabel.text = searchItems[indexPath.row].retailer
            cell.priceLabel.text = "\(searchItems[indexPath.row].price)"
            cell.discountLabel.text = String(format:"%d", searchItems[indexPath.row].discount)
            
            cell.indexPath = indexPath
            cell.actionBlock = { (selectedIndexPath: IndexPath?) in
                self.addToCart(selectedIndexPath: selectedIndexPath)
            }
            
        } else {
            
        cell.itemDescriptionLabel.text = items[indexPath.row].itemDescription
        cell.itemImage.kf.setImage(with: URL(string: items[indexPath.row].imageURL ?? ""))
        cell.retailerLabel.text = items[indexPath.row].retailer
        cell.priceLabel.text = "\(items[indexPath.row].price)"
        cell.discountLabel.text = String(format:"%d", items[indexPath.row].discount)
            
            cell.indexPath = indexPath
            cell.actionBlock = { (selectedIndexPath: IndexPath?) in
                self.addToCart(selectedIndexPath: selectedIndexPath)
            }
        }
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let button : UIButton = sender as! UIButton
        let cell : UITableViewCell = button.superview?.superview as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
        guard let index = indexPath?.row else { return }
        let item = items[index]
        
        let purchaseVC = segue.destination as! PurchaseTableViewController
        purchaseVC.item = item
    }
 
    @objc private func keyboardWasHidden(notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        
        searchTableView.contentInset = contentInsets
    }
    
    @objc private func hideKeyboard() {
        searchTableView.endEditing(true)
    }
    
    func searchBar (_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchItems = items.filter { item in
            return item.itemDescription?.lowercased().contains(searchText.lowercased()) ?? true
        }

        searching = true
        tableView.reloadData()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let fetchedObjects = fetchResultsController.fetchedObjects {
            items = fetchedObjects
        }
        searching = false
        tableView.reloadData()
    }
    
    public func addToCart(selectedIndexPath: IndexPath?) {
        let appDelegate = (UIApplication.shared.delegate as? AppDelegate)
        let context = appDelegate!.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Item", in: context)!

        var itemAdded: ItemMO?
        
        itemAdded = items[selectedIndexPath!.row]
        
        itemAdded?.addedItem = true
    
        AppDelegate.shared.saveContext()
        
    }
}





