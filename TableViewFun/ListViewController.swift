//
//  ListViewController.swift
//  TableViewFun
//
//  Created by Adam Zarn on 4/7/16.
//  Copyright © 2016 Adam Zarn. All rights reserved.
//

import Foundation
import UIKit

class ListViewController: UIViewController {
    
    @IBAction func backButton(sender: AnyObject) {
        var selectionView: ViewController
        selectionView = self.storyboard?.instantiateViewControllerWithIdentifier("selectionView") as! ViewController
        presentViewController(selectionView, animated: false, completion: nil)
    }
}