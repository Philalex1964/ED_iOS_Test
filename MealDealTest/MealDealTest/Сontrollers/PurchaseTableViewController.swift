//
//  PurchaseTableViewController.swift
//  MealDealTest
//
//  Created by Александр Филиппов on 16.04.2019.
//  Copyright © 2019 Philalex. All rights reserved.
//

import UIKit

class PurchaseTableViewController: UITableViewController {
        
    @IBOutlet weak var purchaseTableView: UITableView!
    
    public var items: [Item] = [
        Item(description: "Молоко Простоквашино", price: 49.99, discount: 15, itemImageName: "40", retailer: "Лента"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PurchaseCell.reuseId, for: indexPath) as? PurchaseCell else { fatalError("Cell cannot be dequeued")}

        cell.purchaseDescriptionLabel.text = items[indexPath.row].description
        cell.purchaseItemImage.image = UIImage(named: items[indexPath.row].itemImageName!)
        cell.purchaseRetailerLabel.text = items[indexPath.row].retailer
        cell.purchasePriceLabel.text = "\(items[indexPath.row].price)"
        cell.purchaseDiscountLabel.text = String(format:"%d", items[indexPath.row].discount)

        return cell
    }
  

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

 
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    
    @IBAction func addToCart(segue: UIStoryboardSegue) {
        if let searchTableViewController = segue.source as? SearchTableViewController,
            let indexPath = searchTableViewController.tableView.indexPathForSelectedRow {
            let newItem = searchTableViewController.items[indexPath.row]
            
            guard !items.contains(where: { item -> Bool in
                return item.description == newItem.description
            }) else { return }
            items.append(newItem)
            //tableView.reloadData()
            let newIndexPath = IndexPath(item: items.count-1, section: 0)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
}
