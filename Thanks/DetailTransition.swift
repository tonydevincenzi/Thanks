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
        
        let homeViewController = fromViewController as! HomeViewController
        let detailViewController = toViewController as! DetailViewController
        let destinationViewFrame = detailViewController.cardView.frame
        

        let movingImageView = PFImageView()
        
        //Set the frame for the moving view from the tapped cell
        movingImageView.frame = homeViewController.tappedCellFrame
        
        //Assign the image through using the tappedCellData PFFile
        movingImageView.file = homeViewController.tappedCellData
        
        containerView.addSubview(movingImageView)

        //Hide the initial and final images
        homeViewController.tappedCell.hidden = true
        detailViewController.cardView.hidden = true
        
        toViewController.view.alpha = 0
        
        UIView.animateWithDuration(duration, animations: {
            toViewController.view.alpha = 1
            movingImageView.frame = destinationViewFrame

            }) { (finished: Bool) -> Void in
                self.finish()
        }
    }
    
    override func dismissTransition(containerView: UIView, fromViewController: UIViewController, toViewController: UIViewController) {
        
        fromViewController.view.alpha = 1
        UIView.animateWithDuration(duration, animations: {
            fromViewController.view.alpha = 0
            }) { (finished: Bool) -> Void in
                self.finish()
        }
    }
    

}
