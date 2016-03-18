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
import SnapKit

/**
 - todo:
    [x] Use a ContainerView to represent the `MeViewController` and the `tableView`
 */
class EveryMyndController: UIViewController {
    
    var dropDown:PostMethodDropdown = PostMethodDropdown()
    let postsController: PostsTableViewController = PostsTableViewController()
    @IBOutlet weak var showMenuButton: UIBarButtonItem!
    
    lazy var everyMyndLabel: UILabel = {
        let label:UILabel = UILabel()
        label.text = "Everymynd"; label.sizeToFit()
        label.font = label.font.fontWithSize(25.0)
        label.textColor = UIColor.lightGrayColor()
        return label
    }()
    
    lazy var createPostButton: UIButton = {
        let button: UIButton = UIButton(frame: CGRect(x: 15, y: 15, width: screenWidth - 30, height: 50))
        button.backgroundColor = UIColor.greenColor()
        button.setTitle("Create a post", forState: .Normal)
        button.alpha = 0.8
        return button;
    }()
    
    lazy var bottomView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: screenHeight - 80, width: screenWidth, height: 80))
        view.backgroundColor = UIColor.whiteColor()
        view.alpha = 0.5
        view.addSubview(self.createPostButton)
        return view;
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        //Adding the table view controller to display posts
        self.addChildViewController(postsController)
        self.view.addSubview(postsController.tableView)
        //Height is calculated as 120 offset from top + bottom view's height
        postsController.tableView.frame = CGRectMake(10, 120, screenWidth - 20, screenHeight - (120+bottomView.bounds.height))
        postsController.didMoveToParentViewController(self)
        
        //MARK: View Customisations and Constraints
        self.view.addSubview( everyMyndLabel )
        everyMyndLabel.snp_makeConstraints(closure: { make in
            var topOffset:Float = 40;
            if let navHeight = self.navigationController?.navigationBar.bounds.height{ topOffset += Float(navHeight);}
            make.top.equalTo(self.view).offset(topOffset)
            make.left.equalTo(self.view).offset(10)
        })
        
        self.view.addSubview(bottomView);
        //END MARK
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //Check if User exists
        if let _ = PFUser.currentUser() {
            fetchPosts()
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
        //let yDropdown = self.tableView.frame.origin.y
        let transparencyButton = UIButton(frame: self.view.bounds)
        transparencyButton.backgroundColor = UIColor.clearColor()
        transparencyButton.addTarget(self, action: "dismissHelperButton:", forControlEvents: .TouchUpInside)
        //self.dropDown = PostMethodDropdown(frame: CGRect(x: 0, y: yDropdown-10, width: screenWidth, height: 80))
        self.dropDown.writeItButton.addTarget(self, action: "initiatePostViewControllerSegue:", forControlEvents: .TouchUpInside)
        self.dropDown.swipeItButton.addTarget(self, action: "initiatePostViewControllerSegue:", forControlEvents: .TouchUpInside)
        
        self.view.addSubview(self.dropDown)
        
        UIView.animateWithDuration(0.1, delay: 0.0001, options: .CurveEaseIn, animations: {
            //self.dropDown.frame.origin.y = yDropdown
            //self.tableView.alpha = 0.2
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
            //self.tableView.alpha = 1.0
            }, completion: { bool in
                self.dropDown.removeFromSuperview()
                sender.removeFromSuperview()
        })
    }
    
    func fetchPosts(){
        ParseService.fetchPostsForUser(PFUser.currentUser()!, callback: { (posts:[Post]) -> Void in
            self.postsController.posts = posts
            self.postsController.tableView.reloadData()
            SwiftSpinner.hide()
        })
    }
    
}