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
    
    func createAnonUser(onComplete: (state: String, error: NSError?) -> ()) {
        
        let currentUser = PFUser.currentUser()
        if currentUser != nil {
            print("Logged in as:\(PFUser.currentUser()?.objectId)")
        } else {
            PFAnonymousUtils.logInWithBlock {
                (user: PFUser?, error: NSError?) -> Void in
                if error != nil || user == nil {
                    onComplete(state: "error", error: error)
                } else {
                    onComplete(state: "success", error: nil)
                }
            }
        }
    }
    
    func logOutUser() {
        print("Logging out user:\(PFUser.currentUser()?.objectId)")
        PFUser.logOut()
    }
    
    func loginUser(email: String, password: String, onComplete: (state: String, error: NSError?) -> ()) {
        
        print("Logging in – Username: \(email), Password: \(password)")
        
        //PFUser.loginWit
        PFUser.logInWithUsernameInBackground(email, password:password) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                onComplete(state: "success", error: nil)
            } else {
                onComplete(state: "error", error: error)
            }
        }
    }
    
    func signUpUser(name: String, email: String, password: String, onComplete: (state: String, error: NSError?) -> ()) {
        
        //First check for a current user
        var user = PFUser.currentUser()
        
        //If no current user, create a new user
        if user == nil {
            user = PFUser()
        }
        
        user!["name"] = name
        user!.username = email
        user!.email = email
        user!.password = password
        
        user!.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                onComplete(state: "error", error: error)
            } else {
                onComplete(state: "success", error: nil)
            }
        }
        
    }

    func getCards(onComplete: ([Card]) -> ()) {
        
        //Ask Parse for the everything in the table
        if useLocalDataStore == true {
            query.fromLocalDatastore()
        }
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error != nil {
                print("Error in getting objects: \(error)")
            }
            
            // TODO: (tonydev) error handling
            
            if let returnedObjects = objects {
                
                //Loop through the returned objects, and create and return a card per object
                for object in returnedObjects {
                    
                    let body = object["body"] as! String
                    let author = object["author"] as! String
                    let image = object["image"] as! PFFile
                    
                    let card = Card(body: body,
                        author:  author,
                        image: image)
                    
                    // append to array
                    self.cards.append(card)
                }
            }

            //Once we have built the entire array, trigger the callback
            onComplete(self.cards.reverse())
        }
    }
    
    func saveCard(card: Card, completion: (result: Card) -> Void) {
        
        let cardToSave = PFObject(className: "cards")
        cardToSave["body"] = card.body
        cardToSave["author"] = card.author
        cardToSave["image"] = card.image

        
        if useLocalDataStore == true {
            cardToSave.pinInBackground()
        } else {
            cardToSave.saveInBackground()
        }

        completion(result: card)
    }
    
    func deleteAllCards() {
        
        //NOTE: Careful here, this is very nasty and actually does delete everything, it should be removed at some point
        if useLocalDataStore == true {
            query.fromLocalDatastore()
        }
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            for object in objects! {
                object.deleteEventually()
            }
        }
    }
}