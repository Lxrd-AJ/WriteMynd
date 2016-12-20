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
import SZTextView

/**
 - todo: 
    [x] Add Constraints to the emojiContainerView
    [ ] Make the Buttons bouncy ~ https://github.com/StyleShare/SSBouncyButton
 */
class WriteViewController: UIViewController {
    
    var currentTextField: UITextField? //The Current textfield the user is editing
    var post: Post? //TODO: Add a setter function here
    var previousEmojiButton: UIButton?
    var backbuttonItem: UIBarButtonItem?
    
    let question = dailyQuestion[Int( arc4random_uniform(UInt32(dailyQuestion.count)))]
    let feelingsView = FeelingsView()
    let hashtagView = HashTagView()
    fileprivate let BUTTON_TICK_TAG = 100
    
    lazy var bigEmojiImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "noEmotion")!
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    lazy var descriptionLabel: Label = {
        let label = Label()
        label.text = "Which emotion best describes you now?"
        label.font = label.font.withSize(17)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.numberOfLines = 1
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    lazy var emojiStackView: UIStackView = {
        let stack: UIStackView = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        return stack;
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
        field.placeholder = "Categorise your post"
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.font = Label.font()
        field.backgroundColor = UIColor.white
        field.textColor = UIColor.lightGray
        field.leftView = paddingView
        field.leftViewMode = .always
        field.delegate = self
        field.tag = 5
        return field
    }()
    
    lazy var feelingsTextView: SZTextView = {
        let textView = SZTextView()
        textView.textContainerInset = UIEdgeInsetsMake(5, 10, 0, 10)
        textView.font = Label.font()
        //textView.placeholder = self.question
        textView.placeholder = "What's on your mind?"
        textView.textColor = UIColor.lightGray
        textView.delegate = self
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.lightGray.cgColor
        return textView
    }()
    
    lazy var postToMeButton: Button = {
        let button = Button()
        button.setTitle("Post to me", for: UIControlState())
        button.backgroundColor = UIColor.wmGreenishTealColor()
        button.tag = 0
        button.addTarget(self, action: #selector(WriteViewController.postButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var postToAllButton: Button = {
        let button = Button()
        button.setTitle("Post to all", for: UIControlState())
        button.backgroundColor = UIColor.wmCoolBlueColor()
        button.tag = 1
        button.addTarget(self, action: #selector(WriteViewController.postButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var focusView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        view.backgroundColor = UIColor.white.withAlphaComponent(0.97)
        //view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: .finishedEditingTextView))
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.wmBackgroundColor()
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "stroke5"))
        self.backbuttonItem = self.navigationItem.backBarButtonItem
        
        if self.post == nil {
            self.post = Post(emoji: .none, text: "", hashTags: [], author: PFUser.current()!)
        }else{
            populateViewWithPost(self.post!)
        }
        
        //Add the UI elements 
        self.view.addSubview(bigEmojiImage)
        self.view.addSubview(descriptionLabel)
        self.view.addSubview(emojiStackView)
        
        emojiStackView.addArrangedSubview(happyEmoji)
        emojiStackView.addArrangedSubview(sadEmoji)
        emojiStackView.addArrangedSubview(angryEmoji)
        emojiStackView.addArrangedSubview(fearEmoji)
        emojiStackView.addArrangedSubview(mehEmoji)
        
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
        
        bigEmojiImage.snp.makeConstraints({ make in
            make.top.equalTo(self.topLayoutGuide.snp.bottom).offset(9)
            make.centerX.equalTo(self.view.snp.centerX)
            make.size.equalTo(CGSize(width: 145, height: 160))
        })
        
        descriptionLabel.snp.makeConstraints({ make in
            make.top.equalTo(bigEmojiImage.snp.bottom).offset(9)
            make.centerX.equalTo(self.view.snp.centerX)
            make.width.lessThanOrEqualTo(self.view.snp.width)
        })
        
        emojiStackView.snp.makeConstraints({ make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            make.width.equalTo(self.view.snp.width).offset(-10)
            make.centerX.equalTo(self.view.snp.centerX)
            make.height.equalTo(50.0)
        })
        
        hashTagField.snp.makeConstraints({ make in
            make.top.equalTo(emojiStackView.snp.bottom).offset(10)
            make.width.equalTo(screenWidth - 20)
            make.centerX.equalTo(self.view.snp.centerX)
            make.height.equalTo(45)
        })
        
        feelingsTextView.snp.makeConstraints({ make in
            make.top.equalTo( hashTagField.snp.bottom ).offset(10)
            //make.size.equalTo( CGSize(width: 335, height: 85 ))
            make.width.equalTo(hashTagField.snp.width)
            make.height.equalTo(85)
            make.centerX.equalTo(self.view.snp.centerX)
        })
        
        postToMeButton.snp.makeConstraints({ make in
            make.left.equalTo(self.view.snp.left).offset(10)
            make.top.equalTo(self.feelingsTextView.snp.bottom).offset(11)
            //make.right.equalTo(postToAllButton.snp.left).offset(-10)
            make.width.equalTo(self.postToAllButton.snp.width)
            make.height.equalTo(45)
        })
        
        postToAllButton.snp.makeConstraints({ make in
            make.right.equalTo(self.view.snp.right).offset(-10)
            make.top.equalTo(self.feelingsTextView.snp.bottom).offset(11)
            make.width.equalTo(self.view.snp.width).multipliedBy(0.45)
            make.height.equalTo(45)
        })

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Analytics.timeUserEntered(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.post!.hashTags.count > 0 {
            Analytics.timeUserExit(self, properties:["POSTED":true])
        }else{
            Analytics.timeUserExit(self, properties:["POSTED":false])
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension WriteViewController {
    
    func createEmojiButton( _ imageName: String, tag:Int ) -> UIButton {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: imageName), for: UIControlState())
        button.imageView?.contentMode = .center//.ScaleAspectFit
        button.tag = tag
        button.addTarget(self, action: .emojiButtonTapped, for: .touchUpInside)
        return button
    }
    
    func populateViewWithPost( _ post:Post ){
        self.feelingsTextView.text = post.text
        self.hashTagField.text = post.hashTags.reduce("", { hashtags, tag in
            return "\(hashtags!)\(tag)"
        })
        self.descriptionLabel.text = post.emoji.value().name
    }
    
    func displayErrorMessage( _ message:String ){
        //"You need to enter how you feel, select an emoji and type an hashtag"
        let alertController = UIAlertController(title: "Oops", message: message, preferredStyle: .alert )
        let okAction = UIAlertAction(title: "Gotcha", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func createRightBarButtonItem() -> UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .done, target: self, action: .finishedEditing)
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
    func postButtonTapped( _ sender:Button ){
        guard self.post!.emoji != .none else {
            displayErrorMessage("You need to select an emotion before posting");
            return
        }
        guard self.post!.hashTags.count > 0 else{
            displayErrorMessage("You need to categorise your post before posting");
            return
        }
        
        //Add the written post notification view
        let notificationView = WrittenPostNotificationView()
        notificationView.backgroundColor = UIColor.white.withAlphaComponent(0.0)
        self.view.addSubview(notificationView)
        notificationView.snp.makeConstraints({ make in
            make.size.equalTo(self.view.snp.size)
        })
        
        if sender.tag == 0 { //Private post
            self.post!.isPrivate = true
            notificationView.message.text = "Posting to MyMynd"
        }else if sender.tag == 1 {
            self.post!.isPrivate = false
            notificationView.message.text = "Sharing your post..."
        }
        
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseIn,.curveEaseOut], animations: {
                notificationView.backgroundColor = UIColor.white.withAlphaComponent(0.9)
            }, completion: { bool in
                self.post!.save()
                //TRACK
                Analytics.trackUserMade(self.post!)
                //END TRACK
                delay(2, closure: {
                    notificationView.removeFromSuperview()
                    let _ = self.navigationController?.popViewController(animated: true)
                })
        })
    }
    
    /**
    Reciever for touching the emoji images/button
     - todo 
        [ ] Put an emoji struct in a UIButton subclass `Button` and switch on the struct instead 
        [ ] Also add the emoji selectors to this subclass
     */
    func emojiButtonTapped( _ sender: UIButton ){
        
        func addTickMark( _ button:UIButton ){
            let imageView = UIImageView(image: UIImage(named: "tickGreen"))
            imageView.backgroundColor = UIColor.white.withAlphaComponent(0.65)
            imageView.layer.cornerRadius = sender.frame.width / 2
            imageView.contentMode = .center
            imageView.tag = BUTTON_TICK_TAG;
            //sender.layer.masksToBounds = true
            button.addSubview(imageView)
            imageView.snp.makeConstraints({ make in
                make.size.equalTo(button.snp.size)
                make.center.equalTo(button.snp.center)
            })
        }
        
        func removeTickMark( _ button: UIButton? ){
            let imgView = button?.viewWithTag(BUTTON_TICK_TAG)
            imgView?.removeFromSuperview()
        }
        
        var descriptionText = ""
        var imageName = ""
        
        switch sender.tag {
        case 0:
            descriptionText = "Happy"
            self.post?.emoji = .happy
            imageName = "happyManStood"
        case 1:
            descriptionText = "Sad"
            self.post?.emoji = .sad
            imageName = "sadManStood"
        case 2:
            descriptionText = "Angry"
            self.post?.emoji = .angry
            imageName = "angryManStood"
        case 3:
            descriptionText = "Scared"
            self.post?.emoji = .scared
            imageName = "fearManStood"
        case 4:
            descriptionText = "Meh"
            self.post?.emoji = .meh
            imageName = "mehManStood"
        default:
            break;
        }
        
        UIView.transition(with: self.bigEmojiImage, duration: 0.2, options: .transitionCrossDissolve, animations: { //.TransitionFlipFromRight
            self.bigEmojiImage.image = UIImage(named: imageName)
            }, completion: nil)
        
        UIView.transition(with: self.descriptionLabel, duration: 0.3, options: .transitionFlipFromLeft, animations: {
            self.descriptionLabel.text = descriptionText
            }, completion: nil)
        
        //Animate the emoji Buttons
        if previousEmojiButton?.tag != sender.tag { //A different emoji was tapped
            removeTickMark(previousEmojiButton)
            addTickMark(sender)
            previousEmojiButton = sender; previousEmojiButton?.tag = sender.tag;
        }
    }
    
    /**
     On keyboard show, present the appropriate textfield to capture the data, a faux textfield whose data would be returned to the textfield on `self.view`. It also populates `self.post` with the respective values captured here
     */
    func beginEditingWithFocusView(){
        if !self.focusView.isDescendant(of: self.view){
            self.view.addSubview(self.focusView)
        }
        
        //Editing HashTags
        self.focusView.addSubview(hashtagView)
        hashtagView.snp.makeConstraints({ make in
            make.top.equalTo(self.view.snp.top).offset(200)
            make.left.equalTo(self.view.snp.left)//.offset(10)
            make.width.equalTo(self.view.snp.width)
            make.centerX.equalTo(self.view.snp.centerX)
        })
        hashtagView.setupConstraints()
        
        hashtagView.hashtagField.becomeFirstResponder()
        if self.hashTagField.text == "" {
            hashtagView.hashtagField.text = "#"
        }else{
            hashtagView.hashtagField.text = self.hashTagField.text
        }
        hashtagView.onFinishCallback = hashtagViewCallback
    }
    
    fileprivate func hashtagViewCallback(){
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.setHidesBackButton(false, animated: true)
        self.hashTagField.text = self.hashtagView.hashtagField.text
        self.post!.hashTags = self.hashTagField.text!.components(separatedBy: " ").filter({ (text:String) -> Bool in
            guard text != "" else { return false }
            return text[text.startIndex] == "#"
        })
        self.focusView.removeFromSuperview()
    }
    
    func endEditingWithFocusView(_ sender: UIBarButtonItem) -> Void {
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.setHidesBackButton(false, animated: true)
        hashtagViewCallback()
    }
    
}
//thingstobegrafefulfor
extension WriteViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.beginEditingWithFocusView()
        self.navigationItem.rightBarButtonItem = self.createRightBarButtonItem()
        self.navigationItem.setHidesBackButton(true, animated: true)
        return false;
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension WriteViewController: UITextViewDelegate {
    /**
     Delegate
     
     - parameter textView: The current dummy textview
     - returns: false always
     - todo: Consider pushing a view controller [x]
     */
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        let postController = TextViewController()
        //postController.textView.placeholder = question
        postController.textView.placeholder = self.feelingsTextView.placeholder
        postController.textView.text = self.feelingsTextView.text
        postController.onFinishCallback = {
            self.feelingsTextView.text = postController.textView.text
            self.post!.text = self.feelingsTextView.text!
        }
        self.navigationController?.pushViewController(postController, animated: true)
        return false
    }
}

private extension Selector {
    static let emojiButtonTapped = #selector(WriteViewController.emojiButtonTapped(_:))
    static let finishedEditing = #selector(WriteViewController.endEditingWithFocusView(_:))
}
