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
import MDCSwipeToChoose
import Koloda

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
    
    var questionIndex: Int?
    //var swipeView: SwipeView?
    var swipeVC: TestSwipeViewController = TestSwipeViewController()
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
        Allows the user choose between text posting or swiping
            * Selected Segment 0 is the text posting screen
            * Selected Segment 1 is the Swiping screen
    */
    func postSegmentedControlTapped( segmentedControl: UISegmentedControl ) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            //do nothing for now
            //Remove the Test Swipe View Controller
            self.swipeVC.willMoveToParentViewController(nil)
            self.swipeVC.view.removeFromSuperview()
            self.swipeVC.removeFromParentViewController()
            print(self.swipeVC.view)
            break;
        case 1:
            //show the swiping card on the screen
            //MARK - DEPRECATED
            //Customise the SwipeView
            //self.swipeView = SwipeView.loadFromNibName("SwipeView") as? SwipeView
//            swipeView!.frame = CGRect(x: 20, y: 20, width: view.frame.width - 40, height: view.frame.height - 40)
//            swipeView!.setupView()
//            swipeView!.cancelButton.addTarget(self, action: "cancelSwiping:", forControlEvents: .TouchUpInside)
//            swipeView?.becomeFirstResponder()
//            
//            //Callback functions called by the swipe view
//            swipeView?.dismissalCallback = { self.dismissViewControllerAnimated(true, completion: nil) }
//            swipeView?.swipeSave = { (swipe:Swipe) -> Void in swipe.save(); }
//
//            //Customise the backgroundView
//            self.postTextView.editable = false
//            segmentedControl.selectedSegmentIndex = 0
//            self.view.addSubview(swipeView!)
            
            //Customise Options for MDCSwipeToChoose
//            let options = MDCSwipeToChooseViewOptions()
//            options.delegate = self
//            segmentedControl.selectedSegmentIndex = 0
//            options.onPan = { (state:MDCPanState!) -> Void in
//                print(state.thresholdRatio)
//            }
//            let view = TestSwipeView(frame: UIEdgeInsetsInsetRect(self.view.bounds, UIEdgeInsets(top: 100, left: 25, bottom: 100, right: 25)), options: options)
//            view.backgroundColor = UIColor.brownColor()
//            //view.setupView()
//            
//            self.view.addSubview(view)
            
            self.addChildViewController(swipeVC)
            swipeVC.view.frame = UIEdgeInsetsInsetRect(self.view.bounds, UIEdgeInsets(top: 80, left: 20, bottom: 80, right: 20))
            swipeVC.view.backgroundColor = UIColor.brownColor()
            self.view.addSubview(swipeVC.view as! KolodaView)
            swipeVC.didMoveToParentViewController(self)
            break;
        default:
            break;
        }
    }
    
    func cancelSwiping( button:UIButton ){
        //swipeView?.removeFromSuperview()
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

extension PostViewController: MDCSwipeToChooseDelegate {
    func viewDidCancelSwipe(view: UIView!) {
        print("Swipe Cancelled")
    }
    
    func view(view: UIView!, shouldBeChosenWithDirection direction: MDCSwipeDirection) -> Bool {
        print(direction)
        print(view.gestureRecognizers)
        return true
    }
    
    func view(view: UIView!, wasChosenWithDirection direction: MDCSwipeDirection) {
        print(direction)
    }
}
