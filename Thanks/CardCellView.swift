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
    
    //Outlets
    @IBOutlet weak var cardTitle: UILabel!
    @IBOutlet weak var cardImage: UIImageView!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }

}
