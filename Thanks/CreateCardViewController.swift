//
//  CreateCardViewController.swift
//  Thanks
//
//  Created by Anthony Devincenzi on 3/1/16.
//  Copyright © 2016 Friendly Apps. All rights reserved.
//

import UIKit
import Parse

extension String {
    func sizeForWidth(width: CGFloat, font: UIFont) -> CGSize {
        let attr = [NSFontAttributeName: font]
        let height = NSString(string: self).boundingRectWithSize(CGSize(width: width, height: CGFloat.max), options:.UsesLineFragmentOrigin, attributes: attr, context: nil).height
        return CGSize(width: width, height: ceil(height))
    }
}

class CreateCardViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateLabelView: UILabel!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    
    let addEmojiButton:ThanksButton = ThanksButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bodyTextView.delegate = self;
        cardView.layer.cornerRadius = 6
        setDate()
        
        nameTextField.frame.origin.y = placeholderLabel.frame.origin.y + placeholderLabel.frame.height
        
        addEmojiButton.format("Add Emoji  🎉", image: nil, tag: 0, xpos: cardView.frame.width/2 - 75, ypos: cardView.frame.height - 50, width: 150, height: 30, shadow: false)
        addEmojiButton.addTarget(self, action: "didTapAddEmoji:", forControlEvents: UIControlEvents.TouchUpInside)

        cardView.addSubview(addEmojiButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func resizeTextView() {
        let fixedWidth = bodyTextView.frame.size.width
        bodyTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        let newSize = bodyTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        var newFrame = bodyTextView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        bodyTextView.frame = newFrame;
        bodyTextView.frame.origin.y = cardView.frame.height/2 - bodyTextView.frame.height/2 - 25
        
        placeholderLabel.frame.origin.y = bodyTextView.frame.origin.y + 4
    }
    
    func setDate() {
        let dateFormatter = NSDateFormatter()
        let currentDate = NSDate()
        dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        let convertedDate = dateFormatter.stringFromDate(currentDate)
        dateLabelView.text = convertedDate
    }
    
    func setNameTextFieldLocation() {
        UIView.animateWithDuration(0.1) { () -> Void in
            self.nameTextField.frame.origin.y = self.bodyTextView.frame.origin.y + self.bodyTextView.frame.height
        }
    }
    
    func textViewDidChange(textView: UITextView) {
        
        let numLines = bodyTextView.text.sizeForWidth(bodyTextView.contentSize.width, font: bodyTextView.font!).height / bodyTextView.font!.lineHeight
        
        if numLines < 10 {
            resizeTextView()
            setNameTextFieldLocation()
        }
        
        if bodyTextView.text.characters.count > 0 {
            placeholderLabel.hidden = true
        } else {
            placeholderLabel.hidden = false
            nameTextField.frame.origin.y = placeholderLabel.frame.origin.y + placeholderLabel.frame.height
        }
    }

    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            //Uncomment if we want return/enter not to add a new line
            //textView.resignFirstResponder()
        }

        return true
    }

    func didTapAddEmoji (sender:UIButton!) {
        print("add some emoji")
    }

    @IBAction func didTapSave(sender: AnyObject) {
      
        let body = bodyTextView.text!
        let card = Card(body: body, image: nil)
        
        //Pass the card to ParseService, save, and return
        //TODO: Some error handling here
         ParseService().saveCard(card) {
            (result: Card) in
                self.dismissViewControllerAnimated(true, completion: nil)
                NSNotificationCenter.defaultCenter().postNotificationName("refresh", object: nil)
        }
    }
    
    //Hide status bar
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    

}
