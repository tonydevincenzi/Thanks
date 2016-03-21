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

class DetailViewController: UIViewController, UIScrollViewDelegate {
    
    
    //Outlets
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var cardImageView: PFImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var trashButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    
    //Variables
    var passedImage: PFFile!
    var passedObjectId: String!
    
    //ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(passedObjectId)
        
        //Load passed image into cardImageView
        cardImageView.file = passedImage
        
        //Set scrollView content size
        scrollView.contentSize = CGSize(width: 375, height: 667)
        
        //Register for scroll events
        scrollView.delegate = self
        
    }
    
    @IBAction func didTapDone(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Scrollview begins scrolling
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
        UIView.animateWithDuration(0.1) { () -> Void in
            self.backButton.alpha = 0
            self.trashButton.alpha = 0
            self.shareButton.alpha = 0
        }
    }
    
    
    //Scrollview is scrolling
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        //Convert background alpha according to scroll offset
        let convertedAlphaPos = convertValue(scrollView.contentOffset.y, r1Min: 0, r1Max: 250, r2Min: 1, r2Max: 0)
        let convertedAlphaNeg = convertValue(scrollView.contentOffset.y, r1Min: 0, r1Max: -250, r2Min: 1, r2Max: 0)
        
        //Change background alpha based on scrolling
        if scrollView.contentOffset.y > 0 {
            scrollView.backgroundColor = UIColor(white: 0, alpha: convertedAlphaPos)
        } else if scrollView.contentOffset.y < 0 {
            scrollView.backgroundColor = UIColor(white: 0, alpha: convertedAlphaNeg)
        }
        
    }
    
    
    
    //Scrollview ended dragging
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y >= 70 {
            dismissViewControllerAnimated(true, completion: nil)
        } else if scrollView.contentOffset.y <= -70 {
            dismissViewControllerAnimated(true, completion: nil)
        } else if scrollView.contentOffset.y > 0 && scrollView.contentOffset.y < 70 {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.backButton.alpha = 1
                self.trashButton.alpha = 1
                self.shareButton.alpha = 1
            })
        } else if scrollView.contentOffset.y < 0 && scrollView.contentOffset.y > -70 {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.backButton.alpha = 1
                self.trashButton.alpha = 1
                self.shareButton.alpha = 1
            })
        }
    }
    
    
    @IBAction func didTapDelete(sender: AnyObject) {
        
        //TODO: Show alert sheet
        let parseService:ParseService = ParseService()
        parseService.deleteOneCard(passedObjectId)
        dismissViewControllerAnimated(true, completion: nil)

    }
    
    
    //Share Button
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