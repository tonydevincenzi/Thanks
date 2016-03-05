//
//  HomeViewController.swift
//  Thanks
//
//  Created by Anthony Devincenzi on 3/1/16.
//  Copyright © 2016 Friendly Apps. All rights reserved.
//

import UIKit
import Parse

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    var numberOfCards: Int!
    var cards:NSArray!
    
    override func viewWillAppear(animated: Bool) {
        numberOfCards = 1
        cards = []
        
        let query = PFQuery(className:"cards")
        
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            
            //Declard the total number of cards for user
            self.numberOfCards = Int(objects!.count)
            
            if error == nil{
                
                //Save all of the card data
                self.cards = objects!
                
                //Printing out all card titles, for fun
                for object in objects!{
                    print(object["title"])
                }
                
                self.collectionView.reloadData()
                
                print(self.cards)
                
            }else{
                //Error, Couldn't load the data
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Collection views require you set both delegate and datasource for self, just like table views
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //let card = PFObject(className: "cards")
        //card["title"] = "Card Title"
        //card.saveInBackground()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Required to specify how many items are in the collection, make number dynamic later
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfCards
    }
    
    //Required to specify the unique settings of the cell, will use this later to grab manipulate the Card View via some attributes out of an array
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cardCellView", forIndexPath: indexPath) as! CardCellView

        return cell
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
