//
//  CellTransition.swift
//
//  Created by Timothy Lee on 11/4/14.
//  Copyright (c) 2014 Timothy Lee. All rights reserved.
//

import UIKit

class ImageTransition: BaseTransition {
    
    override func presentTransition(containerView: UIView, fromViewController: UIViewController, toViewController: UIViewController) {
        
        toViewController.view.alpha = 0

        let homeViewController = fromViewController as! HomeViewController
        let detailViewController = toViewController as! DetailViewController
        let destinationViewFrame = detailViewController.cardView.frame

        //movingView should be grabbing the image view from homeViewController
        //also, movingView should be a UIImageView
        let movingView = homeViewController.tappedCell
        
        movingView.frame = homeViewController.tappedCell.frame

        movingView.frame.origin.y -= homeViewController.collectionView.contentOffset.y

        containerView.addSubview(movingView)
        
        //Hide the initial and final images
        detailViewController.cardView.hidden = true


        UIView.animateWithDuration(duration, animations: {
            
            toViewController.view.alpha = 1
            movingView.frame = destinationViewFrame
            
            }) { (finished: Bool) -> Void in
                
                movingView.hidden = true
                detailViewController.cardView = movingView
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
