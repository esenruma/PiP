//
//  ClassicViewController.swift
//  PiP
//
//  Created by Roma on 08/04/2016.
//  Copyright © 2016 esenruma. All rights reserved.
//

import UIKit
import CoreData

class ClassicViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var thoughts: [Ideas] = []
    var selectedIdea: Ideas? = nil
    
    @IBOutlet var tableViewClassic: UITableView!
    
    @IBOutlet var totalsLabelClassic: UILabel!
    
// ----------------------------------------------------------------------
    @IBAction func backButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
// --------------------------Swipe Delete-------------------------------------
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            context.deleteObject(self.thoughts[indexPath.row])
            
            self.thoughts.removeAtIndex(indexPath.row)
            
            do {
                try context.save()
                print("saved Swipe Delete")
                
            } catch {
                print("Error saving swipe delete!")
            }
        }
        self.tableViewClassic.reloadData()
        
        self.totalsLabelClassic.text = String(self.thoughts.count)
    }
    
// ----------------------------------------------------------------------
    override func viewWillAppear(animated: Bool) {
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        let request = NSFetchRequest(entityName: "Ideas")
        
        var results: [AnyObject]?
        
        do {
            results = try context.executeFetchRequest(request)
            
        } catch {
            print("Error in Fetching")
            results = nil   // from Jen
        }
        
        // ** If there= results - Put them in Array above called 'thoughts'
        if results != nil {
            self.thoughts = results! as! [Ideas]
        }
        
        self.tableViewClassic.reloadData()
        
        self.totalsLabelClassic.text = String(self.thoughts.count)
    }
    
// --------------------------------------------------------------
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return thoughts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableViewClassic.dequeueReusableCellWithIdentifier("Cell3", forIndexPath: indexPath) as! ClassicCustomCell
        
        let idea  = self.thoughts[indexPath.row]
        cell.tableImage?.image = UIImage(data: idea.photo!)
        // convert NSDATA back to UIimage
        
        cell.tableTitleLabel.text = idea.title
        
        return cell
    }
// --------------------------------------------------------------
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.selectedIdea = self.thoughts[indexPath.row]
        performSegueWithIdentifier("classicToDetails", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "classicToDetails" {
            let detailsVC = segue.destinationViewController as! DetailsViewController
            detailsVC.idea = selectedIdea
        }
    }
    
    
// --------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.tableViewClassic.dataSource = self
        self.tableViewClassic.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
