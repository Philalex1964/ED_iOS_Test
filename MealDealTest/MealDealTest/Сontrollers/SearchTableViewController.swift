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
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        
        searchTableView.addGestureRecognizer(tapGR)
        searchTableView.tableHeaderView = searchBar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchData()
        
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
        let item : ItemMO = searching ? searchItems[indexPath.row] : items[indexPath.row]
        cell.itemDescriptionLabel.text = item.itemDescription
        cell.itemImage.kf.setImage(with: URL(string: item.imageURL ?? ""))
        cell.retailerLabel.text = item.retailer
        cell.priceLabel.text = "\(item.price)"
        cell.discountLabel.text = String(format:"%d", item.discount)
        cell.indexPath = indexPath
        cell.actionBlock = { (selectedIndexPath: IndexPath?) in
            self.addToCart(selectedIndexPath: selectedIndexPath)
        }
        return cell
    }
    
    // MARK: - Keyboard notifications
    @objc private func keyboardWasHidden(notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        
        searchTableView.contentInset = contentInsets
    }
    
    @objc private func hideKeyboard() {
        searchTableView.endEditing(true)
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let fetchedObjects = self.fetchResultsController?.fetchedObjects {
            items = fetchedObjects
        }
        tableView.reloadData()
    }
    
    // MARK: - UISearchBarDelegate    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBar (_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchItems = items.filter { item in
            return item.itemDescription?.lowercased().contains(searchText.lowercased()) ?? true
        }
        searching = true
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
        tableView.reloadData()
    }
    
    // MARK: - Private
    private func addToCart(selectedIndexPath: IndexPath?) {
        if let index = selectedIndexPath?.row {
            let item : ItemMO = searching ? searchItems[index] : items[index]
            item.addedItem = true
            let appDelegate = (UIApplication.shared.delegate as? AppDelegate)
            appDelegate?.saveContext()
        }
    }
    
    private func fetchData() {
        do {
            try self.fetchResultsController?.performFetch()
        } catch {
            print(error)
        }
    }
}





