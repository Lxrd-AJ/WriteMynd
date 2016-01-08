//
//  PostViewController.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 04/12/2015.
//  Copyright © 2015 The Leaf. All rights reserved.
//

import UIKit
import SZTextView
import Parse

class PostViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var timer: UIBarButtonItem!
    @IBOutlet weak var canvasView: UIView!
    @IBOutlet weak var postToMe: UIButton!
    @IBOutlet weak var postToNetwork: UIButton!
    @IBOutlet weak var postTextView: SZTextView!
    @IBOutlet weak var selectedEmojiLabel: UILabel!
    
    let user: PFUser = PFUser.currentUser()!
    let dailyQuestion: [String] = [
        "What's going on?",
        "What mood are you in?",
        "How is your health?",
        "What’s the last new thing you tried?",
        "What’s your biggest hope?",
        "What’s the last book you read?",
        "How many photos did you take today?",
        "What do you look for in art?",
        "What did you buy today?",
        "Who do you wish you didn’t have to deal with?",
        "What do you feel secure in knowing?",
        "What has challenged your morals?",
        "What time did you go to bed last night?",
        "What’s the last thing that you wanted but didn’t get?",
        "What stresses you?",
        "What’s your super-power?",
        "What’s the last thing you apologised for?",
        "What’s annoying you?",
        "What would have made today perfect?",
        "What would you do if you had more time?",
        "What’s your favourite gadget?",
        "When is the last time you intentionally ‘wasted’ time?",
        "Does anyone owe you money?",
        "What would make your life easier?",
        "What is the last thing you felt guilty about?",
        "What decision do you wish you didn’t have to make?",
        "What are you questioning?",
        "What was the most recent thing you learned?",
        "Where would you like to go?",
        "What was your last doctor’s appointment about?",
        "What three things should you have done today?",
        "What pressure did you feel today?",
        "How old do you feel?",
        "What was the last gift you received?",
        "How did you spend your free time today?",
        "Have you been a good listener recently?",
        "What’s happened recently to make your week worthwhile?",
        "If you could change today, would you?",
        "What would you have skipped today?",
        "Were you in control of your day?",
        "What do you wish for?",
        "What recent memory do you want to keep?",
        "What makes you sweat?",
        "Did you nurture any relationships today?",
        "What are you passionate about?",
        "Who do you wish had been part of your day?",
        "Are you a positive or negative person today?",
        "What’s one thing you’ve heard recently that you don’t want to forget?",
        "What words are you using too much lately?",
        "How are you expanding your mind?",
        "What was weird about the last few days?",
        "Are you holding any grudges?",
        "How was your day today?",
        "How much of your day do you spend alone?",
        "What’s the first thing you saw when you woke up this morning?",
        "What are three things that you’ll do tomorrow?",
        "What’s the last thing you did online?",
        "Who is the strongest person you know?",
        "What did you control today?",
        "What was your weakness today?",
        "How much did you eat today?",
        "What’s worth fighting for?"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad();
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        postTextView.becomeFirstResponder()
        //Register for the keyboard will show notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidChangeFrameNotification, object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //postTextView.becomeFirstResponder()
        customiseUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func customiseUI(){
        //Draw the right border
        UIView.animateWithDuration(0.01, animations: {
            let rightBorder:UIView = UIView(frame: CGRect(x: self.postToMe.frame.size.width - 1, y: 5, width: 1, height: self.postToMe.frame.size.height-10))
            rightBorder.backgroundColor = UIColor.grayColor()
            self.postToMe.addSubview(rightBorder)
        })
    }
    
    func keyboardDidShow( notification:NSNotification ){
        let keyboardFrame:CGRect = notification.userInfo![UIKeyboardFrameEndUserInfoKey]!.CGRectValue
        displayEmojiView(keyboardFrame)
    }
    
    func displayEmojiView( keyboardFrame:CGRect ){
        let emojiView:EmojiView = EmojiView.loadFromNibName("EmojiView") as! EmojiView
        let emojiHeight:CGFloat = 100.0
        emojiView.frame = CGRect(x: 0, y: keyboardFrame.origin.y - (emojiHeight+10), width: emojiView.frame.width, height: emojiHeight)
        self.canvasView.addSubview(emojiView)
        _ = emojiView.subviews.map({ (emoji:UIView) -> Void in
            if let emojiButton = emoji as? UIButton {
                emojiButton.addTarget(self, action: "emojiTouched:", forControlEvents: .TouchUpInside)
            }
        })
    }
    
    func emojiTouched( emojiButton:UIButton ){
        let emoji:String = (emojiButton.titleLabel?.text!)!
        selectedEmojiLabel.text = emoji
    }

    @IBAction func postToMeTouched(sender: AnyObject) {
        if let post = getPostData() {
            post.isPrivate = true
            post.save()
            //self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        else{ displayErrorMessage() }
    }
    
    @IBAction func postToNetworkTouched(sender: UIButton) {
        if let post = getPostData() {
            post.isPrivate = false
            post.save()
            //self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        else{ displayErrorMessage() }
    }
    
    func displayErrorMessage(){
        let alertController = UIAlertController(title: "Lol", message: "You need to enter how you feel and select an emoji", preferredStyle: .Alert )
        let okAction = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func getPostData() -> Post?{
        guard postTextView.text != "" && selectedEmojiLabel.text != "" else { return nil }
        //Parse the HashTags from the String
        let postText: [String] = postTextView.text!.componentsSeparatedByString(" ")
        let hashTags:[String] = postText.filter({ (text:String) -> Bool in
            guard text != "" else { return false }
            return text[text.startIndex] == "#"
        })
        return Post(emoji: selectedEmojiLabel.text!, text: postTextView.text!, hashTags: hashTags, author: user)
    }
    
}
