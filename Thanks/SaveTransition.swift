//
//  CellTransition.swift
//
//  Created by Timothy Lee on 11/4/14.
//  Copyright (c) 2014 Timothy Lee. All rights reserved.
//

import UIKit

class SaveTransition: BaseTransition {
    
    override func presentTransition(containerView: UIView, fromViewController: UIViewController, toViewController: UIViewController) {
        
        toViewController.view.alpha = 0
        
        let createViewController = fromViewController as! CreateCardViewController
        var detailViewController = toViewController as! DetailViewController
        let destinationViewFrame = detailViewController.cardView.frame
        
        let movingImageView = UIImageView()
        
        movingImageView.frame = createViewController.tappedImage.frame
        
        movingImageView.image = createViewController.tappedImage.image
        movingImageView.clipsToBounds = createViewController.tappedImage.clipsToBounds
        movingImageView.contentMode = createViewController.tappedImage.contentMode
        containerView.addSubview(movingImageView)
        
        containerView.addSubview(movingImageView)
        
        //Hide the initial and final images
        createViewController.cardView.hidden = true
        detailViewController.cardView.hidden = true
        
        
        UIView.animateWithDuration(duration, animations: {
            
            toViewController.view.alpha = 1
            movingImageView.frame = destinationViewFrame
            
            }) { (finished: Bool) -> Void in
                
                movingImageView.hidden = true
                detailViewController.cardView = movingImageView
                detailViewController.cardView.hidden = false
                
                self.finish()
        }
    }
    
    override func dismissTransition(containerView: UIView, fromViewController: UIViewController, toViewController: UIViewController) {
        
        let homeViewController = toViewController as! HomeViewController
        let detailViewController = fromViewController as! DetailViewController
        
        var destinationViewFrame = homeViewController.tappedCell.frame
        destinationViewFrame.origin.y = homeViewController.tappedCellY
        
        destinationViewFrame.origin.y -= homeViewController.collectionView.contentOffset.y
        
        //movingView should be grabbing the image view from homeViewController
        let movingView = detailViewController.cardView
        movingView.frame = detailViewController.cardView.frame
        
        containerView.addSubview(movingView)
        
        //photoViewController.imageView.hidden = true
        //newsFeedViewController.tappedImage.hidden = true
        
        
        UIView.animateWithDuration(duration, animations: {
            
            movingView.frame = destinationViewFrame
            fromViewController.view.alpha = 0
            
            }) { (finished: Bool) -> Void in
                
                //movingView.hidden = true
                homeViewController.tappedCell.hidden = false
                homeViewController.tappedCell.frame.origin.y = homeViewController.tappedCellY
                homeViewController.tappedCell = movingView
                
                //detailViewController.cardView.hidden = true
                
                self.finish()
        }
    }
}
