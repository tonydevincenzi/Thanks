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
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var fieldsContainer: UIView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var showLoginButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    var states = ["login", "signup"]
    var currentState = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentState = states[0]

        //Text field delegate to be able to cause actions from keyboard return key
        nameField.delegate = self
        
        //Add border to text fields
        addBorderToTextField(nameField)
        addBorderToTextField(emailField)
        addBorderToTextField(passwordField)
        
        loginButton.hidden = true
        emailField.hidden = true
        passwordField.hidden = true
        skipButton.hidden = true
        showLoginButton.hidden = false
        createAccountButton.hidden = true
        backButton.hidden = true
        emailField.alpha = 0
        passwordField.alpha = 0
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)

        //Logout any existing PFUser
        //NOTE: This should be removed later if this view is reuused to convert the signup at a later point
        //let parseService = ParseService()
        //parseService.logOutUser()
    }
    
    override func viewDidAppear(animated: Bool) {
        nameField.becomeFirstResponder()
    }
    
    func editedField(sender: UITextField?) {
        
        if currentState == states[1] {
            if emailField.text == "" && passwordField.text == "" {
                skipButton.hidden = false
                createAccountButton.hidden = true
                createAccountButton.alpha = 0
                
            } else {
                skipButton.hidden = true
                createAccountButton.hidden = false
                createAccountButton.alpha = 1
            }
        }
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        
        return emailTest.evaluateWithObject(testStr)
    }
    
    @IBAction func didTapCreateAccount(sender: AnyObject) {
        doCreateAccount(nil)
    }
    
    func doCreateAccount(sender:UIButton?) {
        
        if nameField.text == "" {
            showAlert("Not so fast! What's your name?")
            return
        }
        
        if isValidEmail(emailField.text!) != true {
            showAlert("Sorry, your email address doesn't seem valid.")
            return
        }

        if passwordField.text?.characters.count < 6 {
            showAlert("Oops. Your password isn't quite long enough.")
            return
        }
        
        let parseService = ParseService()
        parseService.signUpUser(nameField.text!, email: emailField.text!, password: passwordField.text!) { (state, error) in
            //Completion handler returns cards, assign them and redraw
            if state == "success" {
                self.nextStep("New user created!")
            } else {
                print(error!.userInfo["error"])
                let message:String = String(error!.userInfo["error"]!)
                self.showAlert(message)
            }
        }

    }
    
    @IBAction func didTapLogin(sender: AnyObject) {
        doLogin(nil)
    }
    
    func doLogin(sender:UIButton?) {
        
        if isValidEmail(emailField.text!) != true {
            showAlert("Sorry, your email address doesn't seem valid.")
            return
        }
        
        if passwordField.text?.characters.count < 6 {
            showAlert("Oops. Your password isn't quite long enough.")
            return
        }
        
        let parseService = ParseService()
        parseService.loginUser(emailField.text!, password: passwordField.text!) { (state, error) in
            //Completion handler returns cards, assign them and redraw
            if state == "success" {
                self.nextStep("Existing user logged in!")
            } else {
                print(error!.userInfo["error"])
                let message:String = String(error!.userInfo["error"]!)
                self.showAlert(message)
            }
        }
        
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
            switch action.style{
            case .Default:
                break
            case .Cancel:
                break
            case .Destructive:
                break
            }
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)

    }
    
    func addBorderToTextField(sender: UITextField) {
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor(hex: 0xBE3739)?.CGColor
        border.frame = CGRect(x: 0, y: sender.frame.size.height - width, width:  sender.frame.size.width, height: sender.frame.size.height)
        
        border.borderWidth = width
        sender.layer.addSublayer(border)
        sender.layer.masksToBounds = true
    }
    
    //Hook up keyboard return key action
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        nameField.resignFirstResponder()
        showSignUp()
        return true
    }
    
    func showSignUp() {
        
        currentState = states[1]
        skipButton.hidden = false
        backButton.hidden = true
        nameField.hidden = false
        emailField.hidden = false
        passwordField.hidden = false
        showLoginButton.hidden = false
        skipButton.hidden = false
        showLoginButton.hidden = false
        loginButton.hidden = true
        emailField.addTarget(self, action:"editedField:", forControlEvents:UIControlEvents.EditingChanged)
        passwordField.addTarget(self, action:"editedField:", forControlEvents:UIControlEvents.EditingChanged)
        emailField.becomeFirstResponder()
        headerLabel.text = "Create an account and we will save your cards."
        showLoginButton.alpha = 0
        editedField(nil)

        UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.headerLabel.frame.origin.y = 65
                self.fieldsContainer.frame.origin.y = 160
                self.emailField.alpha = 1
                self.passwordField.alpha = 1
                self.nameField.alpha = 1
            }) { (Bool) -> Void in
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.showLoginButton.alpha = 0.5
                })
        }
    }
    
    
    @IBAction func didTapSkip(sender: AnyObject) {

        //User skipped sign up, create an anonymous user
        let parseService = ParseService()
        parseService.createAnonUser() { (state, error) in
            //Completion handler returns cards, assign them and redraw
            if state == "success" {
                self.nextStep("Anonymous user created!")
            } else {
                print(error!.userInfo["error"])
                let message:String = String(error!.userInfo["error"]!)
                self.showAlert(message)
            }
        }
    }
    
    @IBAction func didTapShowLogin(sender: AnyObject) {
        
        currentState = states[0]
        backButton.hidden = false
        skipButton.hidden = true
        headerLabel.text = "Log in to get back to your Thank You cards."
        loginButton.hidden = true
        loginButton.hidden = false
        showLoginButton.hidden = true
        loginButton.alpha = 1
        createAccountButton.alpha = 0
        emailField.hidden = false
        passwordField.hidden = false
        emailField.alpha = 0
        passwordField.alpha = 0
        self.nameField.alpha = 1
        
        UIView.animateWithDuration(0.3) { () -> Void in
            self.emailField.alpha = 1
            self.passwordField.alpha = 1
            self.nameField.alpha = 0
            self.headerLabel.frame.origin.y = 65
            self.fieldsContainer.frame.origin.y = 130
        }
    }
    
    @IBAction func didTapBack(sender: AnyObject) {
        showSignUp()
    }
    
    //The keyboard return key action - we can modify this later to show the input cells for email and password
    func nextStep(message: String?) {
        print(message)
        performSegueWithIdentifier("showReminders", sender: self)
    }
    
    //Hide status bar
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    //Hide keyboard on tap
    @IBAction func tappedView(sender: AnyObject) {
        //view.endEditing(true)
    }

    func keyboardWillShow(notification:NSNotification) {
        let userInfo:NSDictionary = notification.userInfo!
        let keyboardFrame:NSValue = userInfo.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.CGRectValue()
        let keyboardHeight = keyboardRectangle.height
        showLoginButton.frame.origin.y = self.view.frame.height - keyboardHeight - showLoginButton.frame.height - 15

    }

}
