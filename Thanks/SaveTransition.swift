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
        
        detailViewController.trashButton.hidden = true
        
        let movingImageView = UIImageView()
        
        movingImageView.frame = createViewController.cardView.frame
        
        movingImageView.image = createViewController.tappedImage.image
        movingImageView.clipsToBounds = createViewController.tappedImage.clipsToBounds
        movingImageView.contentMode = createViewController.tappedImage.contentMode
        containerView.addSubview(movingImageView)
        
        //Hide the initial and final images
        createViewController.cardView.hidden = true
        detailViewController.cardView.hidden = true
        
        UIView.animateWithDuration(duration, animations: {
            
            toViewController.view.alpha = 1
            movingImageView.frame = destinationViewFrame
            
            }) { (finished: Bool) -> Void in
                
                movingImageView.hidden = true
                detailViewController.cardImageView.image = createViewController.tappedImage.image
                detailViewController.cardView.hidden = false
                
                self.finish()
        }
    }
    
    override func dismissTransition(containerView: UIView, fromViewController: UIViewController, toViewController: UIViewController) {
        
        //Do some animation and transitioning here
        let createViewController = toViewController as! CreateCardViewController
        var detailViewController = fromViewController as! DetailViewController
        createViewController.transitionToHomeView()
        self.finish()
    
    }
}
