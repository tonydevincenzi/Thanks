//
//  ParseService.swift
//  Thanks
//
//  Created by Jonathan Choi on 3/5/16.
//  Copyright © 2016 Friendly Apps. All rights reserved.
//

import Foundation
import Parse

final class ParseService {
    
    var query = PFQuery(className: "cards")
    var cards: [Card] = []

    func getCards(onComplete: ([Card]) -> ()) {
        
        //Ask Parse for the everything in the table
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error != nil {
                print("Error in getting objects: \(error)")
            }
            
            // TODO: (tonydev) error handling
            
            if let returnedObjects = objects {
                
                //Loop through the returned objects, and create and return a card per object
                for object in returnedObjects {
                    
                    let title = object["title"] as! String
                    let body = object["body"] as! String
                    // TODO: fetch and assign the image
                    
                    let card = Card(title: title,
                        body: body,
                        image: nil)
                    
                    // append to array
                    self.cards.append(card)
                }
            }

            //Once we have built the entire array, trigger the callback
            onComplete(self.cards)
        }
    }
    
    func saveCard(card: Card, completion: (result: Card) -> Void) {
        
        let cardToSave = PFObject(className: "cards")
        cardToSave["title"] = card.title
        cardToSave["body"] = card.body
        cardToSave.saveInBackground()

        completion(result: card)
    }
    
    func deleteAllCards() {
        
        //NOTE: Careful here, this is very nasty and actually does delete everything, it should be removed at some point
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            for object in objects! {
                object.deleteEventually()
            }
        }
    }
}