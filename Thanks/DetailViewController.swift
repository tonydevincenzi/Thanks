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
    var dismissType = "standard"
    
    //ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardImageView.layer.cornerRadius = 6
        
        //Load passed image into cardImageView
        cardImageView.file = passedImage
        cardImageView.loadInBackground()
        
        //Set scrollView content size
        scrollView.contentSize = CGSize(width: 375, height: 667)
        
        //Register for scroll events
        scrollView.delegate = self
        
    }
    
    @IBAction func didTapDone(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("refresh", object: dismissType)
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
            NSNotificationCenter.defaultCenter().postNotificationName("refresh", object: dismissType)
        } else if scrollView.contentOffset.y <= -70 {
            dismissViewControllerAnimated(true, completion: nil)
            NSNotificationCenter.defaultCenter().postNotificationName("refresh", object: dismissType)
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
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .Default, handler: { action in
            switch action.style{
            case .Default:
                let parseService:ParseService = ParseService()
                parseService.deleteOneCard(self.passedObjectId)
                
                UIView.animateWithDuration(0.3, delay: 0, options: [], animations: { () -> Void in
                    
                    self.cardView.transform = CGAffineTransformScale(self.cardView.transform, 1.05, 1.05)
                    
                    }, completion: { (Bool) -> Void in
                        UIView.animateWithDuration(0.2, delay: 0, options: [], animations: { () -> Void in
                            self.cardView.transform = CGAffineTransformScale(self.cardView.transform, 0.5, 0.5)
                            self.cardView.alpha = 0
                            }, completion: { (Bool) -> Void in
                                
                                //TODO: If we want a smooth animation, probably better to remove the card from the collectionView as well, and not call reloadData()
                                if let i = cards.indexOf({$0.objectId == self.passedObjectId}) {
                                    cards.removeAtIndex(i)
                                }
                                
                                self.dismissType = "delete"
                                NSNotificationCenter.defaultCenter().postNotificationName("refresh", object: self.dismissType)
                                self.dismissViewControllerAnimated(true, completion: nil)
                        })
                })

            case .Cancel:
                print("cancel")
            case .Destructive:
                print("destructive")
            }
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    //Share Button
    @IBAction func didTapShare(sender: AnyObject) {
        let share:ShareCard = ShareCard()
        share.shareCard(cardView, targetView: self)
    }
    
}