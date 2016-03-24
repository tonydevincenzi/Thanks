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
        let movingPlaceholderLabel = UILabel()
        let movingNameLabel = UILabel()
        
        //Set destination for moving view
        let destinationViewFrame = createCardViewController.cardView.frame
//        let destinationLabelFrame = createCardViewController.placeholderLabel.frame
        
        //Set the frame for the moving view from the tapped cell
        movingImageView.frame = homeViewController.tappedCellFrame
        
        
        movingPlaceholderLabel.frame = homeViewController.tappedCellLabel.frame
        movingPlaceholderLabel.text = homeViewController.tappedCellLabel.text

        movingPlaceholderLabel.font = homeViewController.tappedCellLabel.font
        movingPlaceholderLabel.textColor = UIColor(hex: 0xBCBCBC)
        
        movingPlaceholderLabel.frame.origin.y += 114
        movingPlaceholderLabel.frame.origin.x += 25
        
        
        
        movingNameLabel.frame = homeViewController.tappedCellNameLabel.frame
        movingNameLabel.text = homeViewController.tappedCellNameLabel.text
        movingNameLabel.font = homeViewController.tappedCellNameLabel.font
        
        movingNameLabel.frame.origin.y -= 200
        movingNameLabel.frame.origin.x -= 0
        
        
        

        
        print("TAPPEDCELLLABEL +\(homeViewController.tappedCellLabel.frame)")
        print("DESTINATIONLABELFRAME +\(createCardViewController.placeholderLabel.frame)")
        
        //Set the origin of the selectedImage according to scroll
        movingImageView.frame.origin.x -= homeViewController.collectionView.contentOffset.x
        
        //Assign the image through using the tappedCellData PFFile
        movingImageView.image = UIImage(named:"new_card_cell_v4")
        
        //Add cloned image to view
        containerView.addSubview(movingImageView)
        containerView.addSubview(movingPlaceholderLabel)
        
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
//            movingPlaceholderLabel.frame = destinationLabelFrame
            movingPlaceholderLabel.frame.origin.y -= 60
            movingPlaceholderLabel.frame.origin.x -= 13
            
            
        }) { (finished: Bool) -> Void in
            
                //Complete by unhiding the temporarily hidden cardView
                createCardViewController.cardView.hidden = false
                createCardViewController.nameTextField.hidden = false
                
                //And hide the cloned image
                movingImageView.removeFromSuperview()
                movingPlaceholderLabel.removeFromSuperview()
            
            self.finish()
        }
    }
    
    
    //Transition Back
    override func dismissTransition(containerView: UIView, fromViewController: UIViewController, toViewController: UIViewController) {
        
        //Cast the VCs
        let createCardViewController = fromViewController as! CreateCardViewController
        let homeViewController = toViewController as! HomeViewController
        
        //Clone the image
        let movingImageView = UIImageView()
        let movingPlaceholderLabel = UILabel()
        
        //Set frame for moving view
        movingImageView.frame = createCardViewController.cardView.frame
        movingPlaceholderLabel.frame = createCardViewController.placeholderLabel.frame
        
        movingPlaceholderLabel.text = homeViewController.tappedCellLabel.text
        
        movingPlaceholderLabel.font = homeViewController.tappedCellLabel.font
        movingPlaceholderLabel.textColor = UIColor(hex: 0xBCBCBC)
        
        movingPlaceholderLabel.frame.origin.y += 53
        movingPlaceholderLabel.frame.origin.x += 12
        
        //Assign the image through using the tappedCellData PFFile
        movingImageView.image = UIImage(named: "new_card_cell_v4")
        movingPlaceholderLabel.text = createCardViewController.placeholderLabel.text
        
        //Set destination for moving frame
        var destinationViewFrame = homeViewController.tappedCellFrame
        destinationViewFrame.origin.x -= homeViewController.collectionView.contentOffset.x
        
        
        //Add cloned image
        containerView.addSubview(movingImageView)
        containerView.addSubview(movingPlaceholderLabel)
        
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
            movingPlaceholderLabel.frame.origin.x += 13
            movingPlaceholderLabel.frame.origin.y += 60
            
            createCardViewController.dateLabelView.alpha = 0
            
        }) { (finished: Bool) -> Void in
            
            //Complete by unhiding the temporarily
            homeViewController.tappedCell.hidden = false
            
            //And hide the cloned image
            movingImageView.removeFromSuperview()
//            movingPlaceholderLabel.removeFromSuperview()
            
            self.finish()
        }
    }
}