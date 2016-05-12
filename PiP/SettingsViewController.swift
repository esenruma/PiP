//
//  SettingsViewController.swift
//  PiP
//
//  Created by Roma on 14/04/2016.
//  Copyright © 2016 esenruma. All rights reserved.
//
// -----------------------Color Scheme----------------------
// Black1: 0, 0, 0 // Black2: 26, 26, 26 // Black3: 32, 32, 32
// Red: 248, 0, 0 // Yellow: 252, 209, 22
// -----------------------------------------------------------

import UIKit
import CoreData

class SettingsViewController: UIViewController {
    
    
    @IBOutlet var resetPendingLabel: UILabel!
    
    @IBOutlet var scrollViewSettings: UIScrollView!
    
// -----------------------------------------------------------
    @IBAction func backToHomeButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
// ----------------------------------------------------------------------
    @IBAction func resetButton(sender: AnyObject) {
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        let request = NSFetchRequest(entityName: "Ideas")
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.executeFetchRequest(request)
            
            if results.count > 0 {
                
                let alert = UIAlertController(title: "Resetting Photo Ideas Pad", message: "Are you sure?", preferredStyle: .Alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
                    UIAlertAction in
                    alert.dismissViewControllerAnimated(true, completion: nil)
                }
                
                let deleteAction = UIAlertAction(title: "DELETE", style: UIAlertActionStyle.Default) {
                    UIAlertAction in
                    
                    self.resetDeleteAll() // call this func
                }
                
                alert.addAction(cancelAction)
                alert.addAction(deleteAction)
                
                self.presentViewController(alert, animated: true, completion: nil)
                
                }
            } catch {
        }
    }
// ------------Deleting from CoreData---------------------------------------------
    func resetDeleteAll() {

        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        let request = NSFetchRequest(entityName: "Ideas")
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.executeFetchRequest(request)
            
            if results.count > 0 {
                
                for result: AnyObject in results {
                    
                    context.deleteObject(result as! NSManagedObject)
                    
                    print("NSManagedObject has been Deleted")
                    
                    self.resetPendingLabel.text! = "ALL DELETED!!!"
                }
                try context.save() }
        } catch {
        }
    }
// --------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
     }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
