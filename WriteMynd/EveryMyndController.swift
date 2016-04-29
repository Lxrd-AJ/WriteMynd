//
//  MeViewController.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 04/12/2015.
//  Copyright © 2015 The Leaf. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import SwiftSpinner
import MMDrawerController
import SnapKit
import JTSActionSheet


class EveryMyndController: ViewController {
    
    var posts:[Post] = []
    var lastContentOffSet: CGFloat = 0.0 //tracker to determine if user scrolling up/down
    let postsController: PostsTableViewController = PostsTableViewController()
    var postsEmphasised:[Post]{
        return postsController.posts.filter({ post in
            return post.isEmpathised
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
    
    lazy var empathiseButton: Button = {
        let button = Button()
        button.backgroundColor = UIColor.whiteColor()
        button.setTitle("Empathised with", forState: .Normal)
        button.setTitleColor(UIColor.wmCoolBlueColor(), forState: .Normal)
        button.layer.cornerRadius = 14.0
        button.setImage(UIImage(named: "empathiseHeart"), forState: .Normal)
        button.addTarget(self, action: .showOnlyEmphasisedPosts,forControlEvents: .TouchUpInside)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        button.setFontSize(14.0)
        return button
    }()
    
    lazy var createPostButton: Button = {
        let button: Button = Button()
        button.backgroundColor = UIColor.wmGreenishTealColor()
        button.setTitle("Create a post", forState: .Normal)
        //button.setImage(UIImage(named: "group")!, forState: .Normal)
        button.setFontSize(16)
        button.addTarget(self, action: .showPostingSheet, forControlEvents: .TouchUpInside)
        button.alpha = 0.8
        return button;
    }()
    
    lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.whiteColor()
        view.alpha = 1.0
        return view;
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 246/255, green: 247/255, blue: 251/255, alpha: 1)
        self.automaticallyAdjustsScrollViewInsets = false 
        
        //Adding the table view controller to display posts
        self.addChildViewController(postsController)
        self.view.addSubview(postsController.tableView)
        postsController.didMoveToParentViewController(self)
        postsController.delegate = self
        
        //MARK: View Customisations and Constraints
        self.view.addSubview( everyMyndLabel )
        everyMyndLabel.snp_makeConstraints(closure: { make in
            make.top.equalTo(self.snp_topLayoutGuideBottom).offset(5)
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
        
        //Posts TableViewController constraints
        postsController.tableView.snp_makeConstraints(closure: { make in
            make.top.equalTo(everyMyndLabel.snp_bottom).offset(6)
            make.centerX.equalTo(self.view.snp_centerX)
            make.bottom.equalTo(bottomView.snp_top).offset(-5)
            make.width.equalTo(screenWidth - 20)
        })
    
        //END MARK
        
        if (PFUser.currentUser() != nil) {
            postsController.tableView.hidden = true
            fetchPosts()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        fetchPosts()
        
        //Track the user viewing `EveryMynd` event
        MixpanelService.track("USER_VIEWED_EVERYMYND")
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated. 
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
            sender.setImage(UIImage(named:"empathiseHeart"), forState: .Normal)
            sender.selected = false
            self.postsController.posts = self.posts
        }else{
            sender.backgroundColor = UIColor.wmCoolBlueColor()
            sender.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            sender.setImage(UIImage(named:"empathise_heart_filled"), forState: .Normal)
            sender.selected = true
            self.postsController.posts = self.postsEmphasised
            print("Empathised posts on button touch \(self.postsEmphasised)")
        }
        
        self.postsController.tableView.reloadData()
    }
    
    /**
    Selector method to show the different methods available to make a post
     - note: Another option https://github.com/okmr-d/DOAlertController
        UIActionSheet does not allow images so an option might be to mimic UIActionSheet with a View
        Controller and View and present them
     */
    func showPostingSheet( sender:UIButton ){
        self.bottomView.alpha = 0.0
        let theme: JTSActionSheetTheme = global_getActionSheetTheme()
        let swipeItItem = JTSActionSheetItem(title: "Swipe It", action: {
            self.bottomView.alpha = 1.0
            let swipeVC = SwipeViewController()
            //self.presentViewController(swipeVC, animated: true, completion: nil)
            self.navigationController?.pushViewController(swipeVC, animated: true)
            }, isDestructive: false)
        let writeItItem = JTSActionSheetItem(title: "Write It", action: {
            self.bottomView.alpha = 1.0
            let writeVC = WriteViewController()
            self.navigationController?.pushViewController(writeVC, animated: true)
            }, isDestructive: false)
        let cancelItem = JTSActionSheetItem(title: "Cancel", action: {
            self.bottomView.alpha = 1.0
            }, isDestructive: true)
        let actionSheet = JTSActionSheet(theme: theme, title: "", actionItems: [swipeItItem, writeItItem], cancelItem: cancelItem)
        actionSheet.showInView(self.view)
    }
    
    /**
     Fechtes the posts for the user within limits and also fetches the empathises posts by the user
     - todo:
        [ ] Use Promises to eradicate the callbacks
     */
    func fetchPosts(){
        ParseService.fetchPostsForUserFeed(PFUser.currentUser()!, callback: { (posts:[Post]) -> Void in
            self.postsController.posts = posts
            self.postsController.tableView.reloadData()
            self.posts = posts
            
            ParseService.fetchEmpathisedPosts(PFUser.currentUser()!, callback: { (emPosts:[EmpathisedPost]) -> Void in
                self.postsController.empathisedPosts = emPosts
                self.postsController.tableView.hidden = false
                self.postsController.tableView.reloadData()
            })
        })
    }

}

extension EveryMyndController: PostsTableVCDelegate {
    
    func editPost(post: Post) {
        let writeVC = WriteViewController()
        writeVC.post = post
        self.navigationController?.pushViewController(writeVC, animated: true)
    }
    
    func scrollBegan( scrollView:UIScrollView ) {
        if( self.lastContentOffSet < scrollView.contentOffset.y ){
            //Scrolling to the bottom
            UIView.animateWithDuration(1.5, delay: 1.5, options: .CurveEaseInOut, animations: {
                self.bottomView.snp_updateConstraints(closure: { make in
                    make.bottom.equalTo(self.view.snp_bottom).offset(100)
                })
                }, completion: nil)
        }else{
            //Scrolling to the top
            UIView.animateWithDuration(5.0, delay: 1.0, options: .CurveEaseIn, animations: {
                self.bottomView.snp_updateConstraints(closure: { make in
                    make.bottom.equalTo(self.view.snp_bottom)
                })
                }, completion: nil)
        }
        self.lastContentOffSet = scrollView.contentOffset.y
    }
    
}

private extension Selector {
    static let showOnlyEmphasisedPosts = #selector(EveryMyndController.showOnlyEmphasisedPosts(_:))
    static let showPostingSheet = #selector(EveryMyndController.showPostingSheet(_:))
}