//
//  CreateCardViewController.swift
//  Thanks
//
//  Created by Anthony Devincenzi on 3/1/16.
//  Copyright © 2016 Friendly Apps. All rights reserved.
//

import UIKit

class CreateCardViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func didTouchSave(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func didTapSave(sender: AnyObject) {
        
        //Load NSUserDefaults
        let defaults = NSUserDefaults.standardUserDefaults()
        
        //Create a new card, use timeIntervalSince1970 to create a unique ID
        let newCard = ["id":String(NSDate().timeIntervalSince1970),"title": titleTextField.text!, "body": "Card Body"]
        
        //Set the new card back into NSUserDefaults
        defaults.setObject(newCard, forKey: "Card-" + String(NSDate().timeIntervalSince1970))
        defaults.synchronize()
        
        
        //Loop through NSUserDefaults and find all of the "Cards"
        for (key,value) in defaults.dictionaryRepresentation() {
            if String(key).rangeOfString("Card") != nil{
                //Do something with the card
                print(key, value)
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
