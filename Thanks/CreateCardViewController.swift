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

class CreateCardViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateLabelView: UILabel!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var emojiContainer: UIView!
    
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var photoLabel: UILabel!
    
    @IBOutlet weak var simpleButton: UIButton!
    @IBOutlet weak var simpleLabel: UILabel!
    
    @IBOutlet weak var colorButton: UIButton!
    @IBOutlet weak var colorLabel: UILabel!
    
    var cardStyles = ["simple", "color", "photo"]
    var currentCardStyle = 0
    
    var createdEmojiOriginalCenter: CGPoint!
    var cardOriginalCenter: CGPoint!
    var createdEmoji: UILabel!
    var rotation = CGFloat(0)

    var fadeTransition: FadeTransition!
    
    let addEmojiButton:ThanksButton = ThanksButton()
    let addEmojiContainer: UIView = UIView()
    var currentEmoji: UILabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bodyTextView.delegate = self;
        cardView.layer.cornerRadius = 6
        emojiContainer.layer.cornerRadius = 6
        setDate()
        
        nameTextField.frame.origin.y = placeholderLabel.frame.origin.y + placeholderLabel.frame.height
        
        addEmojiButton.format("Add Emoji  🎉", image: nil, tag: 0, xpos: cardView.frame.width/2 - 75, ypos: cardView.frame.height - 50, width: 150, height: 30, shadow: false)
        addEmojiButton.addTarget(self, action: "didTapAddEmoji:", forControlEvents: UIControlEvents.TouchUpInside)
        
        //Register to receive an emoji from AddEmojiView
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "AddEmojiToCard:", name:"addEmoji", object: nil)

        cardView.addSubview(addEmojiButton)
        cardView.clipsToBounds = false
        cardView.layer.shadowColor = UIColor.blackColor().CGColor
        cardView.layer.shadowOffset = CGSize(width: 0, height: 10)
        cardView.layer.shadowOpacity = 0.3
        cardView.layer.shadowRadius = 15
        cardOriginalCenter = cardView.center
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        let panCardView: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: "panCardView:")
        cardView.addGestureRecognizer(panCardView)
        
        simpleButton.layer.cornerRadius = 6
        colorButton.layer.cornerRadius = 6
        photoButton.layer.cornerRadius = 6
        
        resetStyleButton(currentCardStyle)
    }
    
    func panCardView(sender: UIPanGestureRecognizer) {
        
        let translation = sender.translationInView(view)
        //let velocity = sender.velocityInView(view)
        
        if sender.state == UIGestureRecognizerState.Began {
            cardOriginalCenter = cardView.center
        } else if sender.state == UIGestureRecognizerState.Changed {
            cardView.center = CGPoint(x: cardOriginalCenter.x + (translation.x * 0.2), y: cardOriginalCenter.y + (translation.y * 0.2))
            
            if -50...50 ~= translation.y {
                print(translation.y)
                
            } else {
                dismissKeyboard()
            }
            
        } else if sender.state == UIGestureRecognizerState.Ended {
            
            UIView.animateWithDuration(globalAnimationSpeed, delay: 0, usingSpringWithDamping: globalSpringDampening, initialSpringVelocity: globalSpringVelocity, options: UIViewAnimationOptions.AllowUserInteraction , animations: { () -> Void in
                self.cardView.center = self.cardOriginalCenter
                }, completion: { (Bool) -> Void in
            })
        }
    }
    
    func AddEmojiToCard(notification: NSNotification) {
        print(notification.object)
        
        createdEmoji = UILabel()
        createdEmoji.text = String(notification.object!)
        createdEmoji.font = UIFont(name: ".SFUIText-Light", size: 150)
        createdEmoji.textAlignment = .Center
        createdEmoji.frame = CGRectMake(view.bounds.width/2 - 75, 20, 225, 225)
        
        self.createdEmoji.transform = CGAffineTransformMakeScale(0.7, 0.7)
        UIView.animateWithDuration(0.5, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [], animations: { () -> Void in
                self.createdEmoji.transform = CGAffineTransformMakeScale(0.5, 0.5)
            }) { (Bool) -> Void in
                //
        }
        
        let tap = UILongPressGestureRecognizer(target: self, action: "longPressEmoji:")
        createdEmoji.addGestureRecognizer(tap)
        
        let pan = UIPanGestureRecognizer(target: self, action: "panEmoji:")
        createdEmoji.addGestureRecognizer(pan)
        
        let pinch = UIPinchGestureRecognizer(target: self, action: "pinchEmoji:")
        createdEmoji.addGestureRecognizer(pinch)
        pinch.delegate = self

        let rotate = UIRotationGestureRecognizer(target: self, action: "rotateEmoji:")
        createdEmoji.addGestureRecognizer(rotate)
        
        createdEmoji.userInteractionEnabled = true
        emojiContainer.addSubview(createdEmoji)
    }
    
    func longPressEmoji(sender: UILongPressGestureRecognizer) {
        if sender.state == .Began {
            dismissKeyboard()
            beginEmojiDeleteMode(sender.view as! UILabel)
        }
    }
    
    func endEmojiDeleteMode(sender: UITapGestureRecognizer?) {
        currentEmoji.layer.removeAllAnimations()
        currentEmoji.alpha = 1
        
        let views = currentEmoji.subviews
        for view in views{
            if let str = view as? UIButton {
                view.removeFromSuperview()
            }
        }
        
        if sender != nil {
            view.removeGestureRecognizer(sender!)
        }
    }
    
    func beginEmojiDeleteMode(emoji: UILabel) {
        
        currentEmoji = emoji
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "endEmojiDeleteMode:")
        view.addGestureRecognizer(tap)

        let delete = UIButton()
        delete.frame = CGRect(x: 20, y: 20, width: 44, height: 44)
        delete.backgroundColor = UIColor(white: 1, alpha: 0.9)
        delete.layer.cornerRadius = 22
        delete.layer.shadowColor = UIColor.blackColor().CGColor
        delete.layer.shadowOffset = CGSize(width: 0, height: 1)
        delete.layer.shadowOpacity = 0.3
        delete.layer.shadowRadius = 2
        delete.setImage(UIImage(named: "delete-x.png"), forState: UIControlState.Normal)
        delete.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
        delete.addTarget(self, action: "deleteEmoji:", forControlEvents: UIControlEvents.TouchUpInside)

        emoji.addSubview(delete)
        
        emoji.alpha = 0.8
        UIView.animateWithDuration(0.1, delay: 0, options: [], animations: { () -> Void in
            emoji.transform = CGAffineTransformRotate(emoji.transform, -5 * CGFloat(M_PI / 180))
            }, completion: { (Bool) -> Void in
                UIView.animateWithDuration(0.1, delay: 0, options: [.Repeat, .Autoreverse, .AllowUserInteraction], animations: { () -> Void in
                    emoji.transform = CGAffineTransformRotate(emoji.transform, 5 * CGFloat(M_PI / 180))
                    
                    }, completion: { (Bool) -> Void in
                })
        })
    }
    
    func deleteEmoji(sender:UIButton!) {
        print(sender)
        
        UIView.animateWithDuration(0.3, delay: 0, options: [], animations: { () -> Void in
            
            sender.superview!.transform = CGAffineTransformScale(sender.superview!.transform, 1.2, 1.2)
            
            }, completion: { (Bool) -> Void in
                UIView.animateWithDuration(0.1, delay: 0, options: [], animations: { () -> Void in
                    sender.superview!.transform = CGAffineTransformScale(sender.superview!.transform, 0.1, 0.1)
                    sender.superview!.alpha = 0
                    }, completion: { (Bool) -> Void in
                        sender.superview!.removeFromSuperview()
                })
        })
        
    }
    
    func panEmoji(sender: UIPanGestureRecognizer) {
        
        //let point = sender.locationInView(view)
        //let velocity = sender.velocityInView(view)
        let translation = sender.translationInView(view)
        dismissKeyboard()
        endEmojiDeleteMode(nil)
        emojiContainer.bringSubviewToFront(createdEmoji)
        
        if sender.state == UIGestureRecognizerState.Began {
            createdEmoji = sender.view as! UILabel
            createdEmojiOriginalCenter = createdEmoji.center
            UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [], animations: { () -> Void in
                self.createdEmoji.transform = CGAffineTransformScale(self.createdEmoji.transform, 1.1, 1.1)
                }) { (Bool) -> Void in
                    //
            }
        } else if sender.state == UIGestureRecognizerState.Changed {
            createdEmoji.center = CGPoint(x: createdEmojiOriginalCenter.x + translation.x, y: createdEmojiOriginalCenter.y + translation.y)
        } else if sender.state == UIGestureRecognizerState.Ended {
            UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [], animations: { () -> Void in
                self.createdEmoji.transform = CGAffineTransformScale(self.createdEmoji.transform, 0.9, 0.9)
                }) { (Bool) -> Void in
                    //
            }
        }
    }
    
    func pinchEmoji(pinchGestureRecognizer: UIPinchGestureRecognizer) {
        
        dismissKeyboard()
        let scale = pinchGestureRecognizer.scale
        createdEmoji = pinchGestureRecognizer.view as! UILabel
        createdEmoji.transform = CGAffineTransformScale(createdEmoji.transform, scale, scale)
        pinchGestureRecognizer.scale = 1
        
    }
    
    func rotateEmoji(rotationGestureRecognizer: UIRotationGestureRecognizer) {
        
        dismissKeyboard()
        rotation = rotationGestureRecognizer.rotation
        createdEmoji = rotationGestureRecognizer.view as! UILabel
        createdEmoji.transform = CGAffineTransformRotate(createdEmoji.transform, rotation)
        rotationGestureRecognizer.rotation = 0
    }
    
    func gestureRecognizer(_: UIGestureRecognizer,shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
        return true
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
        performSegueWithIdentifier("addEmoji", sender: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
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
    
    func setSimpleCardStyle() {
        currentCardStyle = 0
    }
    
    func setColorCardStyle() {
        currentCardStyle = 1
        
        //Change backround color
        
        //Change font colors to white
        
        //Change button colors
        
        //Enable background color picker picker
    }
    
    func setPhotoCardStyle() {
        currentCardStyle = 2
    }
    
    func resetStyleButton(style: Int) {
        
        simpleButton.alpha = 0.5
        simpleLabel.alpha = 0.5
        colorButton.alpha = 0.5
        colorLabel.alpha = 0.5
        photoButton.alpha = 0.5
        photoLabel.alpha = 0.5
        
        simpleButton.enabled = true
        colorButton.enabled = true
        photoButton.enabled = true
        
        switch (cardStyles[style]) {
        case "simple":
            setSimpleCardStyle()
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.simpleButton.alpha = 1
                self.simpleLabel.alpha = 1
            })
            simpleButton.enabled = false
            break;
        case "color":
            setColorCardStyle()
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.colorButton.alpha = 1
                self.colorLabel.alpha = 1
            })
            colorButton.enabled = false
            
            break;
        case "photo":
            setPhotoCardStyle()
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.photoButton.alpha = 1
                self.photoLabel.alpha = 1
            })
            photoButton.enabled = false
            
            break;
            
        default:
            break;
        }
    }
    
    @IBAction func didTapStyleButton(sender: AnyObject?) {
        resetStyleButton(sender!.tag)
    }
    
    
    //Hide status bar
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let destinationViewController = segue.destinationViewController as! AddEmojiViewController
        
        destinationViewController.modalPresentationStyle = UIModalPresentationStyle.Custom
        fadeTransition = FadeTransition()
        destinationViewController.transitioningDelegate = fadeTransition
        fadeTransition.duration = 0.5
        
    }
}