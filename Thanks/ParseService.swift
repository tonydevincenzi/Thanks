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
    
    func createAnonUser(name: String, onComplete: (state: String, error: NSError?) -> ()) {
        
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
                    user!["name"] = name
                    user?.saveInBackground()
                }
            }
        }
    }
    
    func getUser() -> PFUser {
        return PFUser.currentUser()!
    }
    
    func updateUserName(name: String) {
        var user = PFUser.currentUser()
        user!["name"] = name
        user?.saveInBackground()
    }
    
    func logOutUser() {
        print("Logging out user:\(PFUser.currentUser()?.objectId)")
        PFUser.logOut()
    }
    
    func loginUser(email: String, password: String, onComplete: (state: String, error: NSError?) -> ()) {
        
        print("Logging in – Username: \(email), Password: \(password)")
        
        //PFUser.loginWit
        PFUser.logInWithUsernameInBackground(String(email).lowercaseString, password:password) {
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
        user!.username = String(email).lowercaseString
        user!.email = String(email).lowercaseString
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
    
    func updateUserReminderPreferences(frequency: Int) {
        
        var user = PFUser.currentUser()
        
        switch (frequency) {
            case 0: // Daily
                user!["reminderfrequency"] = frequency
            break;
            case 1: // Weekly
                user!["reminderfrequency"] = frequency
            break;
            case 2: // Monthly
                user!["reminderfrequency"] = frequency
            break;
            case 3: // Yearly
                user!["reminderfrequency"] = frequency
            break;
            case 4: // Never
            user!["reminderfrequency"] = frequency
            break;

            default:
            break;
        }
        
        user?.saveInBackground()
    }
    
    func requestUserPasswordReset() {
        print("Resetting password")
        //This is not working - may be realted to Parse Server
        PFUser.requestPasswordResetForEmailInBackground("email@domain")

    }
    
    func deleteUser() {
        //This is destructive and permanently delets the current user.
        let user = PFUser.currentUser()
        print("Deleting user: \(user)")
        user?.deleteInBackground()
        deleteAllCards()
        logOutUser()
    }

    func getCards(onComplete: ([Card]) -> ()) {
        
        //Ask Parse for the everything in the table
        if useLocalDataStore == true {
            query.fromLocalDatastore()
        }
        
        query.whereKey("user", equalTo:PFUser.currentUser()!)
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error != nil {
                print("Error in getting objects: \(error)")
            }
            
            // TODO: (tonydev) error handling
            
            if let returnedObjects = objects {
                
                //Loop through the returned objects, and create and return a card per object
                for object in returnedObjects {
                    
                    let objectId = object.objectId
                    let body = object["body"] as! String
                    let author = object["author"] as! String
                    let image = object["image"] as! PFFile
                    
                    let card = Card(objectId: objectId,
                        body: body,
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
    
    func saveCard(var card: Card, completion: (result: Card) -> Void) {
        
        let cardToSave = PFObject(className: "cards")
        cardToSave["body"] = card.body
        cardToSave["author"] = card.author
        cardToSave["image"] = card.image
        cardToSave["user"] = PFUser.currentUser()
        
        cardToSave.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                card.objectId = cardToSave.objectId
                completion(result: card)
            } else {
                print("error saving card")
            }
        }
    }
    
    func deleteOneCard(objectId: String) {
        
        query.whereKey("objectId", equalTo:objectId)
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            for object in objects! {
                object.deleteEventually()
            }
        }
        
    }
    
    func deleteAllCards() {
        
        //NOTE: Careful here, this is very nasty and actually does delete everything, it should be removed at some point
        if useLocalDataStore == true {
            query.fromLocalDatastore()
        }
        query.whereKey("user", equalTo:PFUser.currentUser()!)
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            for object in objects! {
                object.deleteEventually()
            }
        }
    }
}