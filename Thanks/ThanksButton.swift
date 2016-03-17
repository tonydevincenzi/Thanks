//
//  Button.swift
//  Thanks
//
//  Created by Anthony Devincenzi on 3/17/16.
//  Copyright © 2016 Friendly Apps. All rights reserved.
//

import Foundation
import SwiftHEXColors

class ThanksButton: UIButton {
    
    override init (frame : CGRect) {
        super.init(frame : frame)
    }
    
    convenience init () {
        self.init(frame:CGRect.zero)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    func format(title: String, image: String?, tag: Int, xpos: CGFloat, ypos: CGFloat, width: CGFloat, height: CGFloat, shadow: Bool) {
        
        self.setTitle(title, forState: UIControlState.Normal)
        self.frame = CGRectMake(xpos, ypos, width, height)
        self.setTitleColor(UIColor(hex: colorGray), forState: UIControlState.Normal)
        //self.setTitleColor(UIColor(hex: colorLightGray), forState: UIControlState.Highlighted)

        self.titleLabel!.font = UIFont(name: ".SFUIText-Regular", size: 14)
        
        self.backgroundColor = UIColor.clearColor()
        self.setTitleColor(UIColor(hex: colorGray), forState: .Normal)
        
        self.layer.borderColor = UIColor(hex: colorLightGray)?.CGColor
        self.layer.cornerRadius = 15
        self.layer.borderWidth = 1
        
        if image != nil {
            self.setImage(UIImage(named: image!), forState: UIControlState.Normal)
            self.imageEdgeInsets = UIEdgeInsetsMake(0.0, -30.0, 0.0, 0.0)
        }
        if shadow != false {
            self.layer.shadowColor = UIColor.blackColor().CGColor
            self.layer.shadowOffset = CGSize(width: 0, height: 1)
            self.layer.shadowOpacity = 0.1
            self.layer.shadowRadius = 2
        }

        self.tag = tag
        
        self.addTarget(self, action: "buttonTouchDown:", forControlEvents: UIControlEvents.TouchDown)
        self.addTarget(self, action: "buttonTouchUp:", forControlEvents: UIControlEvents.TouchUpInside)

    }
    
    func buttonTouchDown(sender:UIButton)
    {
        UIView.animateWithDuration(0.05) { () -> Void in
            self.transform = CGAffineTransformMakeScale(0.97, 0.97)
        }
        //self.layer.borderColor = UIColor(hex: colorGray)?.CGColor
    }
    
    func buttonTouchUp(sender:UIButton)
    {
        UIView.animateWithDuration(0.05) { () -> Void in
            self.transform = CGAffineTransformMakeScale(1, 1)
        }
        //self.layer.borderColor = UIColor(hex: colorLightGray)?.CGColor
    }
}
    