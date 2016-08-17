//
//  ListViewController.swift
//  TableViewFun
//
//  Created by Adam Zarn on 4/7/16.
//  Copyright © 2016 Adam Zarn. All rights reserved.
//

import UIKit
import CoreData

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let section = ["Produce","W1/W2","W3/W4","W5/W6","W7/W8","W9/W10","W11/W12","W13/W14","W15/W16","W17/W18","W19/W20","W21/W22","W23/W24","W25/W26","W27/W28","W29/W30","South Wall"]
    
    var foodItems = [NSManagedObject]()
    var selected = [NSManagedObject]()
    
    @IBOutlet weak var TotalCost: UIBarButtonItem!
    var costString: String = ""
    
    override func viewWillAppear(animated: Bool) {
        TotalCost.title = costString
    }
    
    override func viewDidLoad() {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Food")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key:"aisleNumber", ascending: true),
                                        NSSortDescriptor(key:"name", ascending: true)]
        
        do {
            let results = try context.executeFetchRequest(fetchRequest)
            foodItems = results as! [NSManagedObject]
            for index in 0...foodItems.count - 1 {
                if String(foodItems[index].valueForKey("isSelected")!) == "1" {
                    selected.append(foodItems[index])
                }
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selected.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let currentCell = selected[indexPath.row]
        
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        
        let quantity = currentCell.valueForKey("numberSelected") as! Double
        let price = currentCell.valueForKey("price") as! Double
        let totalPrice = quantity * price
        
        let cell = tableView.dequeueReusableCellWithIdentifier("FoodItemCell") as! FoodItemCell
        
        let numSel = currentCell.valueForKey("numberSelected") as! Int
        let name = currentCell.valueForKey("name") as! String
        let baseUnit = currentCell.valueForKey("baseUnit") as! String
        let aisle = currentCell.valueForKey("aisleNumber") as! Int
        
        cell.FoodName.text = String(numSel)  + " " + name + " (" + baseUnit + ")"
        cell.totalPrice.text = String(formatter.stringFromNumber(totalPrice)!)
        cell.FoodAisle.text = section[aisle]
        
        return cell
        
    }
    
}