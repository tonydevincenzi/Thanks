//
//  CardTemplate.swift
//  Thanks
//
//  Created by Anthony Devincenzi on 3/7/16.
//  Copyright © 2016 Friendly Apps. All rights reserved.
//

import UIKit

class CardTemplate: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    var card = Card(title:"", body:"", image: nil)
    var indexNumber: Int?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
}
