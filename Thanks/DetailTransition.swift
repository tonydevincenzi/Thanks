//
//  DetailTransition.swift
//  Thanks
//
//  Created by Jan Senderek on 3/18/16.
//  Copyright © 2016 Friendly Apps. All rights reserved.
//

import UIKit
import ParseUI

class DetailTransition: BaseTransition {
    
    override func presentTransition(containerView: UIView, fromViewController: UIViewController, toViewController: UIViewController) {
        
        //Cast the VCs
        let homeViewController = fromViewController as! HomeViewController
        let detailViewController = toViewController as! DetailViewController

        //Clone the image view
        let movingImageView = PFImageView()
        
        //Set destination for moving view
        let destinationViewFrame = detailViewController.cardView.frame

        //Set the frame for the moving view from the tapped cell
        movingImageView.frame = homeViewController.tappedCellFrame
        
        //Set the origin of the selectedImage according to scroll
        movingImageView.frame.origin.x -= homeViewController.collectionView.contentOffset.x
        
        //Assign the image through using the tappedCellData PFFile
        movingImageView.file = homeViewController.tappedCellData
        movingImageView.loadInBackground()
        movingImageView.layer.cornerRadius = 6
        movingImageView.clipsToBounds = true
        
        //Add cloned image to view
        containerView.addSubview(movingImageView)

        //Temporarily hide the initial and final images
        homeViewController.tappedCell.hidden = true
        detailViewController.cardView.hidden = true
        
        //Temporarily hide the destination VC
        toViewController.view.alpha = 0
        
        //Temporarily hide icons
        detailViewController.backButton.alpha = 0
        detailViewController.trashButton.alpha = 0
        detailViewController.shareButton.alpha = 0
        
        //Animate
        UIView.animateWithDuration(duration, animations: {
            
            //Show the destination VC again
            toViewController.view.alpha = 1
            
            //Animate the cloned image to its position
            movingImageView.frame = destinationViewFrame
            
            //Show the buttons  
            detailViewController.backButton.alpha = 1
            detailViewController.trashButton.alpha = 1
            detailViewController.shareButton.alpha = 1

            }) { (finished: Bool) -> Void in
                
                //Complete by unhiding the temporarily hidden cardView
                detailViewController.cardView.hidden = false
                
                //And hide the cloned image
                movingImageView.removeFromSuperview()
                
                self.finish()
        }
    }
    
    override func dismissTransition(containerView: UIView, fromViewController: UIViewController, toViewController: UIViewController) {
        
        //Cast the VCs
        let detailViewController = fromViewController as! DetailViewController
        let homeViewController = toViewController as! HomeViewController
        
        //If there has been a newly created card, set the collection view offset to 0
                
        if detailViewController.dismissType == "standard" {
            //Clone the image
            let movingImageView = PFImageView()
            
            //Set frame for moving view
            movingImageView.frame = detailViewController.cardView.frame
            
            //Assign the image through using the tappedCellData PFFile
            movingImageView.file = homeViewController.tappedCellData
            movingImageView.layer.cornerRadius = 6
            movingImageView.clipsToBounds = true
            
            //Set destination for moving frame
            var destinationViewFrame = homeViewController.tappedCellFrame
            destinationViewFrame.origin.x -= homeViewController.collectionView.contentOffset.x
            
            //Set the origin of the cloned image before the animation to be according to scroll on Detail VC
            movingImageView.frame.origin.y -= detailViewController.scrollView.contentOffset.y
            
            
            //Add cloned image
            containerView.addSubview(movingImageView)
            
            //Show the destination VC
            fromViewController.view.alpha = 1
            
            //Temporarily hide initial and final images
            detailViewController.cardView.hidden = true
            
            homeViewController.tappedCell.hidden = true
            
            //Animate
            UIView.animateWithDuration(duration, animations: {
                
                //Hide the original VC
                detailViewController.view.alpha = 0
                
                //Animate the cloned view to its position
                movingImageView.frame = destinationViewFrame
                
                }) { (finished: Bool) -> Void in
                    
                    //Complete by unhiding the temporarily
                    homeViewController.tappedCell.hidden = false
                    
                    //And hide the cloned image
                    movingImageView.removeFromSuperview()
                    
                    self.finish()
            }
        } else if detailViewController.dismissType == "delete" {
            
            UIView.animateWithDuration(duration, animations: {
                
                fromViewController.view.alpha = 0
        
                }) { (finished: Bool) -> Void in
                    homeViewController.tappedCell.hidden = false
                    self.finish()
            }
            
        }
    }
}