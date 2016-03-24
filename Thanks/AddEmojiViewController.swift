//
//  AddEmojiViewController.swift
//  Thanks
//
//  Created by Anthony Devincenzi on 3/17/16.
//  Copyright © 2016 Friendly Apps. All rights reserved.
//

import UIKit
import EmojiKit

class AddEmojiViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var searchField: UITextField!
    
    var searchEmojis = ["💩","😀","😁"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
        
        searchEmojis = allEmojis
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight] // for supporting device rotation
        
        searchField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        
        searchField.layer.borderColor = UIColor.init(white: 1, alpha: 0.5).CGColor
        searchField.layer.borderWidth = 1
        searchField.layer.cornerRadius = 15
        searchField.backgroundColor = UIColor.init(white: 0, alpha: 0.3)
        
        let placeholder = NSAttributedString(string: "Search for your favorite emoji", attributes: [NSForegroundColorAttributeName : UIColor.init(white: 1, alpha: 0.5)])
        searchField.attributedPlaceholder = placeholder;
        

        overlayView.addSubview(blurEffectView)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    func textFieldDidChange(textField: UITextField) {
        //print(textField.text)
        let fetcher = EmojiFetcher()
        
        
        searchEmojis.removeAll()

        if searchField.text?.characters.count > 0 {
            //self.collectionView.hidden = true
            fetcher.query(textField.text!) { emojiResults in
                for emoji in emojiResults {
                    self.searchEmojis.append(emoji.character)
                    self.collectionView.reloadData()

                    //addObject("")
                    //print("Current Emoji: \(emoji.character) \(emoji.name)")
                }
            }
        } else {
            searchEmojis = allEmojis
            collectionView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchEmojis.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("com.thanks.EmojiCell", forIndexPath: indexPath) as! EmojiCell
        let emoji = String(searchEmojis[indexPath.row])
        
        print("Loading cell")
        cell.emojiLabel.text = emoji
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        dismissViewControllerAnimated(true, completion: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("addEmoji", object: searchEmojis[indexPath.row])
    }
    
    
    @IBAction func didTapDone(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }


}