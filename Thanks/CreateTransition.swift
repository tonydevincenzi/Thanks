//
//  CreateTransition.swift
//  Thanks
//
//  Created by Jan Senderek on 3/23/16.
//  Copyright © 2016 Friendly Apps. All rights reserved.
//

import UIKit
import ParseUI

class CreateTransition: BaseTransition {
    
    override func presentTransition(containerView: UIView, fromViewController: UIViewController, toViewController: UIViewController) {
        
        //Cast the VCs
        let homeViewController = fromViewController as! HomeViewController
        let createCardViewController = toViewController as! CreateCardViewController
        
        //Clone the image view
        let movingImageView = UIImageView()
        
        //Set destination for moving view
        let destinationViewFrame = createCardViewController.cardView.frame
        
        //Set the frame for the moving view from the tapped cell
        movingImageView.frame = homeViewController.tappedCellFrame
        
        //Set the origin of the selectedImage according to scroll
        movingImageView.frame.origin.x -= homeViewController.collectionView.contentOffset.x
        
        //Assign the image through using the tappedCellData PFFile
        movingImageView.image = UIImage(named:"new_card_cell_v2")
        
        //Add cloned image to view
        containerView.addSubview(movingImageView)
        
        //Temporarily hide the initial and final images
        homeViewController.tappedCell.hidden = true
        createCardViewController.cardView.hidden = true
        
        //Temporarily hide the destination VC
        toViewController.view.alpha = 0
        
        
        //Animate
        UIView.animateWithDuration(duration, animations: {
            
            //Show the destination VC again
            toViewController.view.alpha = 1
            
            //Animate the cloned image to its position
            movingImageView.frame = destinationViewFrame
            
            
        }) { (finished: Bool) -> Void in
            
            //Complete by unhiding the temporarily hidden cardView
            createCardViewController.cardView.hidden = false
            
            //And hide the cloned image
            movingImageView.removeFromSuperview()
            
            self.finish()
        }
    }
    
    override func dismissTransition(containerView: UIView, fromViewController: UIViewController, toViewController: UIViewController) {
        
        //Cast the VCs
        let createCardViewController = fromViewController as! CreateCardViewController
        let homeViewController = toViewController as! HomeViewController
        
        
        //Clone the image
        let movingImageView = UIImageView()
        
        //Set frame for moving view
        movingImageView.frame = createCardViewController.cardView.frame
        
        //Assign the image through using the tappedCellData PFFile
        movingImageView.image = UIImage(named: "new_card_cell_v2")
        
        //Set destination for moving frame
        var destinationViewFrame = homeViewController.tappedCellFrame
        destinationViewFrame.origin.x -= homeViewController.collectionView.contentOffset.x
        
        
        //Add cloned image
        containerView.addSubview(movingImageView)
        
        //Show the destination VC
        fromViewController.view.alpha = 1
        
        //Temporarily hide initial and final images
        createCardViewController.cardView.hidden = true
        homeViewController.tappedCell.hidden = true
        
        
        //Animate
        UIView.animateWithDuration(duration, animations: {
            
            //Hide the original VC
            fromViewController.view.alpha = 0
            
            //Animate the cloned view to its position
            movingImageView.frame = destinationViewFrame
            
        }) { (finished: Bool) -> Void in
            
            //Complete by unhiding the temporarily
            homeViewController.tappedCell.hidden = false
            
            //And hide the cloned image
            movingImageView.removeFromSuperview()
            
            self.finish()
        }
    }
}