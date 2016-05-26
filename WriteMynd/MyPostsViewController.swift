//
//  MyPostsViewController.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 21/04/2016.
//  Copyright © 2016 The Leaf. All rights reserved.
//

import UIKit
import Parse
import DGElasticPullToRefresh
import JTSActionSheet

class MyPostsViewController: ViewController {
    
    let postsViewController = PostsTableViewController()
    let loadingView: DGElasticPullToRefreshLoadingView = DGElasticPullToRefreshLoadingViewCircle()
    let buttonStackView = UIStackView()
    var posts: [Post] = []
    var lastContentOffSet: CGFloat = 0.0 //tracker to determine if user scrolling up/down
    var shouldShowPostingSheet: Bool = false
    lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.whiteColor()
        view.alpha = 1.0
        return view;
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.wmBackgroundColor()
        loadingView.tintColor = UIColor.wmCoolBlueColor()
        postsViewController.tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            self?.fetchPosts()
            }, loadingView: loadingView)
        postsViewController.tableView.dg_setPullToRefreshFillColor(UIColor.wmSoftBlueColor())
        postsViewController.tableView.dg_setPullToRefreshBackgroundColor(UIColor.wmBackgroundColor())
        
        let postsToMeButton = self.createFilterButton("Posts to me")
        let postsToAllButton = self.createFilterButton("Posts to all")
        postsToMeButton.tag = 0
        postsToAllButton.tag = 1
        
        //Constaints
        self.view.addSubview(buttonStackView)
        buttonStackView.axis = .Horizontal
        buttonStackView.alignment = .Fill
        buttonStackView.distribution = .FillEqually
        buttonStackView.spacing = 10.0
        buttonStackView.addArrangedSubview(postsToMeButton)
        buttonStackView.addArrangedSubview(postsToAllButton)
        buttonStackView.snp_makeConstraints(closure: { make in
            make.top.equalTo(self.snp_topLayoutGuideBottom).offset(10)
            make.left.equalTo(self.view.snp_left).offset(10)
            make.width.equalTo(250)
            make.height.equalTo(30)
        })
        
        self.addChildViewController(postsViewController)
        self.view.addSubview(postsViewController.tableView)
        postsViewController.didMoveToParentViewController(self)
        postsViewController.posts = posts
        postsViewController.delegate = self
        
        self.view.addSubview(bottomView)
        self.view.addSubview(createPostButton)
        
        self.scrollBegan(UIScrollView()) //Decieve the page so it automatically adjusts the bottom view
    }
    
    override func viewWillAppear(animated: Bool) {
        self.fetchPosts()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if shouldShowPostingSheet {
            self.showPostingSheet(self.createPostButton)
            shouldShowPostingSheet = !shouldShowPostingSheet
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        postsViewController.tableView.snp_makeConstraints(closure: { make in
            make.top.equalTo(self.buttonStackView.snp_bottom).offset(10)
            make.width.equalTo(self.view.snp_width).offset(-10)
            make.bottom.equalTo(self.view.snp_bottom)
            make.centerX.equalTo(self.view.snp_centerX)
        })
        
        bottomView.snp_makeConstraints(closure: { make in
            make.width.equalTo(self.view.snp_width)
            make.height.equalTo(75)
        })
        
        createPostButton.snp_makeConstraints(closure: { make in
            make.edges.equalTo(bottomView).inset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createFilterButton( title:String ) -> Button {
        let button = Button(type: .Custom)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.setTitle(title, forState: .Normal)
        button.setImage(UIImage(named: "oval")!, forState: .Normal)
        button.addTarget(self, action: .filterButtonTapped, forControlEvents: .TouchUpInside)
        button.backgroundColor = UIColor.wmCoolBlueColor()
        button.layer.cornerRadius = 15.0
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        button.setFontSize(14.0)
        button.selected = true; //By default they are selected
        return button
    }
    
    func filterButtonTapped( button: Button ){
        if button.selected {
            button.backgroundColor = .whiteColor()
            button.setTitleColor(UIColor.wmCoolBlueColor(), forState: .Normal)
        }else{
            button.backgroundColor = UIColor.wmCoolBlueColor()
            button.setTitleColor(.whiteColor(), forState: .Normal)
        }
        
        switch button.tag {
        case 0: //Posts to me tapped aka Private posts
            if button.selected {
                self.postsViewController.posts = self.postsViewController.posts.filter({ !$0.isPrivate })
                button.selected = false
            }else{
                self.postsViewController.posts += self.posts.filter({ $0.isPrivate })
                button.selected = true
            }
        case 1:
            if button.selected { //Non private posts
                self.postsViewController.posts = self.postsViewController.posts.filter({ $0.isPrivate })
                button.selected = false
            }else{
                self.postsViewController.posts += self.posts.filter({ !$0.isPrivate  })
                button.selected = true
            }
        default:
            break;
        }
        self.postsViewController.posts.sortInPlace({ $0.createdAt!.compare($1.createdAt!) == NSComparisonResult.OrderedDescending})
        self.postsViewController.tableView.reloadData()
    }
    
    func fetchPosts(){
        ParseService.fetchPostsForUser(PFUser.currentUser()!, callback: { posts in
            self.posts = posts //Check if redundant
            self.postsViewController.posts = posts
            self.postsViewController.tableView.reloadData()
            self.postsViewController.tableView.dg_stopLoading()
        })
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

}

extension MyPostsViewController: PostsTableVCDelegate {
    
    func shouldSearchPrivatePosts() -> Bool{ return true }
    func canDeletePost() -> Bool { return true }
    func shouldShowMeLabelOnCell() -> Bool { return false }
    
    /**
     Editing a Post
     
     - parameter post: The post to be edited
     - todo
        [ ] Migrate to `PostsTableViewController` as the functionality is common to both EveryMynd and MyMynd
     */
    func editPost(post: Post) {
        let writeVC = WriteViewController()
        writeVC.post = post
        self.navigationController?.pushViewController(writeVC, animated: true)
    }
    
    /**
     Delegate method
     
     - parameter scrollView: The current scrollview in the view port
     - todo: 
        [ ] Migrate this method to the `PostsTableViewController` as it common in both `EveryMynd` and `MyMynd`
     */
    func scrollBegan( scrollView:UIScrollView ) {
        if( self.lastContentOffSet < scrollView.contentOffset.y ){
            //Scrolling to the bottom
            UIView.animateWithDuration(1.5, delay: 1.5, options: .CurveEaseInOut, animations: {
                self.bottomView.snp_updateConstraints(closure: { make in
                    make.bottom.equalTo(self.view.snp_bottom).offset(100)
                })
                //self.bottomView.snp
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
    static let filterButtonTapped = #selector(MyPostsViewController.filterButtonTapped(_:))
    static let showPostingSheet = #selector(MyPostsViewController.showPostingSheet(_:))
}