//
//  SettingsViewController.swift
//  Thanks
//
//  Created by Jan Senderek on 3/20/16.
//  Copyright © 2016 Friendly Apps. All rights reserved.
//

import UIKit
import Parse

class SettingsViewController: UIViewController {
    
    
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    let remindersButton: ThanksButton = ThanksButton()
    let logoutButton: ThanksButton = ThanksButton()
    let deleteButton: ThanksButton = ThanksButton()
    
    
    override func viewDidLoad() {
        
        let parseService: ParseService = ParseService()
        let currentUser = parseService.getUser()
        
        userLabel.text = currentUser.username
        emailLabel.text = currentUser.email
        
        remindersButton.format("Change Reminders", image: nil, tag: 0, xpos: self.view.frame.width/2 - 100, ypos: 220, width: 200, height: 30, shadow: false)
        
        remindersButton.setStyleDark()
        remindersButton.addTarget(self, action: "didTapReminders:", forControlEvents: UIControlEvents.TouchUpInside)
        
        logoutButton.format("Logout", image: nil, tag: 0, xpos: self.view.frame.width/2 - 100, ypos: 270, width: 200, height: 30, shadow: false)
        logoutButton.setStyleDark()
        logoutButton.addTarget(self, action: "didTapLogout:", forControlEvents: UIControlEvents.TouchUpInside)
        
        deleteButton.format("Delete Account", image: nil, tag: 0, xpos: self.view.frame.width/2 - 100, ypos: 320, width: 200, height: 30, shadow: false)
        deleteButton.setStyleDark()
        deleteButton.addTarget(self, action: "didTapDeleteAccount:", forControlEvents: UIControlEvents.TouchUpInside)

        
        view.addSubview(remindersButton)
        view.addSubview(logoutButton)
        view.addSubview(deleteButton)
        
    }
    
    func didTapReminders(sender: AnyObject) {
        performSegueWithIdentifier("showReminders", sender: self)
    }
    
    @IBAction func didTapBack(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func didTapLogout(sender: AnyObject) {
        let parseService:ParseService = ParseService()
        parseService.logOutUser()
        
        performSegueWithIdentifier("showOnboarding", sender: self)

    }

    @IBAction func didTapDeleteAccount(sender: AnyObject) {
        
        let alert = UIAlertController(title: "Are you sure you want to delete your account and all of your cards? This cannot be undone.", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .Default, handler: { action in
            switch action.style{
            case .Default:
                let parseService:ParseService = ParseService()
                parseService.deleteUser()
                self.performSegueWithIdentifier("showOnboarding", sender: self)
            case .Cancel:
                print("cancel")
            case .Destructive:
                print("destructive")
            }
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
