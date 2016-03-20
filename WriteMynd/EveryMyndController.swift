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
    [ ] Once the user starts swiping, hide the bottomView
 */
class EveryMyndController: UIViewController {
    
    var dropDown:PostMethodDropdown = PostMethodDropdown()
    var posts:[Post] = []
    let postsController: PostsTableViewController = PostsTableViewController()
    @IBOutlet weak var showMenuButton: UIBarButtonItem!
    
    var empathisedPosts:[EmpathisedPost] = []
    var postsEmphasised:[Post]{
        return posts.filter({ post in
            if self.empathisedPosts.containsPost(post){
                post.isEmpathised = true
                return true
            }else{ return false }
        })
    }
    
    lazy var everyMyndLabel: Label = {
        let label:Label = Label()
        label.text = "Everymynd"; label.sizeToFit();
        label.adjustsFontSizeToFitWidth = true
        label.font = label.font.fontWithSize(25.0)
        label.textColor = UIColor.wmCoolBlueColor()
        return label
    }()
    
    lazy var empathiseButton: UIButton = {
        let button = Button()
        button.backgroundColor = UIColor.whiteColor()
        button.setTitle("Empathised with", forState: .Normal)
        button.setTitleColor(UIColor.wmCoolBlueColor(), forState: .Normal)
        button.layer.cornerRadius = 14.0
        button.setImage(UIImage(named: "page1"), forState: .Normal)
        button.addTarget(self, action: "showOnlyEmphasisedPosts:", forControlEvents: .TouchUpInside)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        button.setFontSize(14.0)
        return button
    }()
    
    lazy var createPostButton: UIButton = {
        let button: UIButton = UIButton() //frame: CGRect(x: 15, y: 15, width: screenWidth - 30, height: 50)
        button.backgroundColor = UIColor.greenColor()
        button.setTitle("Create a post", forState: .Normal)
        button.addTarget(self, action: "showPostingSheet:", forControlEvents: .TouchUpInside)
        button.alpha = 0.8
        return button;
    }()
    
    lazy var bottomView: UIView = {
        let view = UIView()//frame: CGRect(x: 0, y: screenHeight - 80, width: screenWidth, height: 80)
        view.backgroundColor = UIColor.whiteColor()
        view.alpha = 1.0
        //view.addSubview(self.createPostButton)
        return view;
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "stroke5"))
        self.view.backgroundColor = UIColor(red: 246/255, green: 247/255, blue: 251/255, alpha: 1)     
        //Adding the table view controller to display posts
        self.addChildViewController(postsController)
        self.view.addSubview(postsController.tableView)
        //Height is calculated as 120 offset from top + bottom view's height
        postsController.tableView.frame = CGRectMake(10, 120, screenWidth - 20, screenHeight - (218+bottomView.bounds.height))
        postsController.didMoveToParentViewController(self)
        
        //MARK: View Customisations and Constraints
        self.view.addSubview( everyMyndLabel )
        everyMyndLabel.snp_makeConstraints(closure: { make in
            var topOffset:Float = 35;
            if let navHeight = self.navigationController?.navigationBar.bounds.height{
                topOffset += Float(navHeight);
            }
            make.top.equalTo(self.view).offset(topOffset)
            make.left.equalTo(self.view).offset(10)
            make.width.lessThanOrEqualTo(screenWidth * 0.4)
        })
        
        self.view.addSubview(empathiseButton)
        empathiseButton.snp_makeConstraints(closure: { make in
            make.top.equalTo(everyMyndLabel.snp_top)
            make.right.equalTo(self.view.snp_right).offset(-10)
            make.width.equalTo(169.0)
            make.height.equalTo(29.0)
        })
        
        self.view.addSubview(bottomView);
        bottomView.snp_makeConstraints(closure: { make in
            make.width.equalTo(self.view.snp_width)
            make.bottom.equalTo(self.view.snp_bottom)
            make.height.equalTo(75)
        })
        
        bottomView.addSubview(createPostButton)
        createPostButton.snp_makeConstraints(closure: { make in
            make.edges.equalTo(bottomView).inset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        })
        
        
        //END MARK
        
        if (PFUser.currentUser() != nil) {
            postsController.tableView.hidden = true
            fetchPosts()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //Check if User exists
        if let _ = PFUser.currentUser() {
            
        }else{
            //Present Signup/Login Page
            let loginVC:LoginViewController = LoginViewController()
            loginVC.signUpController = SignUpViewController()
            self.presentViewController(loginVC, animated: true, completion: nil)
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
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
}

extension EveryMyndController {
    
    func showOnlyEmphasisedPosts( sender:Button ){
        if sender.selected {
            sender.backgroundColor = UIColor.whiteColor()
            sender.setTitleColor(UIColor.wmCoolBlueColor(), forState: .Normal)
            sender.selected = false
            self.postsController.posts = self.posts
        }else{
            sender.backgroundColor = UIColor.wmCoolBlueColor()
            sender.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            sender.selected = true
            self.postsController.posts = self.postsEmphasised
        }
        
        self.postsController.tableView.reloadData()
    }
    
    func showPostingSheet( sender:UIButton ){
        self.bottomView.alpha = 0.0
        let theme: JTSActionSheetTheme = JTSActionSheetTheme.defaultTheme()
        let swipeItItem = JTSActionSheetItem(title: "Swipe It", action: {
            self.bottomView.alpha = 1.0
            let swipeVC = self.storyboard?.instantiateViewControllerWithIdentifier("SwipeViewController") as! SwipeViewController
            //self.presentViewController(swipeVC, animated: true, completion: nil)
            self.navigationController?.pushViewController(swipeVC, animated: true)
            }, isDestructive: false)
        let writeItItem = JTSActionSheetItem(title: "Write It", action: {
            self.bottomView.alpha = 1.0
            let writeVC = self.storyboard?.instantiateViewControllerWithIdentifier("WriteViewController") as! WriteViewController
            self.navigationController?.pushViewController(writeVC, animated: true)
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
            
            self.posts = posts
            SwiftSpinner.hide()
        })
        
        ParseService.fetchEmpathisedPosts(PFUser.currentUser()!, callback: { (emPosts:[EmpathisedPost]) -> Void in
            print("Finished loading emphasis data")
            //self.postsController.posts = self.posts
            self.postsController.empathisedPosts = emPosts
            self.empathisedPosts = emPosts
            self.postsController.reloadData()
            self.postsController.tableView.hidden = false
            print("Done")
        })
    }

}