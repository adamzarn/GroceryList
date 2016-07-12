//
//  CustomCell.swift
//  TableViewFun
//
//  Created by Adam Zarn on 3/22/16.
//  Copyright © 2016 Adam Zarn. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    
    @IBOutlet weak var LeftLabel: UILabel!
    @IBOutlet weak var RightLabel: UILabel!
    @IBOutlet weak var myImageView1: UIImageView!
    @IBOutlet weak var checkBox: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setCell(leftLabelText: String, RightLabelString: String, image1Name: String, image2Name: String) {
        self.LeftLabel.text = leftLabelText
        self.RightLabel.text = RightLabelString
        self.myImageView1.image = UIImage(named: image1Name)
        self.myImageView1.layer.borderWidth = 1
        self.myImageView1.layer.borderColor = UIColor.blackColor().CGColor
        self.myImageView1.layer.cornerRadius = self.myImageView1.frame.height/2
        self.myImageView1.clipsToBounds = true
    }
    

}
