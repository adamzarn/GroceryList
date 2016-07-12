//
//  ViewController.swift
//  TableViewFun
//
//  Created by Adam Zarn on 3/22/16.
//  Copyright © 2016 Adam Zarn. All rights reserved.
//

import UIKit

struct Numbers {
    static var num = 0
    static var cost:Float = 0.0
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var cost: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var lastAisle: UIBarButtonItem!
    @IBOutlet weak var nextAisle: UIBarButtonItem!
    @IBOutlet weak var myTableView: UITableView!
    var costValue = 0.0
    var navBarTitle: String!
    var firstLoad = true
    
    func updateCost(c: Double) {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        cost.title = String(formatter.stringFromNumber(c)!)
    }
    
    @IBAction func nextAisle(sender: AnyObject) {
        Numbers.num += 1
        self.loadView()
        
        if Numbers.num == 1 {
            aisleButtonUpdates(true,x:"Last Aisle",y:true,z:"Next Aisle")
        } else if Numbers.num == 16 {
            aisleButtonUpdates(true,x:"Last Aisle",y:false,z:"")
        }
        if Numbers.num == 17 {
            var listView: ListViewController
            listView = self.storyboard?.instantiateViewControllerWithIdentifier("ListViewController") as! ListViewController
            presentViewController(listView, animated: false, completion: nil)
        }

        let x = myTableView.frame.origin.x
        let y = myTableView.frame.origin.y
        let w = myTableView.frame.width
        let h = myTableView.frame.height
        myTableView.frame = CGRectMake(x,y+64,w,h-64)
        self.navBar.title = navBarTitle
    }
    
    @IBAction func lastAisle(sender: AnyObject) {
        Numbers.num -= 1

        self.loadView()
        
        if Numbers.num == 0 {
            aisleButtonUpdates(false,x:"",y:true,z:"Next Aisle")
        } else if Numbers.num == 15 {
            aisleButtonUpdates(true,x:"Last Aisle",y:true,z:"Next Aisle")
        }
        print(Numbers.num)
        let x = myTableView.frame.origin.x
        let y = myTableView.frame.origin.y
        let w = myTableView.frame.width
        let h = myTableView.frame.height
        myTableView.frame = CGRectMake(x,y+64,w,h-64)
        self.navBar.title = navBarTitle
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navBar.title = "Produce"
        aisleButtonUpdates(false,x:"",y:true,z:"Next Aisle")
    }
    
    override func viewWillAppear(animated: Bool) {
        getCurrentAisle()
        self.navBar.title = navBarTitle
        if Numbers.num == 0 {
            aisleButtonUpdates(false,x:"",y:true,z:"Next Aisle")
        } else if Numbers.num == 16 {
            aisleButtonUpdates(true,x:"Last Aisle",y:false,z:"")
        } else {
            aisleButtonUpdates(true,x:"Last Aisle",y:true,z:"Next Aisle")
        }
    }
    
    func viewDidAppear() {
        if firstLoad {
        let h = self.myTableView.contentSize.height
        var frame: CGRect = self.myTableView.frame
        frame.size.height = h+20
        self.myTableView.frame = frame
        self.myTableView.reloadData()
        }
        self.myTableView.reloadData()
        firstLoad = false
    }
    
    func aisleButtonUpdates(w:Bool,x:String,y:Bool,z:String) {
        lastAisle.enabled = w
        lastAisle.title = x
        nextAisle.enabled = y
        nextAisle.title = z
    }

    func getCurrentAisle() -> [Food] {
        if Numbers.num == 0 {
            navBarTitle = "Produce"
            return Food.Aisles.Produce
        } else if Numbers.num == 1 {
            navBarTitle = "W1/W2"
            return Food.Aisles.W1W2
        } else if Numbers.num == 2 {
            navBarTitle = "W3/W4"
            return Food.Aisles.W3W4
        } else if Numbers.num == 3 {
            navBarTitle = "W5/W6"
            return Food.Aisles.W5W6
        } else if Numbers.num == 4 {
            navBarTitle = "W7/W8"
            return Food.Aisles.W7W8
        } else if Numbers.num == 5 {
            navBarTitle = "W9/W10"
            return Food.Aisles.W9W10
        } else if Numbers.num == 6 {
            navBarTitle = "W11/W12"
            return Food.Aisles.W11W12
        } else if Numbers.num == 7 {
            navBarTitle = "W13/W14"
            return Food.Aisles.W13W14
        } else if Numbers.num == 8 {
            navBarTitle = "W15/W16"
            return Food.Aisles.W15W16
        } else if Numbers.num == 9 {
            navBarTitle = "W17/W18"
            return Food.Aisles.W17W18
        } else if Numbers.num == 10 {
            navBarTitle = "W19/W20"
            return Food.Aisles.W19W20
        } else if Numbers.num == 11 {
            navBarTitle = "W21/W22"
            return Food.Aisles.W21W22
        } else if Numbers.num == 12 {
            navBarTitle = "W23/W24"
            return Food.Aisles.W23W24
        } else if Numbers.num == 13 {
            navBarTitle = "W25/W26"
            return Food.Aisles.W25W26
        } else if Numbers.num == 14 {
            navBarTitle = "W27/W28"
            return Food.Aisles.W27W28
        } else if Numbers.num == 15 {
            navBarTitle = "W29/W30"
            return Food.Aisles.W29W30
        } else if Numbers.num == 16 {
            navBarTitle = "South Wall"
            return Food.Aisles.SouthWall
        }
        return Food.Aisles.Produce
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let currentAisle = getCurrentAisle()
        return currentAisle.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let currentAisle = getCurrentAisle()
        let cell: CustomCell = tableView.dequeueReusableCellWithIdentifier("Cell") as! CustomCell
        cell.checkBox.tag = indexPath.row
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(red: 1.0, green: 0.9, blue: 0.9, alpha: 1)
        }
        else {
            cell.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1)
        }
        
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        
        let currentAisleElement = currentAisle[indexPath.row]
            cell.setCell(currentAisleElement.name, RightLabelString: String(currentAisleElement.price), image1Name: currentAisleElement.image1Name, image2Name: currentAisleElement.image2Name)
        return cell
    }
    
    
    @IBAction func checkBoxPressed(sender: UIButton) {
        
        let checkBoxRow = sender.tag
        print(checkBoxRow)
        
        let indexPath = NSIndexPath(forRow:checkBoxRow, inSection:0)
        let cell = myTableView.cellForRowAtIndexPath(indexPath) as! CustomCell

        if cell.checkBox.currentImage == UIImage(named:"unchecked.png") {
            cell.checkBox.setImage(UIImage(named: "checked.png"), forState: UIControlState.Normal)
            costValue += Double(cell.RightLabel.text!)!
        } else {
            cell.checkBox.setImage(UIImage(named: "unchecked.png"), forState: UIControlState.Normal)
            costValue -= Double(cell.RightLabel.text!)!
        }
        
    }
    
    
    
    
}

