//
//  PurchaseTableViewController.swift
//  MealDealTest
//
//  Created by Александр Филиппов on 16.04.2019.
//  Copyright © 2019 Philalex. All rights reserved.
//

import UIKit
import CoreData

class PurchaseTableViewController: UITableViewController {
    
    static let shared = PurchaseTableViewController()
        
    @IBOutlet weak var purchaseTableView: UITableView!
    
    var item: ItemMO!
    
    public var items: [ItemMO] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PurchaseCell.reuseId, for: indexPath) as? PurchaseCell else { fatalError("Cell cannot be dequeued")}

        cell.indexPath = indexPath
        cell.actionBlock = { (selectedIndexPath: IndexPath?) in
            // тут у тебя уже есть selectedIndexPath нажатой ячейки
        }
        cell.purchaseDescriptionLabel.text = items[indexPath.row].description
        cell.purchaseItemImage.image = UIImage(named: items[indexPath.row].imageURL!)
        cell.purchaseRetailerLabel.text = items[indexPath.row].retailer
        cell.purchasePriceLabel.text = "\(items[indexPath.row].price)"
        cell.purchaseDiscountLabel.text = String(format:"%d", items[indexPath.row].discount)

        return cell
    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell: MyCell = tableView.dequeueReusableCell(withIdentifier: "identifier", for: indexPath) as? MyCell else {
//            return UITableViewCell()
//        }
//        cell.indexPath = indexPath
//        cell.actionBlock = { (selectedIndexPath: IndexPath?) in
//            // тут у тебя уже есть selectedIndexPath нажатой ячейки
//        }
//        return cell
//    }
  
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 
    }
    
    
    @IBAction func addToCart(segue: UIStoryboardSegue) {
        if let searchTableViewController = segue.source as? SearchTableViewController,
            let indexPath = searchTableViewController.tableView.indexPathForSelectedRow {
            let newItem = searchTableViewController.items[indexPath.row]
            
            guard !items.contains(where: { item -> Bool in
                return item.description == newItem.description
            }) else { return }
            items.append(newItem)
            tableView.reloadData()
            let newIndexPath = IndexPath(item: items.count-1, section: 0)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
    
    
}

