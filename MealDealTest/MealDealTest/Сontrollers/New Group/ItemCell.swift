//
//  ItemCell.swift
//  MealDealTest
//
//  Created by Александр Филиппов on 16.04.2019.
//  Copyright © 2019 Philalex. All rights reserved.
//

import UIKit
import Kingfisher

class ItemCell: UITableViewCell {

    static let reuseId = "ItemCell"
    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemDescriptionLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var retailerLabel: UILabel!
    
    var actionBlock: ((_ indexPath: IndexPath?) -> ())?
    var indexPath: IndexPath?
    
    @IBAction func buttonHandler() {
        if let unwrappedBlock = actionBlock  {
            unwrappedBlock(indexPath)
        }
    }
    
    
    
//    public func configure(with item: Item) {
//        let itemDescription = String(item.itemDescription)
//        itemDescriptionLabel.text = itemDescription
//
//        let retailer = String(item.retailer)
//        retailerLabel.text = retailer
//
//        let price = String(item.price)
//        priceLabel.text = price
//
//        let discount = String(item.discount)
//        discountLabel.text = discount
//
//        let imageUrlString = item.imageURL
//        itemImage.kf.setImage(with: URL(string: imageUrlString))
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }
}
