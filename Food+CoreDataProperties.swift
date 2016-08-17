//
//  Food+CoreDataProperties.swift
//  GroceryList
//
//  Created by Adam Zarn on 8/16/16.
//  Copyright © 2016 Adam Zarn. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Food {

    @NSManaged var name: String?
    @NSManaged var price: NSNumber?
    @NSManaged var imageName: String?
    @NSManaged var baseUnit: String?
    @NSManaged var aisleNumber: NSNumber?
    @NSManaged var numberSelected: NSNumber?
    @NSManaged var isSelected: NSNumber?

}
