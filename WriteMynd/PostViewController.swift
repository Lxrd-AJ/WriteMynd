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

/**
 Lets the user post with tho different methods
    * By typing how they feel and selecting an emoji
    * By Swiping on words
 - todo:
    [ ] Move the Emoji Related code to a child view controller just like SwipeVC
 */
class PostViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var timer: UIBarButtonItem!
    @IBOutlet weak var canvasView: UIView!
    @IBOutlet weak var postToMe: UIButton!
    @IBOutlet weak var postToNetwork: UIButton!
    @IBOutlet weak var postTextView: SZTextView!
    @IBOutlet weak var selectedEmojiLabel: UILabel!
    let questionIndex: Int = Int( arc4random_uniform(UInt32(dailyQuestion.count)) )
    let user: PFUser = PFUser.currentUser()!
    var swipeVC: SwipeViewController = SwipeViewController()
    var selectedSegmentIndex:Int = 0
        
    override func viewDidLoad() {
        super.viewDidLoad();
        
        segmentedControl.addTarget(self, action: "postSegmentedControlTapped:", forControlEvents: .ValueChanged)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        postTextView.becomeFirstResponder()
        postTextView.placeholder = dailyQuestion[questionIndex]
        
        //Register for the keyboard will show notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //postTextView.becomeFirstResponder()
        customiseUI()
        switch self.selectedSegmentIndex {
        case 1: //Swiping Index selected
            self.showSwipingScene()
        default:
            break
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    /*
        Allows the user choose between text posting or swiping
            * Selected Segment 0 is the text posting screen
            * Selected Segment 1 is the Swiping screen
    */
    func postSegmentedControlTapped( segmentedControl: UISegmentedControl ) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            self.postTextView.becomeFirstResponder()
            break;
        case 1:
            showSwipingScene()
            break;
        default:
            break;
        }
    }
    
    func showSwipingScene(){
        self.postTextView.resignFirstResponder()
        self.addChildViewController(swipeVC)
        swipeVC.view.frame = self.view.bounds
        swipeVC.view.backgroundColor = UIColor.brownColor()
        swipeVC.delegate = self
        self.view.addSubview(swipeVC.view)
        swipeVC.didMoveToParentViewController(self)
        
        segmentedControl.selectedSegmentIndex = 0
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

    /**
     - todo: 
        [ ] Refactor postToMe and postToNetwork
     */
    @IBAction func postToMeTouched(sender: AnyObject) {
        if let post = getPostData() where post.hashTags.count > 0{
            post.isPrivate = true
            post.save()
            //self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        else{ displayErrorMessage() }
    }
    
    @IBAction func postToNetworkTouched(sender: UIButton) {
        if let post = getPostData() where post.hashTags.count > 0 {
            post.isPrivate = false
            post.save()
            print(post.hashTags)
            //self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
            self.dismissViewControllerAnimated(true, completion: nil)
        }else{ displayErrorMessage() }
    }
    
    func displayErrorMessage(){
        let alertController = UIAlertController(title: "Lol", message: "You need to enter how you feel, select an emoji and type an hashtag", preferredStyle: .Alert )
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

extension PostViewController: SwipeViewControllerDelegate {
    func removeMe(){
        //Remove the Swipe View Controller
        self.swipeVC.willMoveToParentViewController(nil)
        self.swipeVC.view.removeFromSuperview()
        self.swipeVC.removeFromParentViewController()
        self.postTextView.becomeFirstResponder()
    }
}
