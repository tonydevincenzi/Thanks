//
//  HomeViewController.swift
//  Thanks
//
//  Created by Anthony Devincenzi on 3/1/16.
//  Copyright © 2016 Friendly Apps. All rights reserved.
//

import UIKit
import Parse

/* Global config: */

var useLocalDataStore:Bool = true

/*                */

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var cards: [Card] = []

    @IBOutlet weak var collectionView: UICollectionView!
    var numberOfCards: Int!
    var cellTransition: CellTransition!
    var tappedCell: UIView!
    var tappedCellY: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshCollection:", name:"refresh", object: nil)

        
        //Collection views require you set both delegate and datasource for self, just like table views
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
 
        loadData()
        registerNotifications()
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake {
            let alert = UIAlertController(title: "Delete all Cards?", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Delete", style: .Default, handler: { action in
                switch action.style{
                case .Default:
                    ParseService().deleteAllCards()
                    NSNotificationCenter.defaultCenter().postNotificationName("refresh", object: nil)
                case .Cancel:
                    print("cancel")
                case .Destructive:
                    print("destructive")
                }
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func registerNotifications() {
        let localNotification:UILocalNotification = UILocalNotification()
        localNotification.alertAction = "Time to say thanks..."
        localNotification.alertBody = "Gentle reminder to say thank you to someone"
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 5)
        
        localNotification.repeatInterval = NSCalendarUnit.Day
        
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    
    func loadData() {
        
        //All Parse related stuff handled in the ParseService class
        let parseService = ParseService()
        
        parseService.getCards { (returnedCards) in
            //Completion handler returns cards, assign them and redraw
            self.cards = returnedCards
            self.numberOfCards = returnedCards.count
            self.collectionView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func refreshCollection(notification: NSNotification){
        loadData()
        //collectionView.reloadData()
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
        
        cell.cardTitle.text = cards[indexPath.row].title
        
        //Add a tap recognizer on each cell
        let tapGesture = UITapGestureRecognizer(target: self, action: "tapCell:")
        
        cell.userInteractionEnabled = true
        cell.addGestureRecognizer(tapGesture)

        return cell
    }
    
    func tapCell(sender: UITapGestureRecognizer) {
        
        //When the cell is tapped, transition to modal
        tappedCell = sender.view
        tappedCellY = sender.view!.frame.origin.y
        performSegueWithIdentifier("showDetail", sender: self)
        
    }
    
    @IBAction func didTapRefresh(sender: AnyObject) {
        //TODO: Should not always requery data on refresh, sometimes should just append the existing list (i.e., from new card call)
        loadData()
        //collectionView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let destinationViewController = segue.destinationViewController as! DetailViewController
        destinationViewController.cell = tappedCell
        
        destinationViewController.modalPresentationStyle = UIModalPresentationStyle.Custom
        cellTransition = CellTransition()
        destinationViewController.transitioningDelegate = cellTransition
        cellTransition.duration = 0.5
        
    }

}
