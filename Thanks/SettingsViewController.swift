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
    
    
    override func viewDidLoad() {
        
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
