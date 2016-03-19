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
    
    @IBOutlet weak var cardView: UIView!
    //    var imageTransition: ImageTransition!
    //    var cell: UIView!
    
//    //Alternative 1 using PFImageView and loading the file, will cause Crash unrecognized selector bullshit
//    @IBOutlet weak var cardImageView: PFImageView!

//    Alternative 2 using ImageView and then loading the data via NSURL, works but slow and not the right solution
    @IBOutlet weak var cardImageView: PFImageView!
    
    var passedImage: PFFile!

    
    //Failed attempts with various variables and unwrapping stuff
//    var image : UIImage = UIImage(named: "passedImage")!
    
    
    //ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardImageView.file = passedImage
        //print("PASSEDIMAGURL + \(passedImage.url)")
        
        
        //Alternative 1 using PFImage View and loading file, will cause Crash unrecozngized selector bullshit
        //        cardImageView.file = passedImage
        //        cardImageView.loadInBackground()
        //        print("CARDIMAGEVIEW +\(cardImageView.file)")

        //cell.cardImage?.file = cards[indexPath.row].image
        //cell.cardImage.loadInBackground()
        
        
        
        //Alternative 2 via NSURL
        //let cardUrlString = passedImage.url! as String
        //let cardURL = NSURL(string: cardUrlString)!
        //cardImageView.setImageWithURL(cardURL)
        
        
        //Failed attempts
        //        self.cardImageView?.image = image
        //        cardView.addSubview(cell)
        
    

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