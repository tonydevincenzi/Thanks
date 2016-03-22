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

class CreateCardViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var cardComponentsContainerView: UIView!
    @IBOutlet weak var editableFieldsContainer: UIView!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateLabelView: UILabel!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var emojiContainer: UIView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var photoContainerView: UIView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var maskedPhotoView: UIImageView!
    @IBOutlet weak var photoOverlayView: UIView!
    
    @IBOutlet weak var buttonsContainerView: UIView!
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var photoLabel: UILabel!
    @IBOutlet weak var simpleButton: UIButton!
    @IBOutlet weak var simpleLabel: UILabel!
    @IBOutlet weak var colorButton: UIButton!
    @IBOutlet weak var colorLabel: UILabel!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var photoNextButton: UIButton!
    
    var saveTransition: SaveTransition!
    var tappedImage: UIImageView = UIImageView()
    var objectId: String!

    var cardHasPhoto:Bool = false
    
    var cardStyles = ["simple", "color", "photo"]
    var previousCardStyle = 0
    var currentCardStyle = 0
    
    var photoOriginalCenter: CGPoint!
    var maskedPhotoOriginalCenter: CGPoint!
    
    var createdEmojiOriginalCenter: CGPoint!
    var cardOriginalCenter: CGPoint!
    var bodyTextOriginalCenter: CGPoint!
    var placeholderLabelOriginalCenter: CGPoint!
    var nameTextFieldOriginalCenter: CGPoint!
    var createdEmoji: UILabel!
    var rotation = CGFloat(0)

    var fadeTransition: FadeTransition!
    
    
    let cardButtonContainer: UIView = PassThroughView()
    let addEmojiButton:ThanksButton = ThanksButton()
    let changeColorButton:ThanksButton = ThanksButton()
    let changePhotoButton:ThanksButton = ThanksButton()
    
    let addEmojiContainer: UIView = UIView()
    var currentEmoji: UILabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let parseService:ParseService = ParseService()
        let currentUser = parseService.getUser()
        
        if currentUser["name"] != nil {
            nameTextField.text = "– " + String(currentUser["name"])
        } else {
            nameTextField.text = "– Your Name"
        }
        
        bodyTextView.delegate = self;
        cardView.layer.cornerRadius = 6
        emojiContainer.layer.cornerRadius = 6
        gradientView.layer.cornerRadius = 6
        photoContainerView.layer.cornerRadius = 6
        photoContainerView.clipsToBounds = true
        photoContainerView.hidden = true
        
        bodyTextView.spellCheckingType = .No
        nameTextField.spellCheckingType = .No
        
        bodyTextOriginalCenter = CGPoint(x: bodyTextView.frame.origin.x, y: bodyTextView.frame.origin.y)
        setDate()
        
        nameTextField.frame.origin.y = placeholderLabel.frame.origin.y + placeholderLabel.frame.height
        
        addEmojiButton.format("🎉  Add Emoji", image: nil, tag: 0, xpos: cardView.frame.width/2 - 75, ypos: cardView.frame.height - 50, width: 150, height: 30, shadow: false)
        addEmojiButton.addTarget(self, action: "didTapAddEmoji:", forControlEvents: UIControlEvents.TouchUpInside)
        
        changeColorButton.format("Change Color", image: nil, tag: 0, xpos: cardView.frame.width/2 + 5, ypos: cardView.frame.height - 50, width: 150, height: 30, shadow: false)
        changeColorButton.addTarget(self, action: "didTapChangeColor:", forControlEvents: UIControlEvents.TouchUpInside)
        
        changePhotoButton.format("Change Photo", image: nil, tag: 0, xpos: cardView.frame.width/2 + 5, ypos: cardView.frame.height - 50, width: 150, height: 30, shadow: false)
        changePhotoButton.addTarget(self, action: "didTapChangePhoto:", forControlEvents: UIControlEvents.TouchUpInside)
        
        //Register to receive an emoji from AddEmojiView
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "addEmojiToCard:", name:"addEmoji", object: nil)
        
        //Register to receive a color from ChangeColorView
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "changeColorOfCard:", name:"changeColor", object: nil)

        cardView.addSubview(cardButtonContainer)
        cardButtonContainer.addSubview(addEmojiButton)
        cardButtonContainer.addSubview(changeColorButton)
        cardButtonContainer.addSubview(changePhotoButton)
        cardButtonContainer.userInteractionEnabled = true
        
        cardView.clipsToBounds = false
        cardView.layer.shadowColor = UIColor.blackColor().CGColor
        cardView.layer.shadowOffset = CGSize(width: 0, height: 10)
        cardView.layer.shadowOpacity = 0.3
        cardView.layer.shadowRadius = 15
        cardOriginalCenter = cardView.center
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        let panBodyTextView: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: "panBodyTextView:")
        bodyTextView.addGestureRecognizer(panBodyTextView)
        
        let tapDateLabel: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "didTapDateLabel:")
        dateLabelView.addGestureRecognizer(tapDateLabel)
        
        //Uncomment to allow card to pan
        //let panCardView: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: "panCardView:")
        //cardView.addGestureRecognizer(panCardView)
        
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
    
    func didTapDateLabel(sender: UITapGestureRecognizer) {
        print("Tapped date")
    }
    
    
    func panBodyTextView(sender: UIPanGestureRecognizer) {
        
        let translation = sender.translationInView(view)
        //let velocity = sender.velocityInView(view)
        
        if sender.state == UIGestureRecognizerState.Began {
            bodyTextOriginalCenter = bodyTextView.center
            placeholderLabelOriginalCenter = placeholderLabel.center
            nameTextFieldOriginalCenter = nameTextField.center
        } else if sender.state == UIGestureRecognizerState.Changed {
            bodyTextView.center = CGPoint(x: bodyTextOriginalCenter.x, y: bodyTextOriginalCenter.y + (translation.y))
            placeholderLabel.center = CGPoint(x: placeholderLabelOriginalCenter.x, y: placeholderLabelOriginalCenter.y + (translation.y))
            nameTextField.center = CGPoint(x: nameTextFieldOriginalCenter.x, y: nameTextFieldOriginalCenter.y + (translation.y))

            if -50...50 ~= translation.y {
                print(translation.y)
                
            } else {
                //dismissKeyboard()
            }
            
        } else if sender.state == UIGestureRecognizerState.Ended {
            
            bodyTextOriginalCenter = bodyTextView.center
        }
    }
    
    
    func changeColorOfCard(notification: NSNotification) {
        
        let newColor = notification.object as! NSArray
        let hex: String!
        let hexB: String!
        
        if newColor.count > 1 {
            //Gradient
            hex = String(newColor[0])
            hexB = String(newColor[1])
            
            let layer = CAGradientLayer()
            layer.frame = CGRect(x: 0, y: 0, width: cardView.frame.width, height: cardView.frame.height)
            layer.colors = [UIColor(hexString: hex)!.CGColor, UIColor(hexString: hexB)!.CGColor]
            
            gradientView.layer.addSublayer(layer)
            gradientView.hidden = false
            
        } else {
            //Solid
            hex = String(newColor[0])
            cardView.backgroundColor = UIColor(hexString: hex)
            gradientView.hidden = true
        }

    }
    
    func addEmojiToCard(notification: NSNotification) {
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
        bodyTextView.frame.origin.y = bodyTextOriginalCenter.y - bodyTextView.frame.height/2 + 15
        
        placeholderLabel.frame.origin.y = bodyTextView.frame.origin.y
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
            placeholderLabel.hidden = true
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

    func didTapAddEmoji(sender:UIButton!) {
        performSegueWithIdentifier("addEmoji", sender: nil)
    }
    
    func didTapChangeColor(sender:UIButton!) {
        performSegueWithIdentifier("changeColor", sender: nil)
    }
    
    func didTapChangePhoto(sender:UIButton!) {
        previousCardStyle = currentCardStyle
        currentCardStyle = 2
        requestPhotoPicker()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func shakeCardWithAnimation() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.10
        animation.repeatCount = 2
        animation.autoreverses = true
        animation.fromValue = NSValue(CGPoint: CGPointMake(cardView.center.x - 10, cardView.center.y))
        animation.toValue = NSValue(CGPoint: CGPointMake(cardView.center.x + 10, cardView.center.y))
        cardView.layer.addAnimation(animation, forKey: "position")
    }
    
    func bounceCardWithAnimation() {
        UIView.animateWithDuration(0.1, delay: 0, options: [], animations: { () -> Void in
            self.cardView.transform = CGAffineTransformMakeScale(0.95, 0.95)
            }) { (Bool) -> Void in
                
                UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: [], animations: { () -> Void in
                        self.cardView.transform = CGAffineTransformMakeScale(1, 1)
                    }, completion: { (Bool) -> Void in
                        //
                })
        }
    }
    
    func setSimpleCardStyle() {
        previousCardStyle = currentCardStyle
        currentCardStyle = 0
        
        changeColorButton.hidden = true
        photoContainerView.hidden = true
        changePhotoButton.hidden = true
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.cardView.backgroundColor = UIColor.whiteColor()
            self.bodyTextView.textColor = UIColor(hex: colorDarkGray)
            self.placeholderLabel.textColor = UIColor(hex: colorGray)
            self.nameTextField.textColor = UIColor(hex: colorGray)
            self.addEmojiButton.frame.origin.x = self.cardView.frame.width/2 - 75
            self.gradientView.alpha = 0
            self.dateLabelView.textColor = UIColor(hex: colorGray)
        })
        
        addEmojiButton.setStyleDark()
    }
    
    func setColorCardStyle() {
        previousCardStyle = currentCardStyle
        currentCardStyle = 1
        
        changeColorButton.hidden = false
        photoContainerView.hidden = true
        changePhotoButton.hidden = true


        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.cardView.backgroundColor = UIColor(hex: colorOrange)
            self.bodyTextView.textColor = UIColor.whiteColor()
            self.placeholderLabel.textColor = UIColor(white: 1, alpha: 0.5)
            self.nameTextField.textColor = UIColor.whiteColor()
            self.addEmojiButton.frame.origin.x = 20
            self.gradientView.alpha = 1
            self.dateLabelView.textColor = UIColor(white: 0, alpha: 0.3)
        })
        
        addEmojiButton.setStyleLight()
    }
    
    func setPhotoCardStyle() {
        previousCardStyle = currentCardStyle
        currentCardStyle = 2
        
        changeColorButton.hidden = true
        photoContainerView.hidden = false
        
        if cardHasPhoto == false {
            requestPhotoPicker()
        } else {
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.bodyTextView.textColor = UIColor.whiteColor()
                self.placeholderLabel.textColor = UIColor(white: 1, alpha: 0.5)
                self.nameTextField.textColor = UIColor.whiteColor()
                self.addEmojiButton.frame.origin.x = 20
                self.cardView.backgroundColor = UIColor.clearColor()
                self.gradientView.alpha = 0
                self.changePhotoButton.hidden = false
                self.dateLabelView.textColor = UIColor(white: 1, alpha: 0.5)
            })
        }
        
        //TODO: try for a vibrant here
        addEmojiButton.setStyleLight()
    }
    
    func requestPhotoPicker() {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = false
        vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
            // Get the image captured by the UIImagePickerController
            let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            //let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
            cardView.backgroundColor = UIColor.clearColor()
            beginPhotoEditing(originalImage)
            dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        resetStyleButton(previousCardStyle)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func beginPhotoEditing(image: UIImage) {
        
        //Set this once, to not open camera roll by default
        cardHasPhoto = true
        photoOverlayView.hidden = true
        photoImageView.image = image
        maskedPhotoView.image = image
        maskedPhotoView.hidden = false
        buttonsContainerView.hidden = true
        saveButton.hidden = true
        cardComponentsContainerView.hidden = true
        addEmojiButton.hidden = true
        cardView.backgroundColor = UIColor.clearColor()
        cardView.layer.borderColor = UIColor(white: 1, alpha: 0.5).CGColor
        cardView.layer.borderWidth = 1
        photoNextButton.hidden = false
        gradientView.hidden = true
        changePhotoButton.hidden = true
        
        //Eventually hide change photo button
        
        let pan = UIPanGestureRecognizer(target: self, action: "panPhoto:")
        photoImageView.userInteractionEnabled = true
        photoImageView.addGestureRecognizer(pan)
        
        let pinch = UIPinchGestureRecognizer(target: self, action: "pinchPhoto:")
        pinch.delegate = self
        photoImageView.addGestureRecognizer(pinch)

        let rotate = UIRotationGestureRecognizer(target: self, action: "rotatePhoto:")
        photoImageView.addGestureRecognizer(rotate)
        
        UIView.animateWithDuration(0.3, delay: 0, options: [], animations: { () -> Void in
            self.photoImageView.transform = CGAffineTransformMakeScale(0.97, 0.97)
            }) { (Bool) -> Void in
                
                UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: [], animations: { () -> Void in
                    self.photoImageView.transform = CGAffineTransformMakeScale(1, 1)
                    }, completion: { (Bool) -> Void in
                        //
                })
                
            }
    }
    
    func endPhotoEditing() {
        setPhotoCardStyle()
        photoOverlayView.hidden = false
        maskedPhotoView.hidden = true
        buttonsContainerView.hidden = false
        saveButton.hidden = false
        cardComponentsContainerView.hidden = false
        addEmojiButton.hidden = false
        //cardView.backgroundColor = UIColor.whiteColor()
        cardView.layer.borderWidth = 0
        photoNextButton.hidden = true
        gradientView.hidden = false
        dateLabelView.textColor = UIColor(white: 1, alpha: 0.5)
        changePhotoButton.hidden = false

        UIView.animateWithDuration(0.3, delay: 0, options: [], animations: { () -> Void in
            self.photoImageView.transform = CGAffineTransformScale(self.photoImageView.transform, 0.97, 0.97)
            }) { (Bool) -> Void in
                
                UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: [], animations: { () -> Void in
                    self.photoImageView.transform = CGAffineTransformScale(self.photoImageView.transform,1, 1)
                    }, completion: { (Bool) -> Void in
                        //
                })
                
        }

        for gs in photoImageView.gestureRecognizers! {
            photoImageView.removeGestureRecognizer(gs)
        }
    }
    
    func panPhoto(sender: UIPanGestureRecognizer) {
        
        //let point = sender.locationInView(view)
        //let velocity = sender.velocityInView(view)
        let translation = sender.translationInView(view)
        
        if sender.state == UIGestureRecognizerState.Began {
            photoOriginalCenter = photoImageView.center
            maskedPhotoOriginalCenter = maskedPhotoView.center
            
        } else if sender.state == UIGestureRecognizerState.Changed {
            photoImageView.center = CGPoint(x: photoOriginalCenter.x + translation.x, y: photoOriginalCenter.y + translation.y)
            
            maskedPhotoView.center = CGPoint(x: maskedPhotoOriginalCenter.x + translation.x, y: maskedPhotoOriginalCenter.y + translation.y)
        } else if sender.state == UIGestureRecognizerState.Ended {
            
        }
    }
    
    func pinchPhoto(pinchGestureRecognizer: UIPinchGestureRecognizer) {
        
        let scale = pinchGestureRecognizer.scale
        photoImageView = pinchGestureRecognizer.view as! UIImageView
        photoImageView.transform = CGAffineTransformScale(photoImageView.transform, scale, scale)
          maskedPhotoView.transform = CGAffineTransformScale(maskedPhotoView.transform, scale, scale)
        pinchGestureRecognizer.scale = 1
        
    }

    func rotatePhoto(rotationGestureRecognizer: UIRotationGestureRecognizer) {
        
        rotation = rotationGestureRecognizer.rotation
        photoImageView = rotationGestureRecognizer.view as! UIImageView
        photoImageView.transform = CGAffineTransformRotate(photoImageView.transform, rotation)
        maskedPhotoView.transform = CGAffineTransformRotate(maskedPhotoView.transform, rotation)
        rotationGestureRecognizer.rotation = 0
    }
    
    @IBAction func didTapPhotoNext(sender: AnyObject) {
        endPhotoEditing()
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
        
        //Option: shake
        // shakeCardWithAnimation()
        bounceCardWithAnimation()
    }
    
    @IBAction func didTapSave(sender: AnyObject) {
        
        let body = bodyTextView.text!
        let author = nameTextField.text
        
        //capture the image from the view
        //Hide UI, capture the picture
        
        cardButtonContainer.hidden = true
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(cardView.frame.width, cardView.frame.height), false, 0);
        
        //TODO: Fix the flash coming from afterScreenUpdates
        bodyTextView.resignFirstResponder()
        nameTextField.resignFirstResponder()

        self.cardView.drawViewHierarchyInRect(CGRectMake(0,0,cardView.bounds.size.width,cardView.bounds.size.height), afterScreenUpdates: true)
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext();
        //Image captured, Return UI
        cardButtonContainer.hidden = false

        let imageData = UIImagePNGRepresentation(image)
        let savedImage = PFFile(name:"image.png", data:imageData!)
        var card = Card(objectId: nil, body: body, author: author, image: savedImage)
        
        //Pass the card to ParseService, save, and return
        //TODO: Some error handling here
        
        saveButton.enabled = false
        saveButton.alpha = 0.3
        
        let parseService:ParseService = ParseService()
        parseService.saveCard(card) {
            (result: Card) in
            card = Card(objectId: result.objectId, body: body, author: author, image: savedImage)
            cards.insert(card, atIndex: 0)
            self.tappedImage.image = image
            self.saveButton.enabled = true
            self.saveButton.alpha = 0

            self.objectId = result.objectId
            self.performSegueWithIdentifier("showDetailFromSave", sender: self)
        }
    }
    
    //Hide status bar
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    //Cancel create flow
    @IBAction func didTapCancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    func transitionToHomeView() {
        //returnToHomeView
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        var destinationViewController:UIViewController!
        
        if segue.identifier! == "changeColor" {
            destinationViewController = segue.destinationViewController as! ChangeColorViewController
            destinationViewController.modalPresentationStyle = UIModalPresentationStyle.Custom
            fadeTransition = FadeTransition()
            destinationViewController.transitioningDelegate = fadeTransition
            fadeTransition.duration = 0.3
        }
        
        if segue.identifier! == "addEmoji" {
           destinationViewController = segue.destinationViewController as! AddEmojiViewController
            destinationViewController.modalPresentationStyle = UIModalPresentationStyle.Custom
            fadeTransition = FadeTransition()
            destinationViewController.transitioningDelegate = fadeTransition
            fadeTransition.duration = 0.3
        }
        
        if segue.identifier! == "showDetailFromSave" {
            let destinationViewController = segue.destinationViewController as! DetailViewController
            
            destinationViewController.passedObjectId = objectId
            destinationViewController.modalPresentationStyle = UIModalPresentationStyle.Custom
            saveTransition = SaveTransition()
            destinationViewController.transitioningDelegate = saveTransition
            saveTransition.duration = 0.5
        }
    }
}