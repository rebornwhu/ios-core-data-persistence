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
        
        var objects: [AnyObject]?
        do {
            objects = try context.executeFetchRequest(request)
        } catch let error as NSError {
            print(error)
            return
        }
        
        if let objectList = objects {
            for oneObject in objectList {
                let lineNum = oneObject.valueForKey(lineNumberKey)!.integerValue
                let lineText = oneObject.valueForKey(lineTextKey) as! String
                let textField = lineFields[lineNum]
                textField.text = lineText
            }
        }
        else {
            print("There was an error")
            return // No need to continue at this point
        }
        
        let app = UIApplication.sharedApplication()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationWillResignActive:", name: UIApplicationWillResignActiveNotification, object: app)
    }

    func applicationWillResignActive(notification:NSNotification) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        
        for var i = 0; i < lineFields.count; i++ {
            let textField = lineFields[i]
            
            let request = NSFetchRequest(entityName: lineEntityName)
            let pred = NSPredicate(format: "%K = %d", lineNumberKey, i)
            request.predicate = pred
            
            var objects: [AnyObject]?
            do {
                objects = try context.executeFetchRequest(request)
            } catch let error as NSError {
                print(error)
                return
            }
            
            if let objectList = objects {
                var theLine: NSManagedObject! = nil
                if objectList.count > 0 {
                    theLine = objectList[0] as! NSManagedObject
                }
                else {
                    theLine = NSEntityDescription.insertNewObjectForEntityForName(lineEntityName, inManagedObjectContext: context)
                }
                
                theLine.setValue(i, forKey: lineNumberKey)
                theLine.setValue(textField.text, forKey: lineTextKey)
            }
            else {
                print("There was an error #2")
            }
        }
        
        appDelegate.saveContext()
    }

}

