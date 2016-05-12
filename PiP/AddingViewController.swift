//
//  AddingViewController.swift
//  PiP
//
//  Created by Roma on 07/04/2016.
//  Copyright © 2016 esenruma. All rights reserved.
//

import UIKit
import CoreData

class AddingViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    
    @IBOutlet var scrollViewAddingScreen: UIScrollView!
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var notesTextField: UITextField!
    @IBOutlet var addImageView: UIImageView!
    
    @IBOutlet var urlTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var telephoneTextField: UITextField!
    
// -------------------------- KeyBoard Behaviour ----------------------------
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        // self.view.endEditing(true) // NOT work wi.ScrollView + ContentView under super View }
    
// ** combine with UITapGesture in ViewDidLoad **
    func dismissKeyBoard() {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
// ------------------------------------------------------
    @IBAction func cancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
// ------------------------------------------------------
    
    @IBAction func saveButton(sender: AnyObject) {
        
        if self.addImageView!.image == nil {
            
            let alert = UIAlertController(title: "Alert", message: "Need Both an IMAGE and a Title", preferredStyle: .Alert)
            // ** CANCEL BUTTON
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel){ // or .Default
                UIAlertAction in
                alert.dismissViewControllerAnimated(true, completion: nil)
            }
            // ** Now Add these Actions to the Alert
            alert.addAction(cancelAction)
            // ** Tell Alert to Present Itself
            self.presentViewController(alert, animated: true, completion: nil)
            
        } else if self.titleTextField.text == "" {
            
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
            
        } else {
        
        // *** Saving to CoreData ***
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        let newIdeas = NSEntityDescription.insertNewObjectForEntityForName("Ideas", inManagedObjectContext: context) as! Ideas
        
            newIdeas.title = titleTextField.text
            newIdeas.notes = notesTextField.text
            newIdeas.url = urlTextField.text
            newIdeas.email = emailTextField.text
            newIdeas.telephone = telephoneTextField.text
        
            newIdeas.photo = UIImageJPEGRepresentation(self.addImageView!.image!, 1.0) // Changed from PNG to... JPEG
        
        do {
            try context.save()
        } catch {
            print("Error in saving")
        }
        // --------
        dismissViewControllerAnimated(true, completion: nil)
        
        } // end If statement
    } // end button Func
// ------------------------------------------------------
    
    @IBAction func cameraButton(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            let img = UIImagePickerController()
            img.delegate = self
            img.sourceType = UIImagePickerControllerSourceType.Camera
            img.allowsEditing = false
            
            self.presentViewController(img, animated: true, completion: nil)
        } else {
            // ** Alert-Camera not Avail.
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
    
    @IBAction func getPhotosButton(sender: AnyObject) {
        
        let img = UIImagePickerController()
        img.delegate = self
        img.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        img.allowsEditing = false
        
        self.presentViewController(img, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        addImageView.image = image
        self.dismissViewControllerAnimated(true, completion: nil)
    }
// ------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        // ** Keyboard Behaviour **
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddingViewController.dismissKeyBoard))
        self.view.addGestureRecognizer(tap) // to Replace "TouchesBegan" - not work here.
        
        self.titleTextField.delegate = self
        self.notesTextField.delegate = self
        self.urlTextField.delegate = self
        self.emailTextField.delegate = self
        self.telephoneTextField.delegate = self
        
        // *** modify textField **
        self.titleTextField.layer.borderColor = UIColor.grayColor().CGColor
        self.titleTextField.layer.borderWidth = 1.0
        self.titleTextField.layer.cornerRadius = 8.0
        self.titleTextField.attributedPlaceholder = NSAttributedString(string:"title", attributes:[NSForegroundColorAttributeName: UIColor.grayColor()])
        
        self.notesTextField.layer.borderColor = UIColor.grayColor().CGColor
        self.notesTextField.layer.borderWidth = 1.0
        self.notesTextField.layer.cornerRadius = 8.0
        self.notesTextField.attributedPlaceholder = NSAttributedString(string:"notes", attributes:[NSForegroundColorAttributeName: UIColor.grayColor()])
        
        self.urlTextField.layer.borderColor = UIColor.grayColor().CGColor
        self.urlTextField.layer.borderWidth = 1.0
        self.urlTextField.layer.cornerRadius = 8.0
        self.urlTextField.attributedPlaceholder = NSAttributedString(string:"e.g. www.apple.com", attributes:[NSForegroundColorAttributeName: UIColor.grayColor()])
        
        self.emailTextField.layer.borderColor = UIColor.grayColor().CGColor
        self.emailTextField.layer.borderWidth = 1.0
        self.emailTextField.layer.cornerRadius = 8.0
        self.emailTextField.attributedPlaceholder = NSAttributedString(string:"e.g. abc@xyz.com", attributes:[NSForegroundColorAttributeName: UIColor.grayColor()])
        
        self.telephoneTextField.layer.borderColor = UIColor.grayColor().CGColor
        self.telephoneTextField.layer.borderWidth = 1.0
        self.telephoneTextField.layer.cornerRadius = 8.0
        self.telephoneTextField.attributedPlaceholder = NSAttributedString(string:"e.g. 07770123456", attributes:[NSForegroundColorAttributeName: UIColor.grayColor()])
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
