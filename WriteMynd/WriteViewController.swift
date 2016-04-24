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
    var editingHashTags: Bool = true
    let question = dailyQuestion[Int( arc4random_uniform(UInt32(dailyQuestion.count)))]
    
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
        return self.createEmojiButton( "happy", tag:0 )
    }()
    lazy var sadEmoji : UIButton = {
        return self.createEmojiButton( "sad", tag:1 )
    }()
    lazy var angryEmoji: UIButton = {
        return self.createEmojiButton( "angry", tag:2 )
    }()
    lazy var fearEmoji: UIButton = {
        return self.createEmojiButton( "fear", tag:3 )
    }()
    lazy var mehEmoji: UIButton = {
        return self.createEmojiButton( "meh", tag:4 )
    }()
    
    lazy var hashTagField: UITextField = { //this has the tag of 5
        let field = UITextField()
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 30))
        field.placeholder = "Create a #hashtag"
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.lightGrayColor().CGColor
        field.font = Label.font()
        field.backgroundColor = UIColor.whiteColor()
        field.textColor = UIColor.lightGrayColor()
        field.leftView = paddingView
        field.leftViewMode = .Always
        field.delegate = self
        field.tag = 5
        return field
    }()
    
    lazy var feelingsTextView: UITextView = {
        let textView = UITextView()
        textView.textContainerInset = UIEdgeInsetsMake(5, 10, 0, 10)
        textView.font = Label.font()
        textView.text = self.question
        //textView.tintColor = UIColor.blueColor()
        textView.textColor = UIColor.lightGrayColor()
        textView.delegate = self
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.lightGrayColor().CGColor
        return textView
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
        }else{
            populateViewWithPost(self.post!)
        }
        
        //Add the UI elements 
        self.view.addSubview(bigEmojiImage)
        self.view.addSubview(descriptionLabel)
        self.view.addSubview(emojisContainerView)
        

        emojisContainerView.addSubview(happyEmoji)
        emojisContainerView.addSubview(sadEmoji)
        emojisContainerView.addSubview(angryEmoji)
        emojisContainerView.addSubview(fearEmoji)
        emojisContainerView.addSubview(mehEmoji)
        
        self.view.addSubview(hashTagField)
        self.view.addSubview(feelingsTextView)
        self.view.addSubview(postToMeButton)
        self.view.addSubview(postToAllButton)
        
    }
    
    /** 
     - todo:
        [ ] Use StackViews to help layout elems
     */
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        bigEmojiImage.snp_makeConstraints(closure: { make in
            make.top.equalTo(self.snp_topLayoutGuideBottom).offset(10)
            make.centerX.equalTo(self.view.snp_centerX)
            make.size.equalTo(CGSize(width: 150, height: 167))
        })
        
        descriptionLabel.snp_makeConstraints(closure: { make in
            make.top.equalTo(bigEmojiImage.snp_bottom).offset(10)
            make.centerX.equalTo(self.view.snp_centerX)
            make.width.lessThanOrEqualTo(self.view.snp_width)
        })
        
        emojisContainerView.snp_makeConstraints(closure: { make in
            make.top.equalTo(descriptionLabel.snp_bottom).offset(10)
            make.width.equalTo(self.view.snp_width)
            make.centerX.equalTo(self.view.snp_centerX)
            make.height.equalTo(50.0)
        })
        
        happyEmoji.snp_makeConstraints(closure: { make in
            make.width.equalTo(50)
            make.height.equalTo(50)
            make.left.equalTo(emojisContainerView.snp_left).offset(20)
            make.top.equalTo(emojisContainerView.snp_top)
        })
        
        sadEmoji.snp_makeConstraints(closure: {make in
            make.size.equalTo(happyEmoji.snp_size)
            make.top.equalTo(happyEmoji.snp_top)
            make.left.equalTo(happyEmoji.snp_right).offset(20)
        })
        
        angryEmoji.snp_makeConstraints(closure: { make in
            make.size.equalTo(sadEmoji.snp_size)
            make.top.equalTo(sadEmoji.snp_top)
            make.left.equalTo(sadEmoji.snp_right).offset(20)
        })
        
        fearEmoji.snp_makeConstraints(closure: { make in
            make.size.equalTo(angryEmoji.snp_size)
            make.top.equalTo(angryEmoji.snp_top)
            make.left.equalTo(angryEmoji.snp_right).offset(20)
        })
        
        mehEmoji.snp_makeConstraints(closure: { make in
            make.size.equalTo(fearEmoji.snp_size)
            make.top.equalTo(fearEmoji.snp_top)
            make.left.equalTo(fearEmoji.snp_right).offset(20)
        })
        
        hashTagField.snp_makeConstraints(closure: { make in
            make.top.equalTo(emojisContainerView.snp_bottom).offset(10)
            make.width.equalTo(screenWidth - 20)
            make.centerX.equalTo(self.view.snp_centerX)
            make.height.equalTo(45)
        })
        
        feelingsTextView.snp_makeConstraints(closure: { make in
            make.top.equalTo( hashTagField.snp_bottom ).offset(10)
            //make.size.equalTo( CGSize(width: 335, height: 85 ))
            make.width.equalTo(hashTagField.snp_width)
            make.height.equalTo(85)
            make.centerX.equalTo(self.view.snp_centerX)
        })
        
        postToMeButton.snp_makeConstraints(closure: { make in
            make.left.equalTo(self.view.snp_left).offset(10)
            make.top.equalTo(self.feelingsTextView.snp_bottom).offset(11)
            make.width.equalTo(162)
            make.height.equalTo(45)
        })
        
        postToAllButton.snp_makeConstraints(closure: { make in
            make.right.equalTo(self.view.snp_right).offset(-10)
            make.top.equalTo(self.feelingsTextView.snp_bottom).offset(11)
            make.width.equalTo(162)
            make.height.equalTo(45)
        })

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //Register for the keyboard will show notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(WriteViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil) //UIKeyboardDidShowNotification
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
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
    
    func createEmojiButton( imageName: String, tag:Int ) -> UIButton {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: imageName), forState: .Normal)
        button.imageView?.contentMode = .ScaleAspectFit
        button.tag = tag
        button.addTarget(self, action: .emojiButtonTapped, forControlEvents: .TouchUpInside)
        return button
    }
    
    
    
    func populateViewWithPost( post:Post ){
        self.feelingsTextView.text = post.text
        self.hashTagField.text = post.hashTags.reduce("", combine: { hashtags, tag in
            return "\(hashtags!)\(tag)"
        })
        self.descriptionLabel.text = post.emoji.value().name    }
    
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
     Here a post is saved if it conforms to our requirements
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
        
        //Add the written post notification view
        let notificationView = WrittenPostNotificationView()
        notificationView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.0)
        self.view.addSubview(notificationView)
        notificationView.snp_makeConstraints(closure: { make in
            make.size.equalTo(self.view.snp_size)
        })
        
        if sender.tag == 0 { //Private post
            self.post!.isPrivate = true
            notificationView.message.text = "Posting to MyMynd"
        }else if sender.tag == 1 {
            self.post!.isPrivate = false
            notificationView.message.text = "Posting to everyone"
        }
        
        UIView.animateWithDuration(0.1, delay: 0, options: [.CurveEaseIn,.CurveEaseOut], animations: {
                notificationView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.9)
            }, completion: { bool in
                self.post!.save()
                //TRACK
                MixpanelService.track("USER_MADE_POST", properties: [
                        "Feeling": self.post!.emoji.value().name,
                        "private_post": self.post!.isPrivate
                    ])
                //END TRACK
                delay(3, closure: {
                    notificationView.removeFromSuperview()
                    self.navigationController?.popViewControllerAnimated(true)
                })
        })
    }
    
    /**
    Reciever for touching the emoji images/button
     - todo 
        [ ] Put an emoji struct in a UIButton subclass `Button` and switch on the struct instead 
        [ ] Also add the emoji selectors to this subclass
     */
    func emojiButtonTapped( sender: UIButton ){
        switch sender.tag {
        case 0:
            self.descriptionLabel.text = "Happy"
            self.post?.emoji = .Happy
            self.bigEmojiImage.image = UIImage(named: "happyManStood")
        case 1:
            self.descriptionLabel.text = "Sad"
            self.post?.emoji = .Sad
            self.bigEmojiImage.image = UIImage(named: "sadManStood")
        case 2:
            self.descriptionLabel.text = "Angry"
            self.post?.emoji = .Angry
            self.bigEmojiImage.image = UIImage(named: "angryManStood")
        case 3:
            self.descriptionLabel.text = "Fear"
            self.post?.emoji = .Scared
            self.bigEmojiImage.image = UIImage(named: "fearManStood")
        case 4:
            self.descriptionLabel.text = "Meh"
            self.post?.emoji = .Meh
            self.bigEmojiImage.image = UIImage(named: "mehManStood")
        default:
            break;
        }
    }
    
    /**
     On keyboard show, present the appropriate textfield to capture the data, a faux textfield whose data would be returned to the textfield on `self.view`. It also populates `self.post` with the respective values captured here
     */
    func keyboardWillShow(notification:NSNotification){
        let keyboardFrame:CGRect = notification.userInfo![UIKeyboardFrameEndUserInfoKey]!.CGRectValue
        self.view.addSubview(self.focusView)
        print("Keyboard Did appear \(keyboardFrame)")
        
        if self.editingHashTags { //HashTag field
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
            hashtagView.hashtagField.text = self.hashTagField.text
            hashtagView.onFinishCallback = {
                self.hashTagField.text = hashtagView.hashtagField.text
                self.post!.hashTags = self.hashTagField.text!.componentsSeparatedByString(" ").filter({ (text:String) -> Bool in
                    guard text != "" else { return false }
                    return text[text.startIndex] == "#"
                })
                self.focusView.removeFromSuperview()
            }
        }else{ //Feeling field
            let feelingsView = FeelingsView()
            self.focusView.addSubview(feelingsView)
            //BUG: The cursor isn't showing on `feelingsView.feelingsTextView`, an option is to reuse `feelingsTextView` and just remake its constraints
            feelingsView.snp_makeConstraints(closure: { make in
                make.bottom.equalTo(self.view.snp_bottom).offset(-keyboardFrame.origin.y)
                make.left.equalTo(self.view.snp_left)
                make.width.equalTo(self.view.snp_width)
                make.centerX.equalTo(self.view.snp_centerX)
            })
            feelingsView.setupConstraints()
            feelingsView.feelingsTextView.becomeFirstResponder()
            feelingsView.feelingsTextView.text = self.feelingsTextView.text
            feelingsView.onFinishCallback = {
                self.feelingsTextView.text = feelingsView.feelingsTextView.text
                self.feelingsTextView.resignFirstResponder()
                self.post!.text = self.feelingsTextView.text!
                self.focusView.removeFromSuperview()
            }
        }

    }
    
}
//thingstobegrafefulfor
extension WriteViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.editingHashTags = true
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        //self.view.addSubview(focusView)
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension WriteViewController: UITextViewDelegate {
    /**
     - todo:
        [ ] Consider using a placeholder for the textview
     */
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        self.editingHashTags = false
        self.feelingsTextView.text = ""
        return true
    }
}

private extension Selector {
    static let emojiButtonTapped = #selector(WriteViewController.emojiButtonTapped(_:))
}