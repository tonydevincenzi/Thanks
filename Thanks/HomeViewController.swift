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

    var cards: [Card] = []

    @IBOutlet weak var collectionView: UICollectionView!
    var numberOfCards: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Collection views require you set both delegate and datasource for self, just like table views
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
 
        //All Parse related stuff handled in the ParseService class
        let parseService = ParseService()
        
        parseService.getCards { (cards) in
            //Completion handler returns cards, assign them and redraw
            self.cards = cards
            self.numberOfCards = cards.count
            self.collectionView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Required to specify how many items are in the collection, make number dynamic later
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard numberOfCards != nil else {
            print("Not loaded yet")
            return 0
        }
        return numberOfCards
    }
    
    //Required to specify the unique settings of the cell, will use this later to grab manipulate the Card View via some attributes out of an array
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cardCellView", forIndexPath: indexPath) as! CardCellView
        
        //Here we pass through the specific card's data, so that it can properly render itself
        var cardTemplate = NSBundle.mainBundle().loadNibNamed("CardTemplate", owner: self,options: [:])[0] as! CardTemplate
        
        cardTemplate.indexNumber = indexPath.row
        print(cardTemplate.indexNumber)
        
        cell.addSubview(cardTemplate)
        //print(indexPath.row)

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
