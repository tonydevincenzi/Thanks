//
//  CardCellView.swift
//  Thanks
//
//  Created by Anthony Devincenzi on 3/3/16.
//  Copyright © 2016 Friendly Apps. All rights reserved.
//

import UIKit
import Parse

class CardCellView: UICollectionViewCell {
    
    var cardViewController: UIViewController!
    var cardData:PFObject!
    var cardIndex:Int!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        //Get access to the "CardViewController", which is our template
        cardViewController = storyboard.instantiateViewControllerWithIdentifier("Card") as! CardViewController
        cardViewController.view.frame = self.contentView.bounds
        
        //Arbitrary scale to show how to transform it within the container view cell
        cardViewController.view.transform = CGAffineTransformMakeScale(1.0, 1.0)
        
        //It is instance of  `NewViewController` from storyboard
        let vc : CardViewController = storyboard.instantiateViewControllerWithIdentifier("Card") as! CardViewController
        vc.index = cardIndex
        
        //Add the CardView to the UICollectionViewCell
        self.contentView.addSubview(vc.view)
        
        //cardViewController

        if cardData != nil {
            print(cardData)
        }
    }

}
