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
import JTSActionSheet

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
        button.addTarget(self, action: "showPostingSheet:", forControlEvents: .TouchUpInside)
        button.alpha = 0.8
        return button;
    }()
    
    lazy var bottomView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: screenHeight - 80, width: screenWidth, height: 80))
        view.backgroundColor = UIColor.whiteColor()
        view.alpha = 1.0
        view.addSubview(self.createPostButton)
        return view;
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
     
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
            postsController.tableView.hidden = true
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
    
    @IBAction func showMenu( sender: UIBarButtonItem ){
        self.mm_drawerController.toggleDrawerSide(.Left, animated: true, completion: nil)
    }
    
    func showPostingSheet( sender:UIButton ){
        self.bottomView.alpha = 0.0
        let theme: JTSActionSheetTheme = JTSActionSheetTheme.defaultTheme()
        let swipeItItem = JTSActionSheetItem(title: "Swipe It", action: {
            self.bottomView.alpha = 1.0
            let swipeVC = self.storyboard?.instantiateViewControllerWithIdentifier("SwipeViewController") as! SwipeViewController
            self.presentViewController(swipeVC, animated: true, completion: nil)
            //self.navigationController?.pushViewController(swipeVC, animated: true)
            }, isDestructive: false)
        let writeItItem = JTSActionSheetItem(title: "Write It", action: {
            print("Write It")
            self.bottomView.alpha = 1.0
            }, isDestructive: false)
        let cancelItem = JTSActionSheetItem(title: "Cancel", action: {
            self.bottomView.alpha = 1.0
            }, isDestructive: true)
        let actionSheet = JTSActionSheet(theme: theme, title: "", actionItems: [swipeItItem, writeItItem], cancelItem: cancelItem)
        actionSheet.showInView(self.view)
    }
    
    func fetchPosts(){
        ParseService.fetchPostsForUser(PFUser.currentUser()!, callback: { (posts:[Post]) -> Void in
            self.postsController.posts = posts
            self.postsController.tableView.reloadData()
            self.postsController.tableView.hidden = false
            SwiftSpinner.hide()
        })
    }
    
}