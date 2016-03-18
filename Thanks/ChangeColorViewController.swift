//
//  ChangeColorViewController.swift
//  Thanks
//
//  Created by Anthony Devincenzi on 3/17/16.
//  Copyright © 2016 Friendly Apps. All rights reserved.
//

import UIKit

class ChangeColorViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let allColors = [
        ["D71F62","7A23BA"],["1FD7BC","7A23BA"],["8DD71F","BA6023"],
        ["26D71F","BA9D23"],["D7801F","BA2323"],["1FD7CC","A2BA23"],
        ["2991C8"],["DE4A4A"],["6BEFB6"],
        ["CF28E4"],["2FE741"],["EBDF45"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self

        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight] // for supporting device rotation
        
        overlayView.addSubview(blurEffectView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allColors.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("com.thanks.ColorCell", forIndexPath: indexPath) as! ColorCell
        
        cell.colorView.layer.cornerRadius = 43
        cell.colorView.clipsToBounds = true
        
        let hex: String!
        let hexB: String!
        
        if allColors[indexPath.row].count > 1 {
            //Gradient
            hex = allColors[indexPath.row][0]
            hexB = allColors[indexPath.row][1]
            
            let layer = CAGradientLayer()
            layer.frame = CGRect(x: 0, y: 0, width: cell.colorView.bounds.width, height: cell.colorView.bounds.height)
            layer.colors = [UIColor(hexString: hex)!.CGColor, UIColor(hexString: hexB)!.CGColor]
            cell.colorView.layer.addSublayer(layer)
            
        } else {
            //Solid
            hex = allColors[indexPath.row][0]
            cell.colorView.backgroundColor = UIColor(hexString: hex)
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.dismissViewControllerAnimated(true, completion: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("changeColor", object: allColors[indexPath.row])
    }
    
    @IBAction func didTapDismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        //NSNotificationCenter.defaultCenter().postNotificationName("changeColor", object: nil)
    }
    
}
