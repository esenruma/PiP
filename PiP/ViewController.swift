//
//  ViewController.swift
//  PiP
//
//  Created by Roma on 07/04/2016.
//  Copyright © 2016 esenruma. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet var collectionView1: UICollectionView!
    @IBOutlet var totalLabel1: UILabel!
    
    var thoughts: [Ideas] = []
    
    var selectedIdea: Ideas? = nil  // passing info to Details VC
    
// ----------Access Diff.Views-------------------------------------------
    @IBAction func classicViewButton(sender: AnyObject) {
        
        performSegueWithIdentifier("toClassicView", sender: self)
    }

    @IBAction func gridViewButton(sender: AnyObject) { // CollageView
        
        performSegueWithIdentifier("toGridView", sender: self)
    }
    
    @IBAction func toSettingsButton(sender: AnyObject) {
        
        performSegueWithIdentifier("homeToSettings", sender: self)
    }
    
// ----------------------------------------------------------------------
    override func viewWillAppear(animated: Bool) {
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        let request = NSFetchRequest(entityName: "Ideas")
        request.returnsObjectsAsFaults = false
        
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
        
        self.collectionView1.reloadData()
        
        // ** Stats on home page **
        self.totalLabel1.text = String(self.thoughts.count)
    }
    
// -----------------Collection View----------------------------------------
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return thoughts.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = self.collectionView1.dequeueReusableCellWithReuseIdentifier("Cell1", forIndexPath: indexPath) as! HomeCustomCell
        
        let idea  = self.thoughts[indexPath.row]
        cell.homeTitleLabel.text = idea.title
        
        cell.homeImage?.image = UIImage(data: idea.photo!)
        // convert NSDATA back to UIimage
        
        return cell
    }
// -------------------Select Cell------------------------------------------
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        self.selectedIdea = self.thoughts[indexPath.row]
        performSegueWithIdentifier("toDetailsView", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "toDetailsView" {
            let detailsVC = segue.destinationViewController as! DetailsViewController
            detailsVC.idea = selectedIdea
        }
    }
// ----------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.collectionView1.dataSource = self
        self.collectionView1.delegate = self
        
        // ** Nav Bar Color **
        self.navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.redColor()]
        
        // ** GFx img in NavBarTitle **
        let logo = UIImage(named: "Home_Top_Icon")
        let imageViewNavBar = UIImageView(image: logo)
        imageViewNavBar.frame.size.width = 80
        imageViewNavBar.frame.size.height = 40
        imageViewNavBar.contentMode = UIViewContentMode.ScaleAspectFit
        self.navigationItem.titleView = imageViewNavBar
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

