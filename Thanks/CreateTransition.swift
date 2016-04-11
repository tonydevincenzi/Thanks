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
        
        //Clone the image and labels
        let movingImageView = UIImageView()
        let movingPlaceholderLabel = UILabel()
        let movingNameLabel = UILabel()
        
        //Set parameters for cloned view
        let destinationViewFrame = createCardViewController.cardView.frame
        movingImageView.frame = homeViewController.tappedCellFrame
        movingImageView.image = UIImage(named:"new_card_cell_v4")
        //movingImageView.layer.cornerRadius = 6
        movingImageView.clipsToBounds = true
        movingImageView.frame.origin.x -= homeViewController.collectionView.contentOffset.x
        
        //Set parameters for cloned placeholderLabel
        movingPlaceholderLabel.frame = homeViewController.tappedCellLabel.frame
        movingPlaceholderLabel.text = homeViewController.tappedCellLabel.text
        movingPlaceholderLabel.font = homeViewController.tappedCellLabel.font
        movingPlaceholderLabel.textColor = UIColor(hex: 0x9B9B9B)
        
        //Grab the original y position of the placeholderLabel
        let placeholderLabelOriginYPos = homeViewController.tappedCellLabel.convertPoint(homeViewController.tappedCellLabel.frame.origin, toView: nil).y - movingPlaceholderLabel.frame.origin.y
        let placeholderLabelOriginXPos = homeViewController.tappedCellLabel.convertPoint(homeViewController.tappedCellLabel.frame.origin, toView: nil).x - movingPlaceholderLabel.frame.origin.x
        
        movingPlaceholderLabel.frame.origin.y = placeholderLabelOriginYPos
        movingPlaceholderLabel.frame.origin.x = placeholderLabelOriginXPos
        
        //Set parameters for cloned nameLabel
        movingNameLabel.frame = homeViewController.tappedCellNameLabel.frame
        movingNameLabel.text = createCardViewController.nameTextField.text
        movingNameLabel.font = homeViewController.tappedCellNameLabel.font
        movingNameLabel.textColor = UIColor(hex: 0x9B9B9B)
        
        //Grab the original y position of the name label
        let nameLabelOriginYPos = homeViewController.tappedCellNameLabel.convertPoint(homeViewController.tappedCellNameLabel.frame.origin, toView: nil).y - movingNameLabel.frame.origin.y
        let nameLabelOriginXPos = homeViewController.tappedCellNameLabel.convertPoint(homeViewController.tappedCellNameLabel.frame.origin, toView: nil).x - movingNameLabel.frame.origin.x
        
        movingNameLabel.frame.origin.y = nameLabelOriginYPos
        movingNameLabel.frame.origin.x = nameLabelOriginXPos
        
        //Add cloned images and labels to view
        containerView.addSubview(movingImageView)
        containerView.addSubview(movingPlaceholderLabel)
        containerView.addSubview(movingNameLabel)
        
        
        //Temporarily hide the initial and final images
        homeViewController.tappedCell.hidden = true
        createCardViewController.cardView.hidden = true
        
        //Temporarily hide the destination VC
        toViewController.view.alpha = 0
        
        //Special animation for corner radius
        let animation = CABasicAnimation(keyPath: "cornerRadius")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.fromValue = 6
        animation.toValue = 0
        animation.duration = duration
        movingImageView.layer.addAnimation(animation, forKey: "cornerRadius")
        
        
        //Animate
        UIView.animateWithDuration(duration, animations: {
            
            //Show the destination VC again
            toViewController.view.alpha = 1
            
            //Animate the cloned image and labels to their target position
            movingImageView.frame = destinationViewFrame
            
            let destinationLabel = createCardViewController.placeholderLabel
            let destinationName = createCardViewController.nameTextField
            
            let placeholderLabeldestinationYPos = destinationLabel.convertPoint(destinationLabel.frame.origin, toView: nil).y - destinationLabel.frame.origin.y
            let placeholderLabeldestinationXPos = destinationLabel.convertPoint(destinationLabel.frame.origin, toView: nil).x - destinationLabel.frame.origin.x
            
            movingPlaceholderLabel.frame.origin.y = placeholderLabeldestinationYPos
            movingPlaceholderLabel.frame.origin.x = placeholderLabeldestinationXPos
            
            
            let nameLabelDestinationYPos = destinationName.convertPoint(destinationName.frame.origin, toView: nil).y - destinationName.frame.origin.y
            let nameLabelDestinationXPos = destinationName.convertPoint(destinationName.frame.origin, toView: nil).x - destinationName.frame.origin.x
            
            movingNameLabel.frame.origin.y = nameLabelDestinationYPos
            movingNameLabel.frame.origin.x = nameLabelDestinationXPos
            
            print(nameLabelOriginXPos)
            print(nameLabelOriginYPos)
            
            //Todo: Figure out why calculated destinationPos isn't equal to nameTextField position
            print(nameLabelDestinationXPos)
            print(nameLabelDestinationYPos)
            print(createCardViewController.nameTextField.frame.origin.x)
            print(createCardViewController.nameTextField.frame.origin.y)
            
            
        }) { (finished: Bool) -> Void in
            
                //Complete by unhiding the temporarily hidden cardView
                createCardViewController.cardView.hidden = false
            
                //And hide the cloned image
                movingImageView.removeFromSuperview()
                movingPlaceholderLabel.removeFromSuperview()
                movingNameLabel.removeFromSuperview()
            
            self.finish()
        }
    }
    
    
    //Transition Back
    override func dismissTransition(containerView: UIView, fromViewController: UIViewController, toViewController: UIViewController) {
        
        //Cast the VCs
        let createCardViewController = fromViewController as! CreateCardViewController
        let homeViewController = toViewController as! HomeViewController
        
        //Clone the images and labels
        let movingImageView = UIImageView()
        let movingPlaceholderLabel = UILabel()
        let movingNameLabel = UILabel()
        
        //Set parameters for cloned image
        movingImageView.frame = createCardViewController.cardView.frame
        movingImageView.image = UIImage(named: "new_card_cell_v4")
        movingImageView.layer.cornerRadius = 0
        movingImageView.clipsToBounds = true
        var destinationViewFrame = homeViewController.tappedCellFrame
        destinationViewFrame.origin.x -= homeViewController.collectionView.contentOffset.x
        
        
        //Set parameters for cloned placeholderLabel
        movingPlaceholderLabel.frame = createCardViewController.placeholderLabel.frame
        movingPlaceholderLabel.text = homeViewController.tappedCellLabel.text
        movingPlaceholderLabel.font = homeViewController.tappedCellLabel.font
        movingPlaceholderLabel.textColor = UIColor(hex: 0x9B9B9B)
//        movingPlaceholderLabel.text = createCardViewController.placeholderLabel.text
        
        movingPlaceholderLabel.frame.origin.y += 53
        movingPlaceholderLabel.frame.origin.x += 12
        
        
        //Set parameters for cloned nameLabel
        movingNameLabel.frame = createCardViewController.nameTextField.frame
        movingNameLabel.text = createCardViewController.nameTextField.text
        movingNameLabel.font = createCardViewController.nameTextField.font
        movingNameLabel.textColor = UIColor(hex: 0x9B9B9B)
        
        movingNameLabel.frame.origin.x += 12
        movingNameLabel.frame.origin.y += 53
        
        
        //Add cloned images and labels
        containerView.addSubview(movingImageView)
        containerView.addSubview(movingPlaceholderLabel)
        containerView.addSubview(movingNameLabel)
        
        
        //Show the destination VC
        fromViewController.view.alpha = 1
        
        //Temporarily hide initial and final images
        createCardViewController.cardView.hidden = true
        homeViewController.tappedCell.hidden = true
        
        let animation = CABasicAnimation(keyPath: "cornerRadius")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.fromValue = 0
        animation.toValue = 6
        animation.duration = duration
        movingImageView.layer.addAnimation(animation, forKey: "cornerRadius")
        
        
        
        //Animate
        UIView.animateWithDuration(duration, animations: {
            
            //Hide the original VC
            fromViewController.view.alpha = 0
            
            //Animate the cloned views to their target position
            movingImageView.frame = destinationViewFrame
            
            movingPlaceholderLabel.frame.origin.x += 13
            movingPlaceholderLabel.frame.origin.y += 60
            
            movingNameLabel.frame.origin.x += 13
            movingNameLabel.frame.origin.y += 60
            
            createCardViewController.dateLabelView.alpha = 0
            
        }) { (finished: Bool) -> Void in
            
            //Complete by unhiding the temporarily
            homeViewController.tappedCell.hidden = false
            
            //And hide the cloned image
            movingImageView.removeFromSuperview()
            movingPlaceholderLabel.removeFromSuperview()
            
            self.finish()
        }
    }
}