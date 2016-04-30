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

class MyPostsViewController: UIViewController {
    
    let postsViewController = PostsTableViewController()
    let loadingView: DGElasticPullToRefreshLoadingView = DGElasticPullToRefreshLoadingViewCircle()
    let buttonStackView = UIStackView()
    var posts: [Post] = []

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
            make.top.equalTo(self.view.snp_top).offset(10)
            make.left.equalTo(self.view.snp_left).offset(10)
            make.width.equalTo(250)
            make.height.equalTo(30)
        })
        
        self.addChildViewController(postsViewController)
        self.view.addSubview(postsViewController.tableView)
        postsViewController.didMoveToParentViewController(self)
        postsViewController.posts = posts
        postsViewController.delegate = self        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.fetchPosts()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        postsViewController.tableView.snp_makeConstraints(closure: { make in
            make.top.equalTo(self.buttonStackView.snp_bottom).offset(10)
            make.width.equalTo(self.view.snp_width).offset(-10)
            make.bottom.equalTo(self.view.snp_bottom)
            make.centerX.equalTo(self.view.snp_centerX)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createFilterButton( title:String ) -> Button {
        let button = Button(type: .Custom)
        button.setTitleColor(UIColor.wmCoolBlueColor(), forState: .Normal)
        button.setTitle(title, forState: .Normal)
        button.setImage(UIImage(named: "oval")!, forState: .Normal)
        button.addTarget(self, action: .filterButtonTapped, forControlEvents: .TouchUpInside)
        button.backgroundColor = UIColor.whiteColor()
        button.layer.cornerRadius = 15.0
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        button.setFontSize(14.0)
        return button
    }
    
    func filterButtonTapped( button: UIButton ){
        switch button.tag {
        case 0: //Posts to me tapped
            self.postsViewController.posts = self.posts.filter({ $0.isPrivate == true })
        case 1:
            self.postsViewController.posts = self.posts.filter({ $0.isPrivate == false })
        default:
            break;
        }
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

}

extension MyPostsViewController: PostsTableVCDelegate {
    
    func shouldSearchPrivatePosts() -> Bool{ return true }
    func canDeletePost() -> Bool { return true }
    func shouldShowMeLabelOnCell() -> Bool { return false }
    
    func editPost(post: Post) {
        let writeVC = WriteViewController()
        writeVC.post = post
        self.navigationController?.pushViewController(writeVC, animated: true)
    }

}

private extension Selector {
    static let filterButtonTapped = #selector(MyPostsViewController.filterButtonTapped(_:))
}