//
//  CardViewController.swift
//  Thanks
//
//  Created by Anthony Devincenzi on 3/3/16.
//  Copyright © 2016 Friendly Apps. All rights reserved.
//

import UIKit

class CardViewController: UIViewController {

    @IBOutlet var cardView: UIView!
    var index: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (index != nil) {
            print(index)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
