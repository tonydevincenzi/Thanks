//
//  Share.swift
//  Thanks
//
//  Created by Anthony Devincenzi on 3/16/16.
//  Copyright © 2016 Friendly Apps. All rights reserved.
//

import Foundation
import UIKit

final class ShareCard {
    
    func shareCard(shareView: UIView, targetView: UIViewController) {
        //TODO: Hard code actual width and height size for card
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(shareView.frame.width, shareView.frame.height), false, 0);
        shareView.drawViewHierarchyInRect(CGRectMake(0,0,shareView.bounds.size.width,shareView.bounds.size.height), afterScreenUpdates: true)
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext();
        let activityItem: [AnyObject] = [image as AnyObject]
        let avc = UIActivityViewController(activityItems: activityItem as [AnyObject], applicationActivities: nil)
        targetView.presentViewController(avc, animated: true, completion: nil)
    }
}