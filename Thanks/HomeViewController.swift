//
//  HomeViewController.swift
//  Thanks
//
//  Created by Anthony Devincenzi on 3/1/16.
//  Copyright © 2016 Friendly Apps. All rights reserved.
//

import UIKit
import Parse
import ParseUI

/* Global config: */

var useLocalDataStore:Bool = false
var colorBlue = 0x4A90E2
var colorGray = 0x9B9B9B
var colorLightGray = 0xDFDFDF
var colorDarkGray = 0x4A4A4A
var colorOrange = 0xDE4A4A

var globalAnimationSpeed:NSTimeInterval = 0.8
var globalSpringDampening:CGFloat = 0.7
var globalSpringVelocity:CGFloat = 1

/*                */

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    //Outlets
    @IBOutlet weak var collectionView: UICollectionView!

    //Variables
    var cards: [Card] = []

    var numberOfCards: Int!
    var imageTransition: ImageTransition!
    var tappedCell: UIView!
    var tappedCellY: CGFloat!
    
    var cardImages = [UIImage(named: "card1"), UIImage(named: "card2"), UIImage(named: "card3")]

    
    
    //View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Notification stuff?
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshCollection:", name:"refresh", object: nil)

        //Collection views require you set both delegate and datasource for self, just like table views
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
 
        loadData()
        registerNotifications()
    }
    
    //Shake to Undo
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
    
    //Notifications
    func registerNotifications() {
        let localNotification:UILocalNotification = UILocalNotification()
        localNotification.alertAction = "Time to say thanks..."
        localNotification.alertBody = "Gentle reminder to say thank you to someone"
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 5)
        
        localNotification.repeatInterval = NSCalendarUnit.Day
        
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    
    //Parse loads data
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
    
    
    //Refresh
    func refreshCollection(notification: NSNotification){
        loadData()
        //collectionView.reloadData()
    }
    
    
    //Tap to Refresh
    @IBAction func didTapRefresh(sender: AnyObject) {
        //TODO: Should not always requery data on refresh, sometimes should just append the existing list (i.e., from new card call)
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
    
    //Required to specify the unique settings of the cell
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cardCellView", forIndexPath: indexPath) as! CardCellView
        
        //Set the cardImage (which is a PFImageView) to the PFFile returned by parse
        cell.cardImage.file = cards[indexPath.row].image
        cell.cardImage.loadInBackground()
        
        //Add a tap recognizer on each cell
        let tapGesture = UITapGestureRecognizer(target: self, action: "tapCell:")
        
        cell.userInteractionEnabled = true
        cell.addGestureRecognizer(tapGesture)

        return cell
    }
    
    //Tap cell recognizer - we might remove this and use the native collectionView functionality
    func tapCell(sender: UITapGestureRecognizer) {
        
        //When the cell is tapped, transition to modal
        tappedCell = sender.view
        tappedCellY = sender.view!.frame.origin.y
        performSegueWithIdentifier("showDetail", sender: self)
        
    }
    
    

    //Passing data in Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //This lets us use the newCard segue without using the DetailView code below
        if segue.identifier == "newCard" {
            return
        }
        
        let destinationViewController = segue.destinationViewController as! DetailViewController
        destinationViewController.cell = tappedCell
        
        destinationViewController.modalPresentationStyle = UIModalPresentationStyle.Custom
        imageTransition = ImageTransition()
        destinationViewController.transitioningDelegate = imageTransition
        imageTransition.duration = 0.5
        
    }

}
