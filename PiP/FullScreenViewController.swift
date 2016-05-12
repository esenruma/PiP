//
//  FullScreenViewController.swift
//  PiP
//
//  Created by Roma on 14/04/2016.
//  Copyright © 2016 esenruma. All rights reserved.
//

import UIKit

class FullScreenViewController: UIViewController, UIScrollViewDelegate {

    
    @IBOutlet var fullScreenImage: UIImageView!
    
    var varForFullImage = UIImage(named: "LaunchScreen_PiP_Icon3")
    
    @IBOutlet var scrollViewFullScreen: UIScrollView!
    
// ----------------Allow zooming--------------------------
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.fullScreenImage
    }
    
// ----------------Scale to Fill--------------------------
    @IBAction func scaleToFill(sender: AnyObject) {
        self.fullScreenImage.contentMode = .ScaleToFill
    }
    
    @IBAction func aspectFit(sender: AnyObject) {
        self.fullScreenImage.contentMode = .ScaleAspectFit
    }
    
// ----------------------------------------------------------------------
    @IBAction func returnToDetailsView(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
// ----------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fullScreenImage.image = self.varForFullImage
        
        // ** Zooming via scrollView **
        self.scrollViewFullScreen.delegate = self
        self.scrollViewFullScreen.minimumZoomScale = 1.0
        self.scrollViewFullScreen.maximumZoomScale = 10.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
