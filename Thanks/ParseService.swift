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
    
    var query = PFQuery(className: "Cards")
    
    // TODO: add completion handler
    func getCards() -> [Card] {

        var card: [Card] = []
        
        // completion block
        getObjects()
        return []
    }
    
    func getObjects() {
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                print("Error in getting objects: \(error)")
            }

            print(objects)
            // TODO: (tonydev) error handling
            if let returnedObjects = objects {
                for object in returnedObjects {
                    // make this data and create card
                    // TODO: (tonydev) Figure out the correct syntax for retrieving column from Parse.
                    let title = object["title"]
                    let body = object["body"]
                    let image = object["image"]
                    
                    // TODO: make sure type on column matches type on struct
//                    let newCard = Card(title: title as String,
//                                       body: body as String,
//                                       image: image? as UIImage)
                    // append to array
//                    card.append(newCard)
                    
                }
            }
        }
    }
}