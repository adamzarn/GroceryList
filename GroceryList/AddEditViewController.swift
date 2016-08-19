//
//  AddEditViewController.swift
//  GroceryList
//
//  Created by Adam Zarn on 8/18/16.
//  Copyright © 2016 Adam Zarn. All rights reserved.
//

import UIKit
import CoreData

class AddEditViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var baseUnitTextField: UITextField!
    @IBOutlet weak var priceTextField: CurrencyField!
    @IBOutlet weak var aisleTextField: UITextField!
    @IBOutlet weak var addPhotoView: UIImageView!
    
    let invalidEntryAlert: UIAlertController = UIAlertController(title: "Your entry is invalid.", message: nil, preferredStyle: UIAlertControllerStyle.Alert)

    func messageGenerator() -> String {
        var errorArray: [String] = []
        var errorString: String = ""
        if nameTextField.text == "" || nameTextField.text == "e.g. Apples" {
            errorArray.append("name")
        }
        if baseUnitTextField.text == "" || baseUnitTextField.text == "e.g. 1 lb" {
            errorArray.append("base unit")
        }
        if priceTextField.text == "" || priceTextField.text == "$0.00" {
            errorArray.append("price")
        }
        if aisleTextField.text == "" || aisleTextField.text == "Select an aisle..." {
            errorArray.append("aisle")
        }
        
        if errorArray.count == 0 {
            return "Valid Entry"
        } else if errorArray.count == 1 {
            return "Your entry for the \(errorArray[0]) field is invalid."
        } else if errorArray.count == 2 {
            return "Your entries for the \(errorArray[0]) and \(errorArray[1]) fields are invalid"
        } else {
            for i in 0...errorArray.count - 1 {
                if i < errorArray.count - 1 {
                    errorString = errorString + errorArray[i] + ", "
                } else {
                    errorString = errorString + "and " + errorArray[i]
                }
            }
            return "Your entries for the \(errorString) fields are invalid."
        }
    }
    
    var originalText = ""
    var currentString = ""
    var nameText: String?
    var baseUnitText: String?
    var priceText: Double?
    var aisleText: String?
    var imageName: String?
    var editingFoodItem = false
    var editingIndexPathRow = 0
    
    let sections = ["Produce","W1/W2","W3/W4","W5/W6","W7/W8","W9/W10","W11/W12","W13/W14","W15/W16","W17/W18","W19/W20","W21/W22","W23/W24","W25/W26","W27/W28","W29/W30","South Wall"]
    
    override func viewDidLoad() {
        
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(GroceryViewController.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
        
        self.aisleTextField.inputView = picker
        
        nameTextField.delegate = self
        baseUnitTextField.delegate = self
        priceTextField.delegate = self
        aisleTextField.delegate = self
        
        setUpTextStrings()

        priceTextField.addTarget(self, action: #selector(AddEditViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        
        self.addPhotoView.layer.borderWidth = 1
        self.addPhotoView.layer.borderColor = UIColor.blackColor().CGColor
        self.addPhotoView.layer.cornerRadius = self.addPhotoView.frame.height/2
        self.addPhotoView.clipsToBounds = true
        
        invalidEntryAlert.addAction(UIAlertAction(title:"OK",style: UIAlertActionStyle.Default, handler: nil))
        
        addPhotoView.backgroundColor = UIColor.whiteColor()

    }
    
    func didTapView() {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        print(nameText)
        setUpTextStrings()
        
        let backgroundGradient = CAGradientLayer()
        let colorTop = UIColor(red: 1.0, green: 0.9, blue: 0.9, alpha: 1.0).CGColor
        let colorBottom = UIColor(red: 0.8196, green: 0.0, blue: 0.0, alpha: 1.0).CGColor
        backgroundGradient.colors = [colorTop, colorBottom]
        backgroundGradient.locations = [0.0, 1.0]
        backgroundGradient.frame = view.frame
        view.layer.insertSublayer(backgroundGradient, atIndex: 0)
        
        if editingFoodItem {
            addPhotoView.image = UIImage(named: imageName!)
        }
        
    }
    
    func resetTextStrings() {
        nameText = ""
        baseUnitText = ""
        priceText = 0.0
        aisleText = ""
    }
    
    func setUpTextStrings() {
        if nameText == nil {
            nameTextField.text = "e.g. Apples"
            nameTextField.textColor = UIColor.grayColor()
        } else {
            nameTextField.text = nameText
        }
        
        if baseUnitText == nil {
            baseUnitTextField.text = "e.g. 1 lb"
            baseUnitTextField.textColor = UIColor.grayColor()
        } else {
            baseUnitTextField.text = baseUnitText
        }
        
        if priceText == nil {
            priceTextField.text = "$0.00"
            priceTextField.textColor = UIColor.grayColor()
        } else {
            let formatter = NSNumberFormatter()
            formatter.numberStyle = .CurrencyStyle
            priceTextField.text = formatter.stringFromNumber(priceText!)
        }
        
        if aisleText == nil {
            aisleTextField.text = "Select an aisle..."
            aisleTextField.textColor = UIColor.grayColor()
        } else {
            aisleTextField.text = aisleText
        }
    }
    
    
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        editingFoodItem = false
        resetTextStrings()
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        originalText = textField.text!
        textField.becomeFirstResponder()
        if textField.text == "e.g. Apples" || textField.text == "e.g. 1 lb" || textField.text == "Select an aisle..." {
            textField.text = ""
        }
        if textField.text != "$0.00" {
            textField.textColor = UIColor.blackColor()
        } else {
            textField.textColor = UIColor.grayColor()
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text == "" {
            textField.text = originalText
        }
        
        if textField.text == "e.g. Apples" || textField.text == "e.g. 1 lb" || textField.text == "$0.00" || textField.text == "Select an aisle..." {
            textField.textColor = UIColor.grayColor()
        } else {
            textField.textColor = UIColor.blackColor()
        }
        
    }
    
    func textFieldDidChange(textField: UITextField) {
        if textField.text! == "$0.00" {
            textField.textColor = UIColor.grayColor()
        } else {
            textField.textColor = UIColor.blackColor()
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.sections.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.sections[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.aisleTextField.text = self.sections[row];
        self.aisleTextField.endEditing(true)
    }

    @IBAction func submitButtonPressed(sender: AnyObject) {
        
        if messageGenerator() != "Valid Entry" {
            invalidEntryAlert.message = messageGenerator()
            self.presentViewController(invalidEntryAlert,animated: true, completion: nil)
        } else {
        
            resetTextStrings()
        
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let context = appDelegate.managedObjectContext
        
            var price = priceTextField.text!.stringByReplacingOccurrencesOfString(",", withString: "")
            price = price.stringByReplacingOccurrencesOfString(".",withString: "")
            price = price.stringByReplacingOccurrencesOfString("$",withString: "")
        
            if editingFoodItem {
                let groceryView = self.storyboard!.instantiateViewControllerWithIdentifier("GroceryViewController") as! GroceryViewController
            
                groceryView.getData()
            
                let item = groceryView.foodItems[editingIndexPathRow]
                item.setValue(nameTextField.text!,forKey: "name")
                item.setValue(baseUnitTextField.text!,forKey: "baseUnit")
                item.setValue(Double(price)!/100.0,forKey: "price")
                item.setValue(sections.indexOf(aisleTextField.text!),forKey: "aisleNumber")
            
                appDelegate.saveContext()
            
            } else {
        
                let foodItem = NSEntityDescription.insertNewObjectForEntityForName("Food", inManagedObjectContext: context) as! Food
        
                foodItem.name = nameTextField.text
                foodItem.price = Double(price)!/100.0
                foodItem.imageName = "\(nameTextField.text!).jpeg"
                foodItem.baseUnit = baseUnitTextField.text!
                foodItem.isSelected = false
                foodItem.numberSelected = 1
                foodItem.aisleNumber = sections.indexOf(aisleTextField.text!)
            
            }
        
            editingFoodItem = false
            self.dismissViewControllerAnimated(true, completion: nil)
        
        }
    }
    
    
}








