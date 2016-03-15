//
//  MeViewController.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 04/12/2015.
//  Copyright © 2015 The Leaf. All rights reserved.
//

//TODO: Make use of a tableview controller and add it as a child controller of MeViewController

import UIKit
import Parse
import ParseUI
import SwiftSpinner
import MMDrawerController

/**
 - todo:
    [ ] Use a ContainerView to represent the `MeViewController` and the `tableView`
 */
class MeViewController: UIViewController {
    
    var showPostController:Bool = true
    var posts:[Post] = []
    var dropDown:PostMethodDropdown = PostMethodDropdown()
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var showMenuButton: UIBarButtonItem!
    @IBOutlet weak var postButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showPostController = false //HIDE_FOR_NOW
        tableView.dataSource = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //Check if User exists
        if let _ = PFUser.currentUser() {
            if showPostController {
                self.performSegueWithIdentifier("showPostController", sender: self)
                showPostController = false
            }else{
                //HIDE_FOR_NOW: SwiftSpinner.show("Patience is a Virtue \n Fetching your Posts")
                fetchPosts()
            }
        }else{
            //Present Signup/Login Page
            let loginVC:LoginViewController = LoginViewController()
            loginVC.signUpController = SignUpViewController()
            self.presentViewController(loginVC, animated: true, completion: nil)
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //Setup the PostButton
        //Present the `PostViewController` modally
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated. 
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let button = sender as? UIButton where segue.identifier == "showPostViewController" {
            let postVC = segue.destinationViewController as! PostViewController
            postVC.selectedSegmentIndex = button.tag //Each Button's tag corresponds to the `segmentedControl` in `PostViewController`
        }
    }
    
    @IBAction func unwindToSegue( segue:UIStoryboardSegue ) {}
    
    /**
     Present the `PostMethodDropdown` view
     - todo:
        [ ] self.dropDown's reference is always changed if the user taps the postButton repeatedly,it creates a weird memory leak bug, create lazy vars for 
            `dropDown` and `transparency` buttons to prevent memory leak
     */
    @IBAction func postButtonTapped( sender:UIButton ){
        let yDropdown = self.tableView.frame.origin.y
        let transparencyButton = UIButton(frame: self.view.bounds)
        transparencyButton.backgroundColor = UIColor.clearColor()
        transparencyButton.addTarget(self, action: "dismissHelperButton:", forControlEvents: .TouchUpInside)
        self.dropDown = PostMethodDropdown(frame: CGRect(x: 0, y: yDropdown-10, width: screenWidth, height: 80))
        self.dropDown.writeItButton.addTarget(self, action: "initiatePostViewControllerSegue:", forControlEvents: .TouchUpInside)
        self.dropDown.swipeItButton.addTarget(self, action: "initiatePostViewControllerSegue:", forControlEvents: .TouchUpInside)
        
        self.view.addSubview(self.dropDown)
        
        UIView.animateWithDuration(0.1, delay: 0.0001, options: .CurveEaseIn, animations: {
            self.dropDown.frame.origin.y = yDropdown
            self.tableView.alpha = 0.2
            }, completion: { bool in
                self.view.insertSubview(transparencyButton, belowSubview: self.dropDown)
        })
    }
    
    @IBAction func showMenu( sender: UIBarButtonItem ){
        self.mm_drawerController.toggleDrawerSide(.Left, animated: true, completion: nil)
    }
    
    func initiatePostViewControllerSegue( sender:UIButton ){
        self.dismissHelperButton(sender)
        self.performSegueWithIdentifier("showPostViewController", sender: sender)
    }
    
    /**
     Helper function to dismiss the Post Method dropdown once the user taps outside the dropdown
     */
    func dismissHelperButton( sender:UIButton ){
        UIView.animateWithDuration(0.001, delay: 0.0, options: .CurveEaseOut, animations: {
            self.dropDown.frame.origin.y -= 10
            self.tableView.alpha = 1.0
            }, completion: { bool in
                self.dropDown.removeFromSuperview()
                sender.removeFromSuperview()
        })
    }
    
    func fetchPosts(){
        ParseService.fetchPostsForUser(PFUser.currentUser()!, callback: { (posts:[Post]) -> Void in
            self.posts = posts
            self.tableView.reloadData()
            SwiftSpinner.hide()
        })
    }
    
}

extension MeViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: PostTableViewCell = tableView.dequeueReusableCellWithIdentifier("PostTableViewCell", forIndexPath: indexPath) as! PostTableViewCell
        let post: Post = self.posts[ indexPath.row ]
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .LongStyle
        dateFormatter.timeStyle = .MediumStyle
        
        cell.emojiLabel.text = post.emoji
        cell.dateLabel.text = dateFormatter.stringFromDate(post.createdAt!)
        cell.postLabel.text = post.text
        cell.hashTagsLabel.text = post.hashTags.reduce("", combine: { $0! + " " + $1 })
        
        cell.dateLabel.font = cell.dateLabel.font.fontWithSize(13)
        cell.hashTagsLabel.font = cell.hashTagsLabel.font.fontWithSize(15)
        
        return cell
    }
}



