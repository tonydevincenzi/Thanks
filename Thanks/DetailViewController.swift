//
//  DetailViewController.swift
//  Thanks
//
//  Created by Anthony Devincenzi on 3/16/16.
//  Copyright © 2016 Friendly Apps. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import AFNetworking

class DetailViewController: UIViewController {
    
    
    //Outlets
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var cardImageView: PFImageView!
    
    
    //Variables
    var passedImage: PFFile!

    
    //ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Load passed image into cardImageView
        cardImageView.file = passedImage
    }
    

    
    
    @IBAction func didTapDone(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapShare(sender: AnyObject) {
        
        //TODO: Move into Share.swift
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(cardView.frame.width, cardView.frame.height), false, 0);
        self.cardView.drawViewHierarchyInRect(CGRectMake(0,0,cardView.bounds.size.width,cardView.bounds.size.height), afterScreenUpdates: true)
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext();
        let activityItem: [AnyObject] = [image as AnyObject]
        let avc = UIActivityViewController(activityItems: activityItem as [AnyObject], applicationActivities: nil)
        self.presentViewController(avc, animated: true, completion: nil)
    }
}