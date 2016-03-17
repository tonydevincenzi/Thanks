//
//  AddEmojiViewController.swift
//  Thanks
//
//  Created by Anthony Devincenzi on 3/17/16.
//  Copyright © 2016 Friendly Apps. All rights reserved.
//

import UIKit

class AddEmojiViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var overlayView: UIView!
    
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
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allEmojis.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("com.thanks.EmojiCell", forIndexPath: indexPath) as! EmojiCell
        let emoji = String(allEmojis[indexPath.row])
        cell.emojiLabel.text = emoji
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print(allEmojis[indexPath.row])
        self.dismissViewControllerAnimated(true, completion: nil)
        //NSNotificationCenter.defaultCenter().postNotificationName("refresh", object: nil)
    }


}