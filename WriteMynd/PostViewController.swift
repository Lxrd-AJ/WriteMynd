//
//  PostViewController.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 04/12/2015.
//  Copyright © 2015 The Leaf. All rights reserved.
//

import UIKit
import SZTextView

class PostViewController: UIViewController {

    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var timer: UIBarButtonItem!
    @IBOutlet weak var canvasView: UIView!
    @IBOutlet weak var postToMe: UIButton!
    @IBOutlet weak var postToNetwork: UIButton!
    @IBOutlet weak var postTextView: SZTextView!
    @IBOutlet weak var selectedEmojiLabel: UILabel!
    
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
        }else{
            print("No POst Data")
        }
    }
    
    func getPostData() -> Post?{
        guard postTextView.text != "" && selectedEmojiLabel.text != "" else { return nil }
        //Parse the HashTags from the String
        let postText: [String] = postTextView.text!.componentsSeparatedByString(" ")
        let hashTags:[String] = postText.filter({ (text:String) -> Bool in return text[text.startIndex] == "#" })
        return Post(emoji: selectedEmojiLabel.text!, text: postTextView.text!, hashTags: hashTags)
    }
    
}
