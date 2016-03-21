//
//  SettingsViewController.swift
//  Thanks
//
//  Created by Jan Senderek on 3/20/16.
//  Copyright © 2016 Friendly Apps. All rights reserved.
//

import UIKit

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

}
