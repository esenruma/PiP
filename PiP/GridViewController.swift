//
//  GridViewController.swift
//  PiP
//
//  Created by Roma on 08/04/2016.
//  Copyright © 2016 esenruma. All rights reserved.
//

import UIKit
import CoreData

class GridViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    
    @IBOutlet var secondCollectionView: UICollectionView!
    
    var thoughts: [Ideas] = []
    
    var selectedIdea: Ideas? = nil
    
    @IBOutlet var totalsLabelGrid: UILabel!
    
    
// ----------------------------------------------------------
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return thoughts.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = self.secondCollectionView.dequeueReusableCellWithReuseIdentifier("Cell2", forIndexPath: indexPath) as! GridCustomCell
        
        let idea  = self.thoughts[indexPath.row]
        
        cell.gridImageView?.image = UIImage(data: idea.photo!)  // converts NSDATA back to UIimage
        
        return cell
    }
// ----------------------------------------------------------
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        self.selectedIdea = self.thoughts[indexPath.row]
        performSegueWithIdentifier("gridToDetailsView", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "gridToDetailsView" {
            let detailsVC = segue.destinationViewController as! DetailsViewController
            detailsVC.idea = selectedIdea
        }
    }
    
// ----------------------------------------------------------
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
        
        self.secondCollectionView.reloadData()
        
        self.totalsLabelGrid.text = String(self.thoughts.count)
     }
    
// ----------------------------------------------------------
    @IBAction func backButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
// ----------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.secondCollectionView.dataSource = self
        self.secondCollectionView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
