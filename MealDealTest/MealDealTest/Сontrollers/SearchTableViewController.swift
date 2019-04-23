//
//  SearchTableViewController.swift
//  MealDealTest
//
//  Created by Александр Филиппов on 16.04.2019.
//  Copyright © 2019 Philalex. All rights reserved.
//

import UIKit
import CoreData

class SearchTableViewController: UITableViewController, UISearchBarDelegate, NSFetchedResultsControllerDelegate  {
    
    @IBOutlet weak var searchTableView: UITableView!
    
    @IBOutlet weak var SearchBar: UISearchBar!
    
    var item: ItemMO!
    
    var fetchResultController: NSFetchedResultsController<ItemMO>!
    
    public var items: [ItemMO] = []

    var searchItems = [ItemMO]()
    var searching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - Fetch data from data store
        let fetchRequest: NSFetchRequest<ItemMO> = ItemMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "itemDescription", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
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
                }
            } catch {
                print(error)
            }
        }

        let tapGR = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        searchTableView.addGestureRecognizer(tapGR)
        
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
    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        if searching {
//            return 1
//        }
//        return 1
//    }
    

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
        } else {

        cell.itemDescriptionLabel.text = items[indexPath.row].itemDescription
        cell.itemImage.image = UIImage(named: items[indexPath.row].imageName!)
        cell.retailerLabel.text = items[indexPath.row].retailer
        cell.priceLabel.text = "\(items[indexPath.row].price)"
        cell.discountLabel.text = String(format:"%d", items[indexPath.row].discount)
        }
        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
 
    @objc private func keyboardWasHidden(notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        
        searchTableView.contentInset = contentInsets
    }
    
    @objc private func hideKeyboard() {
        searchTableView.endEditing(true)
    }
    
    func searchBar (_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchItems = items.filter({$0.itemDescription!.prefix(searchText.count) == searchText})
        searching = true
        tableView.reloadData()
        
        //searchItems.removeAll()
        
    }
}



