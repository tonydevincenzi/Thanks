//
//  RemindersViewController.swift
//  Thanks
//
//  Created by Anthony Devincenzi on 3/1/16.
//  Copyright © 2016 Friendly Apps. All rights reserved.
//

import UIKit

class RemindersViewController: UIViewController {

    
    //Outlets
    @IBOutlet weak var dailyButton: UIButton!
    @IBOutlet weak var monthlyButton: UIButton!
    @IBOutlet weak var weeklyButton: UIButton!
    @IBOutlet weak var yearlyButton: UIButton!
    
    
    
    //ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Hide status bar
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    
    @IBAction func onReminderEditingChanged(sender: AnyObject) {
        if dailyButton.highlighted == true {
            dailyButton.selected = true
            weeklyButton.selected = false
            monthlyButton.selected = false
            yearlyButton.selected = false
        } else if weeklyButton.highlighted == true {
            dailyButton.selected = false
            weeklyButton.selected = true
            monthlyButton.selected = false
            yearlyButton.selected = false
        } else if monthlyButton.highlighted == true {
            dailyButton.selected = false
            weeklyButton.selected = false
            monthlyButton.selected = true
            yearlyButton.selected = false
        } else if yearlyButton.highlighted == true {
            dailyButton.selected = false
            weeklyButton.selected = false
            monthlyButton.selected = false
            yearlyButton.selected = true
        }
        
    }
    
    
    
    
    
    //Dismissed reminder options
    @IBAction func didTapDismiss(sender: AnyObject) {
        performSegueWithIdentifier("showHome", sender: nil)
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
