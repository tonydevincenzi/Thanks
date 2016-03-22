//
//  RemindersViewController.swift
//  Thanks
//
//  Created by Anthony Devincenzi on 3/1/16.
//  Copyright © 2016 Friendly Apps. All rights reserved.
//

import UIKit
import Parse

class RemindersViewController: UIViewController {

    
    //Outlets
    @IBOutlet weak var dailyButton: UIButton!
    @IBOutlet weak var monthlyButton: UIButton!
    @IBOutlet weak var weeklyButton: UIButton!
    @IBOutlet weak var yearlyButton: UIButton!
    
    let parseService: ParseService = ParseService()
    var notificatonFrequency:Int!
    
    //ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dailyButton.selected = true

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
            notificatonFrequency = 0
            parseService.updateUserReminderPreferences(notificatonFrequency)

        } else if weeklyButton.highlighted == true {
            dailyButton.selected = false
            weeklyButton.selected = true
            monthlyButton.selected = false
            yearlyButton.selected = false
            notificatonFrequency = 1
            parseService.updateUserReminderPreferences(notificatonFrequency)
            
        } else if monthlyButton.highlighted == true {
            dailyButton.selected = false
            weeklyButton.selected = false
            monthlyButton.selected = true
            yearlyButton.selected = false
            notificatonFrequency = 2
            parseService.updateUserReminderPreferences(notificatonFrequency)
            
        } else if yearlyButton.highlighted == true {
            dailyButton.selected = false
            weeklyButton.selected = false
            monthlyButton.selected = false
            yearlyButton.selected = true
            notificatonFrequency = 3
            parseService.updateUserReminderPreferences(notificatonFrequency)
            
        }
        
    }
    
    func establishNotificationsForUser() {
        
        //Ask for permission to send notifs
        UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Sound, .Alert, .Badge], categories: nil))
        
        let localNotification:UILocalNotification = UILocalNotification()
        localNotification.alertAction = "Time to say thanks..."
        localNotification.alertBody = "Gentle reminder to say thank you to someone"
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 5)
        
        switch (notificatonFrequency) {
            case 0: //Daily
                localNotification.repeatInterval = NSCalendarUnit.Day
            break;
            case 1: // Weekly
                localNotification.repeatInterval = NSCalendarUnit.Weekday
            break;
            case 2: // Monthly
                localNotification.repeatInterval = NSCalendarUnit.Month
            break;
            case 3: // Yearly
                localNotification.repeatInterval = NSCalendarUnit.Year
            break;
            case 4: // Never
            break;

            default:
            break;
        }
        
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        
    }
    
    @IBAction func didTapSave(sender: AnyObject) {
        establishNotificationsForUser()
        performSegueWithIdentifier("showHome", sender: nil)
    }
    
    
    //Dismissed reminder options
    @IBAction func didTapDismiss(sender: AnyObject) {
        
        //Set reminders to never
        parseService.updateUserReminderPreferences(4)
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
