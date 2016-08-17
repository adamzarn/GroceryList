//
//  ViewController.swift
//  TableViewFun
//
//  Created by Adam Zarn on 3/22/16.
//  Copyright © 2016 Adam Zarn. All rights reserved.
//

import UIKit
import CoreData
import BTNavigationDropdownMenu

struct Numbers {
    static var num = 0
    static var cost:Float = 0.0
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var cost: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var myTableView: UITableView!
    
    @IBAction func generateList(sender: AnyObject) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.saveContext()
        let listView = self.storyboard!.instantiateViewControllerWithIdentifier("ListViewController") as! ListViewController
        self.navigationController!.pushViewController(listView, animated: true)
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        let totalCost = 1.0825*(costValue*0.95)
        listView.costString = "Total REDcard cost with tax: " + String(formatter.stringFromNumber(totalCost)!)
    }
    
    var costValue = 0.0
    var navBarTitle: String!
    var firstLoad = true
    var lastNumberOfUnits = "1"
    var foodItems = [NSManagedObject]()
    let section = ["Produce","W1/W2","W3/W4","W5/W6","W7/W8","W9/W10","W11/W12","W13/W14","W15/W16","W17/W18","W19/W20","W21/W22","W23/W24","W25/W26","W27/W28","W29/W30","South Wall"]
    var fullArray: [[NSManagedObject]] = []
    var tempArray: [NSManagedObject] = []
    var indexOfSectionToDisplay: Int = 0
    
    func updateCost(c: Double) {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        cost.title = String(formatter.stringFromNumber(c)!)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        lastNumberOfUnits = textField.text!
        textField.becomeFirstResponder()
        textField.text = ""
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text == "" {
            textField.text = "1"
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Food")
        
        do {
            let results = try context.executeFetchRequest(fetchRequest)
            foodItems = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        for index1 in 0...self.section.count - 1 {
            tempArray = []
            for index2 in 0...foodItems.count - 1 {
                if String(foodItems[index2].valueForKey("aisleNumber")!) == String(index1) {
                    tempArray.append(foodItems[index2])
                }
            }
            fullArray.append(tempArray)
        }
        
        
        if let cost = NSUserDefaults.standardUserDefaults().valueForKey("cost") {
            costValue = cost as! Double
        }

        updateCost(costValue)
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(ViewController.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
        
        let menuView = BTNavigationDropdownMenu(navigationController: self.navigationController,
                                                containerView: self.navigationController!.view,
                                                title: "Grocery List",
                                                items: ["Produce","W1/W2","W3/W4","W5/W6","W7/W8","W9/W10","W11/W12","W13/W14","W15/W16","W17/W18","W19/W20","W21/W22","W23/W24","W25/W26","W27/W28","W29/W30","South Wall"]
        )
        
        self.navBar.titleView = menuView
        menuView.arrowTintColor = UIColor.blackColor()
        
        menuView.didSelectItemAtIndexHandler = {(indexPath: Int) -> () in
            print("Did select item at index: \(indexPath)")
            let moveToIndexPath = NSIndexPath(forRow: 0, inSection: indexPath)
            self.myTableView.scrollToRowAtIndexPath(moveToIndexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        }
        menuView.shouldChangeTitleText = false
        
    }
    
    func didTapView() {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(animated: Bool) {

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.section[section]
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.section.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fullArray[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell: CustomCell = tableView.dequeueReusableCellWithIdentifier("Cell") as! CustomCell
        cell.checkBox.tag = (indexPath.section * 1000) + indexPath.row
        cell.units.tag = (indexPath.section * 1000) + indexPath.row
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(red: 1.0, green: 0.9, blue: 0.9, alpha: 1)
        }
        else {
            cell.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1)
        }
        
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        
        let currentAisleElement = self.fullArray[indexPath.section][indexPath.row]
        
        cell.units.delegate = self
        cell.units.text = String(currentAisleElement.valueForKey("numberSelected")!)
        
        let isSel = String(currentAisleElement.valueForKey("isSelected")!)
        
        if isSel == "0" {
            cell.checkBox.setImage(UIImage(named: "unchecked.png"), forState: UIControlState.Normal)
        } else {
            cell.checkBox.setImage(UIImage(named: "checked.png"), forState: UIControlState.Normal)
        }
        
        cell.setCell((currentAisleElement.valueForKey("name") as? String)!,
                     RightLabelString: String(formatter.stringFromNumber((currentAisleElement.valueForKey("price") as? Double)!)!),baseUnitLabel:(currentAisleElement.valueForKey("baseUnit") as? String)!,imageName: (currentAisleElement.valueForKey("imageName") as? String)!)
        return cell
    }
    

    @IBAction func textBoxEdited(sender: UITextField) {
        
        let textBoxRow = sender.tag % 1000
        let textBoxSection = (sender.tag - textBoxRow) / 1000

        let currentAisleElement = self.fullArray[textBoxSection][textBoxRow]
        currentAisleElement.setValue(Double(sender.text!), forKey: "numberSelected")
        
        if String(currentAisleElement.valueForKey("numberSelected")) == "" {
           currentAisleElement.setValue("1", forKey: "numberSelected")
        }
        
        let isSel = String(currentAisleElement.valueForKey("isSelected")!)
        let price = currentAisleElement.valueForKey("price") as! Double
        
        if isSel == "1" {
            costValue += price *
            Double(Float(String(currentAisleElement.valueForKey("numberSelected")!))! - Float(lastNumberOfUnits)!)
            
            updateCost(costValue)
        }
    }
    
    @IBAction func checkBoxPressed(sender: UIButton) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var selected = appDelegate.selectedFoods
        var i = 0
        
        let checkBoxRow = sender.tag % 1000
        let checkBoxSection = (sender.tag - checkBoxRow) / 1000
        
        let currentAisleElement = self.fullArray[checkBoxSection][checkBoxRow]
        
        let indexPath = NSIndexPath(forRow:checkBoxRow,inSection:checkBoxSection)
        let cell = myTableView.cellForRowAtIndexPath(indexPath) as! CustomCell
        
        if cell.checkBox.currentImage == UIImage(named:"unchecked.png") {
            
            cell.checkBox.setImage(UIImage(named: "checked.png"), forState: UIControlState.Normal)
            currentAisleElement.setValue(true, forKey: "isSelected")
            
            if selected.count == 0 {
                selected.append(currentAisleElement)
            } else {
                while i < selected.count {
                    let a1 = String(currentAisleElement.valueForKey("aisleNumber"))
                    
                    if a1 == String(selected[i].valueForKey("aisleNumber")) {
                        appDelegate.selectedFoods.insert(currentAisleElement,atIndex: i+1)
                        i = 1000
                    } else if a1 < String(selected[0].valueForKey("aisleNumber")) {
                            appDelegate.selectedFoods.insert(currentAisleElement,atIndex: 0)
                            i = 1000
                    } else if i < selected.count - 1 && a1 > String(selected[i].valueForKey("aisleNumber")) && a1 < String(selected[i+1].valueForKey("aisleNumber")) {
                        selected.insert(currentAisleElement,atIndex:i+1)
                        i = 1000
                    } else if i == selected.count - 1 && a1 > String(selected[i].valueForKey("aisleNumber")) {
                        selected.append(currentAisleElement)
                        i = 1000
                    } else {
                        i = i + 1
                    }
                }
            }
            if String(currentAisleElement.valueForKey("numberSelected")) == "" {
                currentAisleElement.setValue("1", forKey: "numberSelected")
            }
            
            let price = currentAisleElement.valueForKey("price")! as! Double
            let numSel = currentAisleElement.valueForKey("numberSelected")! as! Double

            costValue += price * numSel
        
        } else {
            cell.checkBox.setImage(UIImage(named: "unchecked.png"), forState: UIControlState.Normal)
            currentAisleElement.setValue(false,forKey:"isSelected")
            
            for selectedFood in selected {
                if String(currentAisleElement.valueForKey("name")) == String(selectedFood.valueForKey("name")) {
                    selected.removeAtIndex(i)
                } else {
                    i = i + 1
                }
            }
            
            if String(currentAisleElement.valueForKey("numberSelected")) == "" {
                currentAisleElement.setValue("1", forKey: "numberSelected")
            }
            
            let price = currentAisleElement.valueForKey("price")! as! Double
            let numSel = currentAisleElement.valueForKey("numberSelected")! as! Double
            
            costValue -= price * numSel
            
        }
    
    updateCost(costValue)
    NSUserDefaults.standardUserDefaults().setValue(costValue, forKey: "cost")
        
    }

    
    
}

