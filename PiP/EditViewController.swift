//
//  EditViewController.swift
//  PiP
//
//  Created by Roma on 09/04/2016.
//  Copyright © 2016 esenruma. All rights reserved.
//

import UIKit
import CoreData

class EditViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {

    
    @IBOutlet var editingScrollView: UIScrollView!
    
    var idea: Ideas? = nil
    
    @IBOutlet var titleTextFieldEDIT: UITextField!
    @IBOutlet var notesTextFieldEDIT: UITextField!
    @IBOutlet var urlTextFieldEDIT: UITextField!
    @IBOutlet var emailTextFieldEDIT: UITextField!
    @IBOutlet var telephoneTextFieldEDIT: UITextField!
    
    @IBOutlet var imageViewEDIT: UIImageView!
    
// -------------------------- KeyBoard Behaviour ----------------------------
// ** combine with UITapGesture in ViewDidLoad **
    func dismissKeyBoard() {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
// --------------------------------------------------------------------------
    @IBAction func cameraUpdateButton(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            
            let img = UIImagePickerController()
            img.delegate = self
            img.sourceType = UIImagePickerControllerSourceType.Camera
            img.allowsEditing = false
            self.presentViewController(img, animated: true, completion: nil)
            
        } else {
            // ** Alert-Camera not Avail **
            let alertCamera = UIAlertController(title: "Alert", message: "Unable to Access Camera, Check Settings", preferredStyle: .Alert)
            // ** CANCEL BUTTON
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel){ // or .Default
                UIAlertAction in
                alertCamera.dismissViewControllerAnimated(true, completion: nil)
            }
            // ** Now Add these Actions to the Alert
            alertCamera.addAction(cancelAction)
            // ** tell Alert to PopUp
            self.presentViewController(alertCamera, animated: true, completion: nil)
        }
    }
    
    @IBAction func photoUpdateButton(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
        
            let img = UIImagePickerController()
            img.delegate = self
            img.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            img.allowsEditing = false
        
        self.presentViewController(img, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        imageViewEDIT.image = image
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
// --------------------------------------------------------------------------
    @IBAction func cancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
// --------------------------------------------------------------------------
    
    @IBAction func saveButton(sender: AnyObject) {
        
        let titleToShow = namedLabel
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        let request = NSFetchRequest(entityName: "Ideas")
        
        request.predicate = NSPredicate(format: "title = %@", titleToShow)
        
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.executeFetchRequest(request) as! [Ideas]
            
            if results.count > 0 {
                
                for result in results { // removed "as! [Ideas]" after "results" due to forced Cast of [Ideas] to same type has not effect
                    
                    if self.titleTextFieldEDIT.text == "" {
                        
                        noTitleProvidedAlert()
                        
                    } else {
                    
                    result.title = self.titleTextFieldEDIT.text
                    result.notes = self.notesTextFieldEDIT.text
                    result.url = self.urlTextFieldEDIT.text
                    result.email = self.emailTextFieldEDIT.text
                    result.telephone = self.telephoneTextFieldEDIT.text
                    
                    result.photo = UIImageJPEGRepresentation(self.imageViewEDIT!.image!, 1.0) // Changed from PNG to... JPEG
                    
                    // to save changes...
                        do {
                            try context.save()
                            print("CHANGES SAVED!!!")
                            
                            dismissViewControllerAnimated(true, completion: nil)
                        
                            } catch {
                                print("Error Saving changes")
                            }
                        }
                    }
                }
            } catch {
            
        } // End 1st DO...
    } // End Func
    
// --------------------------------------------------------------------------
    func noTitleProvidedAlert() {
        
        let alert = UIAlertController(title: "Alert", message: "Need Both an TITLE and a Image", preferredStyle: .Alert)
        
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
    
// --------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ------Keyboard Behaviour------
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddingViewController.dismissKeyBoard))
        self.view.addGestureRecognizer(tap) // to Replace "TouchesBegan" - not work here.
        
        self.titleTextFieldEDIT.delegate = self
        self.notesTextFieldEDIT.delegate = self
        self.urlTextFieldEDIT.delegate = self
        self.emailTextFieldEDIT.delegate = self
        self.telephoneTextFieldEDIT.delegate = self
        // --------------------------
        
        // *** modify textField **
        self.titleTextFieldEDIT.layer.borderColor = UIColor.grayColor().CGColor
        self.titleTextFieldEDIT.layer.borderWidth = 1.0
        self.titleTextFieldEDIT.layer.cornerRadius = 8.0
        self.titleTextFieldEDIT.attributedPlaceholder = NSAttributedString(string:"title", attributes:[NSForegroundColorAttributeName: UIColor.grayColor()])
        
        self.notesTextFieldEDIT.layer.borderColor = UIColor.grayColor().CGColor
        self.notesTextFieldEDIT.layer.borderWidth = 1.0
        self.notesTextFieldEDIT.layer.cornerRadius = 8.0
        self.notesTextFieldEDIT.attributedPlaceholder = NSAttributedString(string:"notes", attributes:[NSForegroundColorAttributeName: UIColor.grayColor()])
        
        self.urlTextFieldEDIT.layer.borderColor = UIColor.grayColor().CGColor
        self.urlTextFieldEDIT.layer.borderWidth = 1.0
        self.urlTextFieldEDIT.layer.cornerRadius = 8.0
        self.urlTextFieldEDIT.attributedPlaceholder = NSAttributedString(string:"url website", attributes:[NSForegroundColorAttributeName: UIColor.grayColor()])
        
        self.emailTextFieldEDIT.layer.borderColor = UIColor.grayColor().CGColor
        self.emailTextFieldEDIT.layer.borderWidth = 1.0
        self.emailTextFieldEDIT.layer.cornerRadius = 8.0
        self.emailTextFieldEDIT.attributedPlaceholder = NSAttributedString(string:"email", attributes:[NSForegroundColorAttributeName: UIColor.grayColor()])
        
        self.telephoneTextFieldEDIT.layer.borderColor = UIColor.grayColor().CGColor
        self.telephoneTextFieldEDIT.layer.borderWidth = 1.0
        self.telephoneTextFieldEDIT.layer.cornerRadius = 8.0
        self.telephoneTextFieldEDIT.attributedPlaceholder = NSAttributedString(string:"telephone", attributes:[NSForegroundColorAttributeName: UIColor.grayColor()])
        
        // --------------------------
        let titleToShow = namedLabel
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        let request = NSFetchRequest(entityName: "Ideas")
        request.predicate = NSPredicate(format: "title = %@", titleToShow)
        
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.executeFetchRequest(request) as! [Ideas]
            
            if results.count > 0 {
                
                for result in results { // removed "as! [Ideas]" after "results" due to forced Cast of [Ideas] to same type has not effect
                    
                    self.titleTextFieldEDIT.text = result.title
                    self.notesTextFieldEDIT.text = result.notes
                    self.urlTextFieldEDIT.text = result.url
                    self.emailTextFieldEDIT.text = result.email
                    self.telephoneTextFieldEDIT.text = result.telephone
                    
                    let imageData = result.photo
                    self.imageViewEDIT.image = UIImage(data: imageData!)
                }
            }
            
        } catch {
        } // End 1st DO...
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
