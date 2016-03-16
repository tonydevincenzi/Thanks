//
//  DetailViewController.swift
//  Thanks
//
//  Created by Anthony Devincenzi on 3/16/16.
//  Copyright © 2016 Friendly Apps. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var cardView: UIView!
    var imageTransition: CellTransition!
    var cell: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardView.addSubview(cell)

    }
    
    @IBAction func didTapDone(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


