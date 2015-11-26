//
//  ViewController.swift
//  ios-core-data-persistence
//
//  Created by Xiao Lu on 11/25/15.
//  Copyright © 2015 Xiao Lu. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet var lineFields:[UITextField]!
    private let lineEntityName = "Line"
    private let lineNumberKey = "lineNumber"
    private let lineTextKey = "lineText"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        let request = NSFetchRequest(entityName:lineEntityName)
        
        do {
            let objects = try context.executeFetchRequest(request)
            
            if let objectList = objects {
                for oneObject in objectList {
                    let lineNum = oneObject.valueForKey(lineNumberKey) as! String
                    let textField = lineFields[lineNum]
                    textField.text = lineText
                }
            }
            
        } catch let error as NSError {
            print(error)
            return
        }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

