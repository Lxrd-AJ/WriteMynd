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
    
    var questionIndex: Int?
    var swipeView: SwipeView?
    let user: PFUser = PFUser.currentUser()!
        
    override func viewDidLoad() {
        super.viewDidLoad();
        
        segmentedControl.addTarget(self, action: "postSegmentedControlTapped:", forControlEvents: .ValueChanged)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        postTextView.becomeFirstResponder()
        postTextView.placeholder = dailyQuestion[questionIndex!]
        
        //Register for the keyboard will show notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
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
    
    /*
        Selected Segment 0 is the text posting screen
        Selected Segment 1 is the Swiping screen
    */
    func postSegmentedControlTapped( segmentedControl: UISegmentedControl ) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            //do nothing for now
            break;
        case 1:
            //show the swiping card on the screen
            
            //Customise the SwipeView
            self.swipeView = SwipeView.loadFromNibName("SwipeView") as? SwipeView
            swipeView!.frame = CGRect(x: 20, y: 20, width: view.frame.width - 40, height: view.frame.height - 40)
            swipeView!.setupView()
            swipeView!.cancelButton.addTarget(self, action: "cancelSwiping:", forControlEvents: .TouchUpInside)
            swipeView?.becomeFirstResponder()
            
            //Callback functions called by the swipe view
            swipeView?.dismissalCallback = { self.dismissViewControllerAnimated(true, completion: nil) }
            swipeView?.swipeSave = { (swipe:Swipe) -> Void in swipe.save(); }

            //Customise the backgroundView
            self.postTextView.editable = false
            segmentedControl.selectedSegmentIndex = 0
            self.view.addSubview(swipeView!)
            break;
        default:
            break;
        }
    }
    
    func cancelSwiping( button:UIButton ){
        swipeView?.removeFromSuperview()
        self.postTextView.editable = true
        self.postTextView.becomeFirstResponder()
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
