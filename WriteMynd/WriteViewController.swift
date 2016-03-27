//
//  WriteViewController.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 19/03/2016.
//  Copyright © 2016 The Leaf. All rights reserved.
//

import UIKit
import SnapKit
import Parse

/**
 - todo: 
    [x] Add Constraints to the emojiContainerView
    [ ] Make the Buttons bouncy ~ https://github.com/StyleShare/SSBouncyButton
 */
class WriteViewController: UIViewController {
    
    var currentTextField: UITextField? //The Current textfield the user is editing
    var post: Post?
    
    lazy var bigEmojiImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "noEmotion")!
        image.contentMode = .ScaleAspectFit
        return image
    }()
    
    lazy var descriptionLabel: Label = {
        let label = Label()
        label.text = "Which emotion best describes you now?"
        label.font = label.font.fontWithSize(17)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .Left
        return label
    }()
    
    lazy var emojisContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var happyEmoji: UIButton = {
        let button = UIButton()
        //button.setImage(UIImage(named: "happy"), forState: .Normal)
        button.setBackgroundImage(UIImage(named: "happy"), forState: .Normal)
        button.imageView?.contentMode = .ScaleAspectFit
        button.tag = 0
        button.addTarget(self, action: .emojiButtonTapped, forControlEvents: .TouchUpInside)
        return button
    }()
    
    lazy var hashTagField: UITextField = { //this has the tag of 5
        let field = UITextField()
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 30))
        field.placeholder = "Create a #hashtag"
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.lightGrayColor().CGColor
        field.font = Label.font()
        field.backgroundColor = UIColor.whiteColor()
        field.leftView = paddingView
        field.leftViewMode = .Always
        field.delegate = self
        field.tag = 5
        return field
    }()
    
    lazy var feelingField: UITextField = {  //this has the tag of 10
        let field = UITextField()
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 30))
        field.placeholder = dailyQuestion[Int( arc4random_uniform(UInt32(dailyQuestion.count)))]
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.lightGrayColor().CGColor
        field.font = Label.font()
        field.backgroundColor = UIColor.whiteColor()
        field.adjustsFontSizeToFitWidth = true
        field.leftView = paddingView
        field.leftViewMode = .Always
        field.delegate = self
        field.tag = 10
        return field
    }()
    
    lazy var postToMeButton: Button = {
        let button = Button()
        button.setTitle("Post to me", forState: .Normal)
        button.backgroundColor = UIColor.wmGreenishTealColor()
        button.tag = 0
        button.addTarget(self, action: #selector(WriteViewController.postButtonTapped(_:)), forControlEvents: .TouchUpInside)
        return button
    }()
    
    lazy var postToAllButton: Button = {
        let button = Button()
        button.setTitle("Post to all", forState: .Normal)
        button.backgroundColor = UIColor.wmCoolBlueColor()
        button.tag = 1
        button.addTarget(self, action: #selector(WriteViewController.postButtonTapped(_:)), forControlEvents: .TouchUpInside)
        return button
    }()
    
    lazy var focusView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        view.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.97)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.wmBackgroundColor()
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "stroke5"))
        
        if self.post == nil {
            self.post = Post(emoji: .None, text: "", hashTags: [], author: PFUser.currentUser()!)
        }
        
        //Add the UI elements 
        self.view.addSubview(bigEmojiImage)
        bigEmojiImage.snp_makeConstraints(closure: { make in
            var topOffset:Float = 35;
            if let navHeight = self.navigationController?.navigationBar.bounds.height{
                topOffset += Float(navHeight);
            }
            make.top.equalTo(self.view.snp_top).offset(topOffset)
            make.centerX.equalTo(self.view.snp_centerX)
        })
        
        self.view.addSubview(descriptionLabel)
        descriptionLabel.snp_makeConstraints(closure: { make in
            make.top.equalTo(bigEmojiImage.snp_bottom).offset(10)
            make.centerX.equalTo(self.view.snp_centerX)
            make.width.lessThanOrEqualTo(self.view.snp_width)
        })
        
        self.view.addSubview(emojisContainerView)
        emojisContainerView.snp_makeConstraints(closure: { make in
            make.top.equalTo(descriptionLabel.snp_bottom).offset(10)
            make.width.equalTo(self.view.snp_width).offset(-20)
            make.centerX.equalTo(self.view.snp_centerX)
            make.height.equalTo(50.0)
        })
        //Add the Happy Emoji
        emojisContainerView.addSubview(happyEmoji)
        happyEmoji.snp_makeConstraints(closure: { make in
            make.width.equalTo(50)
            make.height.equalTo(50)
            make.left.equalTo(emojisContainerView.snp_left)
            make.top.equalTo(emojisContainerView.snp_top)
        })
        
        self.view.addSubview(hashTagField)
        hashTagField.snp_makeConstraints(closure: { make in
            make.top.equalTo(emojisContainerView.snp_bottom).offset(10)
            make.width.equalTo(screenWidth - 20)
            make.centerX.equalTo(self.view.snp_centerX)
            make.height.equalTo(45)
        })
        
        self.view.addSubview(feelingField)
        feelingField.snp_makeConstraints(closure: { make in
            make.top.equalTo( hashTagField.snp_bottom ).offset(10)
            make.size.equalTo( hashTagField )
            make.centerX.equalTo(self.view.snp_centerX)
        })
        
        self.view.addSubview(postToMeButton)
        postToMeButton.snp_makeConstraints(closure: { make in
            make.left.equalTo(self.view.snp_left).offset(10)
            make.top.equalTo(self.feelingField.snp_bottom).offset(11)
            make.width.equalTo(162)
            make.height.equalTo(45)
        })
        
        self.view.addSubview(postToAllButton)
        postToAllButton.snp_makeConstraints(closure: { make in
            make.right.equalTo(self.view.snp_right).offset(-10)
            make.top.equalTo(self.feelingField.snp_bottom).offset(11)
            make.width.equalTo(162)
            make.height.equalTo(45)
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        //Register for the keyboard will show notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(WriteViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil) //UIKeyboardDidShowNotification
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension WriteViewController {
    func displayErrorMessage( message:String ){
        //"You need to enter how you feel, select an emoji and type an hashtag"
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .Alert )
        let okAction = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}

extension WriteViewController {
    
    /**
     The following must be complete before a post can be made
        - An Emoji must be selected
        - HashTag(s) must be present
        - Feelings text must be populated
     */
    func postButtonTapped( sender:Button ){
        guard self.post!.emoji != .None else {
            displayErrorMessage("You need to select an emotion button before posting ");
            return
        }
        guard self.post!.hashTags.count > 0 else{
            displayErrorMessage("You need to add a hashtag before posting");
            return
        }
        //guard !self.post!.text.isEmpty else { displayErrorMessage("No Feeling"); return }
        
        if sender.tag == 0 { //Private post
            self.post!.isPrivate = true
        }else if sender.tag == 1 {
            self.post!.isPrivate = false
        }
        
        self.post!.save()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    /**
    Reciever for touching the emoji images/button
     - todo 
        [ ] Put an emoji struct in a UIButton subclass `Button` and switch on the struct instead
     */
    func emojiButtonTapped( sender: UIButton ){
        switch sender.tag {
        case 0:
            self.descriptionLabel.text = "Happy"
            self.post?.emoji = .Happy
        default:
            break;
        }
    }
    
    /**
     On keyboard show, present the appropriate textfield to capture the data, a faux textfield whose data would be returned to the textfield on `self.view`. It also populates `self.post` with the respective values captured here
     */
    func keyboardWillShow(notification:NSNotification){
        let keyboardFrame:CGRect = notification.userInfo![UIKeyboardFrameEndUserInfoKey]!.CGRectValue
        //print("Keyboard Did appear \(keyboardFrame)")
        
        if let textField = self.currentTextField {
            textField.resignFirstResponder()
            
            if textField.tag == 5 { //HashTag field
                let hashtagView = HashTagView()
                self.focusView.addSubview(hashtagView)
                hashtagView.snp_makeConstraints(closure: { make in
                    make.bottom.equalTo(self.view.snp_top).offset(keyboardFrame.origin.y - 100)
                    make.left.equalTo(self.view.snp_left)//.offset(10)
                    make.width.equalTo(self.view.snp_width)
                    make.centerX.equalTo(self.view.snp_centerX)
                })
                hashtagView.setupConstraints()
                
                hashtagView.hashtagField.becomeFirstResponder()
                hashtagView.hashtagField.text = textField.text
                hashtagView.onFinishCallback = {
                    textField.text = hashtagView.hashtagField.text
                    self.post!.hashTags = textField.text!.componentsSeparatedByString(" ").filter({ (text:String) -> Bool in
                        guard text != "" else { return false }
                        return text[text.startIndex] == "#"
                    })
                    self.focusView.removeFromSuperview()
                }
            }else if textField.tag == 10 { //Feeling field
                let feelingsView = FeelingsView()
                self.focusView.addSubview(feelingsView)
                feelingsView.snp_makeConstraints(closure: { make in
                    make.bottom.equalTo(self.view.snp_bottom).offset(-keyboardFrame.origin.y)
                    make.left.equalTo(self.view.snp_left)
                    make.width.equalTo(self.view.snp_width)
                    make.centerX.equalTo(self.view.snp_centerX)
                })
                feelingsView.setupConstraints()
                feelingsView.feelingsTextView.becomeFirstResponder()
                feelingsView.feelingsTextView.text = textField.text
                feelingsView.onFinishCallback = {
                    textField.text = feelingsView.feelingsTextView.text
                    self.post!.text = textField.text!
                    self.focusView.removeFromSuperview()
                }
            }
        }//end if
    }
    
}

extension WriteViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.currentTextField = textField
        self.view.addSubview(focusView)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

private extension Selector {
    static let emojiButtonTapped = #selector(WriteViewController.emojiButtonTapped(_:))
}