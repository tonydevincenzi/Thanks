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

var cards: [Card] = []

/*                */

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    //Outlets
    @IBOutlet weak var collectionView: UICollectionView!

    //Variables

    var numberOfCards: Int!
    var detailTransition: DetailTransition!
    var fadeTransition: FadeTransition!
    var tappedCell: UIView!
    var tappedCellData: PFFile!
    var tappedCellFrame: CGRect!
    
    
    
    //View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Notification stuff?
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshCollection:", name:"refresh", object: nil)

        //Collection views require you set both delegate and datasource for self, just like table views
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
 
        loadData()
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
                case .Cancel:
                    print("cancel")
                case .Destructive:
                    print("destructive")
                }
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    //Parse loads data
    func loadData() {
        
        print("Loading data...")
        
        //All Parse related stuff handled in the ParseService class
        let parseService = ParseService()
        
        parseService.getCards { (returnedCards) in
            //Completion handler returns cards, assign them and redraw
            cards = returnedCards
            self.numberOfCards = returnedCards.count
            self.collectionView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //Refresh
    func refreshCollection(notification: NSNotification){
        print("refreshing...")
        //Rather than reloading data, just reddraw the collection view
        self.numberOfCards = cards.count
        self.collectionView.reloadData()
    }
    
    
    //Tap to Refresh
    @IBAction func didTapRefresh(sender: AnyObject) {
        //TODO: Should not always requery data on refresh, sometimes should just append the existing list (i.e., from new card call)
        loadData()
    }
    
    
    //Divide collectionView into two sections, one of which will show the static card
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }
    
    
    //Required to specify how many items are in the collection, make number dynamic later
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        } else if section == 1 {
            guard numberOfCards != nil else {
                print("Not loaded yet")
                return 0
            }
            return numberOfCards
        } else {
            return 0
        }
    }
    
    //Required to specify the unique settings of the cell
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        
        if indexPath.section == 0 {
            let createCell = collectionView.dequeueReusableCellWithReuseIdentifier("createCell", forIndexPath: indexPath) as! CreateViewCell
            createCell.imageView.image = UIImage(named: "new_card_cell")
            return createCell
        } else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cardCellView", forIndexPath: indexPath) as! CardCellView
            
            //Set the cardImage (which is a PFImageView) to the PFFile returned by parse
            cell.cardImage?.file = cards[indexPath.row].image!
            cell.cardImage.loadInBackground()
            
            return cell
        }

    }
    
    
    
    //Segue for Cell
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let cell: UICollectionViewCell = collectionView.cellForItemAtIndexPath(indexPath)!
        let cellAttributes: UICollectionViewLayoutAttributes = self.collectionView.layoutAttributesForItemAtIndexPath(indexPath)!
        let frame = cellAttributes.frame
        
        let data: PFFile = cards[indexPath.row].image!
        
        //Save the selected cell's PFData
        tappedCellData = data
        
        //Save the actual selected cell
        tappedCell = cell
        
        //Save the selected cell's frame, you cannot infer this from the saved cell (tappedCell), you have to save via layoutAttributesForItemAtIndexPath... see *cellAttributes* above
        tappedCellFrame = frame
        
        self.performSegueWithIdentifier("showDetail", sender: self)
    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        //print(collectionView.contentOffset.x)
        
    }
    

    //Passing data in Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //This lets us use the newCard segue without using the DetailView code below
        if segue.identifier == "newCard" {
            
            let destinationViewController = segue.destinationViewController as! CreateCardViewController
            destinationViewController.modalPresentationStyle = UIModalPresentationStyle.Custom
            fadeTransition = FadeTransition()
            destinationViewController.transitioningDelegate = fadeTransition
            fadeTransition.duration = 0.3
        }
        
        //Settings Segue
        if segue.identifier == "settingsSegue" {
            
            let destinationViewController = segue.destinationViewController as! SettingsViewController
            destinationViewController.modalPresentationStyle = UIModalPresentationStyle.Custom
            fadeTransition = FadeTransition()
            destinationViewController.transitioningDelegate = fadeTransition
            fadeTransition.duration = 0.3
        }
        
        
        //Segue to Detail View Controller
        if segue.identifier == "showDetail" {
            
            let indexPaths = self.collectionView!.indexPathsForSelectedItems()!
            let indexPath = indexPaths[0] as NSIndexPath
            
            let destinationViewController = segue.destinationViewController as! DetailViewController
            destinationViewController.passedImage = cards[indexPath.row].image!
            destinationViewController.passedObjectId = cards[indexPath.row].objectId!
            
            destinationViewController.modalPresentationStyle = UIModalPresentationStyle.Custom
            detailTransition = DetailTransition()
            destinationViewController.transitioningDelegate = detailTransition
            detailTransition.duration = 0.3
        }
        
        
        
    }

}
