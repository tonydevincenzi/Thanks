//
//  CardCellView.swift
//  Thanks
//
//  Created by Anthony Devincenzi on 3/3/16.
//  Copyright © 2016 Friendly Apps. All rights reserved.
//

import UIKit

class CardCellView: UICollectionViewCell {
    
    var cardViewController: UIViewController!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        //Load up the main storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        //Get access to the "CardViewController", which is our template
        cardViewController = storyboard.instantiateViewControllerWithIdentifier("Card") as! CardViewController
        cardViewController.view.frame = self.contentView.bounds
        
        //Arbitrary scale to show how to transform it within the container view cell
        cardViewController.view.transform = CGAffineTransformMakeScale(0.5, 0.5)
        
        //Add the CardView to the UICollectionViewCell
        self.contentView.addSubview(cardViewController.view)
    }
}
