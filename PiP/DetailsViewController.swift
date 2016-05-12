//
//  DetailsViewController.swift
//  PiP
//
//  Created by Roma on 07/04/2016.
//  Copyright © 2016 esenruma. All rights reserved.
//

import UIKit
import CoreData

var namedLabel = ""

class DetailsViewController: UIViewController {
    
    @IBOutlet var detailsImage: UIImageView!
    
    @IBOutlet var detailsTitleLabel: UILabel!
    @IBOutlet var detailsNotesLabel: UILabel!
    @IBOutlet var detailsUrlLabel: UILabel!
    @IBOutlet var detailsEmailLabel: UILabel!
    @IBOutlet var detailsTelephoneLabel: UILabel!
    
    var idea: Ideas? = nil

    
// ----------------------------------------------------------------------
    func imageTapped() {
        performSegueWithIdentifier("toFullScreen", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "toFullScreen" {
            let fullScreenVC = segue.destinationViewController as! FullScreenViewController
            fullScreenVC.varForFullImage = self.detailsImage.image!
        } 
     }
    
// ----------------------------------------------------------------------
    @IBAction func urlButton(sender: AnyObject) {
        
//        let checkUrlIsCorrect = NSString(string: self.detailsUrlLabel.text!)
//        checkUrlIsCorrect.containsString("www.")
        
        if self.detailsUrlLabel.text! != ""  {
            let websiteTo = "https://" + "\(self.detailsUrlLabel.text!)"
            print(websiteTo)
            let url1 = NSURL(string: "\(websiteTo)")
            print(url1!)
            UIApplication.sharedApplication().openURL(url1!)
            
        } else {
            
            let alert = UIAlertController(title: "Alert", message: "Need a valid (www.) website", preferredStyle: .Alert)
            // ** CANCEL BUTTON
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel){ // or .Default
                UIAlertAction in
                alert.dismissViewControllerAnimated(true, completion: nil)
            }
            // ** Now Add these Actions to the Alert
            alert.addAction(cancelAction)
            // ** tell Alert to Present Itself
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
// ----------------------------------------------------------------------
    @IBAction func emailButton(sender: AnyObject) {
        
        if self.detailsEmailLabel.text! != ""  {
            
            let emailTo = self.detailsEmailLabel.text!
            print(emailTo)
            let url2 = NSURL(string: "mailto:\(emailTo)")
            print(url2!)
            UIApplication.sharedApplication().openURL(url2!)
            
        } else {
            
            let alert = UIAlertController(title: "Alert", message: "Need a valid email", preferredStyle: .Alert)
            // ** CANCEL BUTTON
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel){ // or .Default
                UIAlertAction in
                alert.dismissViewControllerAnimated(true, completion: nil)
            }
            // ** Now Add these Actions to the Alert
            alert.addAction(cancelAction)
            // ** tell Alert to PopUp
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
// ----------------------------------------------------------------------
    @IBAction func telButton(sender: AnyObject) {
        
        if self.detailsTelephoneLabel.text! != ""  {
            
            let telTo = self.detailsTelephoneLabel.text!
            print(telTo)
            let url3 = NSURL(string: "tel://\(telTo)")
            print(url3!)
            UIApplication.sharedApplication().openURL(url3!)
            
        } else {
            
            let alert = UIAlertController(title: "Alert", message: "Need a valid phone number", preferredStyle: .Alert)
            // ** CANCEL BUTTON
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel){ // or .Default
                UIAlertAction in
                alert.dismissViewControllerAnimated(true, completion: nil)
            }
            // ** Now Add these Actions to the Alert
            alert.addAction(cancelAction)
            // ** tell Alert to PopUp
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
// ----------------------------------------------------------------------
    @IBAction func editButton(sender: AnyObject) {
        
        namedLabel = self.detailsTitleLabel.text!
        performSegueWithIdentifier("viewToEdit", sender: self)
    }
    
// ----------------------------------------------------------------------
    @IBAction func scaleToFillButton(sender: AnyObject) {
        self.detailsImage.contentMode = .ScaleToFill
    }
    
    @IBAction func aspectFitButton(sender: AnyObject) {
        self.detailsImage.contentMode = .ScaleAspectFit
    }
    
// ---------------------------------------------------------------------
    @IBAction func trashButton(sender: AnyObject) {
        
        let titleToDelete = self.detailsTitleLabel.text
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        let request = NSFetchRequest(entityName: "Ideas")
        request.predicate = NSPredicate(format: "title = %@", titleToDelete!)
        
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.executeFetchRequest(request)
            
            if results.count > 0 {
                
                for result in results as! [NSManagedObject] {
                    // delete an entry/ Attribute
                    context.deleteObject(result)
                    
                    // save context
                    do {
                        try context.save()
                    } catch {
                        print("error saving deletion")
                    } // End Save DO...
                }
            }
        } catch {
        } // End 1st DO...
        
        deletionPopUp()
    } //  END Func
    
// -------------------------------------
    func deletionPopUp() {
        let alert = UIAlertController(title: "File Deleted", message: "Returning to Home View", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel) {
            UIAlertAction in
            
            alert.dismissViewControllerAnimated(true, completion: nil)
            self.dismissViewControllerAnimated(true, completion: nil) // back to Home View
        }
        
        alert.addAction(cancelAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
// -------------------------------------
    @IBAction func backButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
// -------------------------------------
    // update with correct info from CoreD after Edits
    override func viewWillAppear(animated: Bool) {
        
        self.detailsImage.image = UIImage(data: self.idea!.photo!)
        self.detailsTitleLabel.text = self.idea!.title!
        self.detailsNotesLabel.text = self.idea!.notes!
        self.detailsUrlLabel.text = self.idea!.url!
        self.detailsEmailLabel.text = self.idea!.email!
        self.detailsTelephoneLabel.text = self.idea!.telephone!
    }
    
// -------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ** Link passed data to objects in This VC **
        self.detailsImage.image = UIImage(data: self.idea!.photo!)
        self.detailsTitleLabel.text = self.idea!.title!
        self.detailsNotesLabel.text = self.idea!.notes!
        self.detailsUrlLabel.text = self.idea!.url!
        self.detailsEmailLabel.text = self.idea!.email!
        self.detailsTelephoneLabel.text = self.idea!.telephone!
        
        // ** Tap Image **
        let imageTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(DetailsViewController.imageTapped))
        self.detailsImage.addGestureRecognizer(imageTapRecognizer)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}














