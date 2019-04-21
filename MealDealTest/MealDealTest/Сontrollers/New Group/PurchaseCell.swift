//
//  PurchaseCell.swift
//  MealDealTest
//
//  Created by Александр Филиппов on 17.04.2019.
//  Copyright © 2019 Philalex. All rights reserved.
//

import UIKit

class PurchaseCell: UITableViewCell {
    
    static let reuseId = "PurchaseCell"
    

    @IBOutlet weak var purchaseDescriptionLabel: UILabel!
    @IBOutlet weak var purchaseItemImage: UIImageView!
    @IBOutlet weak var purchaseRetailerLabel: UILabel!
    @IBOutlet weak var purchasePriceLabel: UILabel!
    @IBOutlet weak var purchaseDiscountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
