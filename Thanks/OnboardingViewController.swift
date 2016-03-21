//
//  OnboardingViewController.swift
//  Thanks
//
//  Created by Anthony Devincenzi on 3/1/16.
//  Copyright © 2016 Friendly Apps. All rights reserved.
//

import UIKit
import Parse

class OnboardingViewController: UIViewController, UIScrollViewDelegate {
    
    //Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var getStartedButton: UIButton!
    
    
    
    //ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (PFUser.currentUser() != nil) {
            print(PFUser.currentUser())
            performSegueWithIdentifier("showLoggedInHome", sender: self)
        }
        
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: 1125, height: 667)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Update UIPageControl
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        var page : Int = Int(round(scrollView.contentOffset.x / 320))
        pageControl.currentPage = page
        
        //Condition to hide/show start and skip buttons
        if(page == 2) {
            self.skipButton.alpha = 0
            UIView.animateWithDuration(0.3, animations: {
                self.getStartedButton.alpha = 1
                self.pageControl.hidden = true
            })
        }
        else {
            getStartedButton.alpha = 0
            skipButton.alpha = 1
            pageControl.hidden = false
        }
        
    }

    //Start Button causing segue
    @IBAction func didTapGetStarted(sender: AnyObject) {
        performSegueWithIdentifier("showReminders", sender: nil)
    }
    
    
    
    
    //Hide status bar
    override func prefersStatusBarHidden() -> Bool {
        return true
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
