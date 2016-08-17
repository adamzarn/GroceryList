//
//  Food.swift
//  GroceryList
//
//  Created by Adam Zarn on 8/16/16.
//  Copyright © 2016 Adam Zarn. All rights reserved.
//

import Foundation
import CoreData

class Food: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    convenience init(name: String, price: Double, numberSelected: Double, isSelected: Bool, imageName: String, baseUnit: String, aisleNumber: Double, context : NSManagedObjectContext) {
        
        // An EntityDescription is an object that has access to all
        // the information you provided in the Entity part of the model
        // you need it to create an instance of this class.
        if let ent = NSEntityDescription.entityForName("Food", inManagedObjectContext: context) {
            self.init(entity: ent, insertIntoManagedObjectContext: context)
            self.name = name
            self.price = price
            self.numberSelected = 1
            self.isSelected = false
            self.imageName = imageName
            self.baseUnit = baseUnit
            self.aisleNumber = aisleNumber
        } else {
            fatalError("Unable to find Entity name!")
        }
        
    }

}
