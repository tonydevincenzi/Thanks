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
    let changeName: ThanksButton = ThanksButton()

    let parseService: ParseService = ParseService()
    var currentUser: PFUser!

    override func viewDidLoad() {
        
        currentUser = parseService.getUser()
        
        userLabel.text = String(currentUser["name"])
        emailLabel.text = currentUser.email
        
        let buttonsContainer = UIView()
        buttonsContainer.frame = CGRect(x: 0, y: 200, width: view.frame.width, height: view.frame.height - 200)
        //buttonsContainer.backgroundColor = UIColor.redColor()
        buttonsContainer.userInteractionEnabled = true
        view.addSubview(buttonsContainer)
        
        let userTap = UITapGestureRecognizer(target: self, action: "didTapUserLabel:")
        userLabel.addGestureRecognizer(userTap)
        userLabel.userInteractionEnabled = true
        
        changeName.format("Change Username", image: nil, tag: 0, xpos: self.view.frame.width/2 - 100, ypos: 0, width: 200, height: 30, shadow: false)
        changeName.setStyleDark()
        changeName.addTarget(self, action: "didTapUserLabel:", forControlEvents: UIControlEvents.TouchUpInside)
        
        remindersButton.format("Change Reminders", image: nil, tag: 0, xpos: self.view.frame.width/2 - 100, ypos: 50, width: 200, height: 30, shadow: false)
        remindersButton.setStyleDark()
        remindersButton.addTarget(self, action: "didTapReminders:", forControlEvents: UIControlEvents.TouchUpInside)
        
        logoutButton.format("Logout", image: nil, tag: 0, xpos: self.view.frame.width/2 - 100, ypos: buttonsContainer.frame.height - 100, width: 200, height: 30, shadow: false)
        logoutButton.setStyleDark()
        logoutButton.addTarget(self, action: "didTapLogout:", forControlEvents: UIControlEvents.TouchUpInside)
        
        deleteButton.format("Delete Account", image: nil, tag: 0, xpos: self.view.frame.width/2 - 100, ypos: buttonsContainer.frame.height - 50, width: 200, height: 30, shadow: false)
        deleteButton.setStyleDark()
        deleteButton.addTarget(self, action: "didTapDeleteAccount:", forControlEvents: UIControlEvents.TouchUpInside)

        
        buttonsContainer.addSubview(changeName)
        buttonsContainer.addSubview(remindersButton)
        buttonsContainer.addSubview(logoutButton)
        buttonsContainer.addSubview(deleteButton)
        
    }
    
    func didTapUserLabel(sender: UITapGestureRecognizer) {
        
        let alertController = UIAlertController(title: "Change your name", message: "Enter the name you wish to use:", preferredStyle: .Alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .Default) { (_) in
            if let field = alertController.textFields![0] as? UITextField {
                // store your data
                self.parseService.updateUserName(field.text!)
                self.userLabel.text = field.text!
            } else {
                // user did not fill field
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in }
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = String(self.currentUser["name"])
            textField.text = String(self.currentUser["name"])
            textField.layer.cornerRadius = 10
            textField.layer.borderWidth = 0
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
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
