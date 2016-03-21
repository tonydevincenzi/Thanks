//
//  CreateAccountViewController.swift
//  Thanks
//
//  Created by Jan Senderek on 3/20/16.
//  Copyright © 2016 Friendly Apps. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController, UITextFieldDelegate {

    
    //Outlets
    @IBOutlet weak var nameField: UITextField!
    
    
    //ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Text field delegate to be able to cause actions from keyboard return key
        self.nameField.delegate = self
    }

    
    //ViewDidAppear
    override func viewDidAppear(animated: Bool) {
        nameField.becomeFirstResponder()
    }
    
    
    //Hook up keyboard return key action
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        
        nameField.resignFirstResponder()
        nextStep()
        return true
    }
    
    
    //The keyboard return key action - we can modify this later to show the input cells for email and password
    func nextStep() {
        performSegueWithIdentifier("createAccount", sender: self)
        //action events
    }
    
    
    
    
    
    //Hide status bar
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    
    //Hide keyboard on tap
    @IBAction func tappedView(sender: AnyObject) {
        view.endEditing(true)
    }




}
