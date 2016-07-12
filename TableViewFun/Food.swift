//
//  Person.swift
//  TableViewFun
//
//  Created by Adam Zarn on 3/22/16.
//  Copyright © 2016 Adam Zarn. All rights reserved.
//

import Foundation

class Food {
    var name = "name"
    var price:Float = 0.0
    var image1Name = "blank"
    var image2Name = "blank"
    
    init(name: String, price: Float, image1Name: String, image2Name: String) {
        self.name = name
        self.price = price
        self.image1Name = image1Name
        self.image2Name = image2Name
    }
    
}
