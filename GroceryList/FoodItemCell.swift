//
//  FoodItemCell.swift
//  TableViewFun
//
//  Created by Adam Zarn on 7/12/16.
//  Copyright © 2016 Adam Zarn. All rights reserved.
//

import UIKit

class FoodItemCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var FoodName: UILabel!
    @IBOutlet weak var FoodAisle: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    
}
