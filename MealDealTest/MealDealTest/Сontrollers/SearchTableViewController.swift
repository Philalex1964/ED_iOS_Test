//
//  SearchTableViewController.swift
//  MealDealTest
//
//  Created by Александр Филиппов on 16.04.2019.
//  Copyright © 2019 Philalex. All rights reserved.
//

import UIKit
import CoreData

class SearchTableViewController: UITableViewController {
    
    @IBOutlet weak var searchTableView: UITableView!
    
    var item: ItemMO!
    
    public var items: [ItemMO] = [
    
    ]
    
    
    
    
    
//    restaurant = RestaurantModel(context:
//    appDelegate.persistentContainer.viewContext)
//    restaurant.name = "Upstate"
//    restaurant.type = "Cafe"
//    restaurant.location = "New York"
   

    

    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGR = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        searchTableView.addGestureRecognizer(tapGR)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let request: NSFetchRequest<ItemMO> = ItemMO.fetchRequest()
            let context = appDelegate.persistentContainer.viewContext
            do {
                items = try context.fetch(request)
                //items.append(item)
            } catch {
                print(error)
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ItemCell.reuseId, for: indexPath) as? ItemCell else { fatalError("Cell cannot be dequeued")}

        cell.itemDescriptionLabel.text = items[indexPath.row].itemDescription
        cell.itemImage.image = UIImage(named: items[indexPath.row].imageName!)
        cell.retailerLabel.text = items[indexPath.row].retailer
        cell.priceLabel.text = "\(items[indexPath.row].price)"
        cell.discountLabel.text = String(format:"%d", items[indexPath.row].discount)
        
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
}

//extension SearchTableViewController: UITableViewDelegate {
    
//}
