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
        view.backgroundColor = UIColor.white
        view.alpha = 1.0
        return view;
    }()
    lazy var createPostButton: Button = {
        let button: Button = Button()
        button.backgroundColor = UIColor.wmGreenishTealColor()
        button.setTitle("Create a post", for: UIControlState())
        //button.setImage(UIImage(named: "group")!, forState: .Normal)
        button.setFontSize(16)
        button.addTarget(self, action: .showPostingSheet, for: .touchUpInside)
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

        let postsToMeButton = self.createFilterButton("Only posts to me")
        let postsToAllButton = self.createFilterButton("Only shared posts")
        postsToMeButton.tag = 5
        postsToAllButton.tag = 10

        //Constaints
        self.view.addSubview(buttonStackView)
        buttonStackView.axis = .horizontal
        buttonStackView.alignment = .fill
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 10.0
        buttonStackView.addArrangedSubview(postsToMeButton)
        buttonStackView.addArrangedSubview(postsToAllButton)
        buttonStackView.snp.makeConstraints({ make in
            make.top.equalTo(self.topLayoutGuide.snp.bottom).offset(10)
            make.centerX.equalTo(self.view.snp.centerX)
            make.width.equalTo(self.view.snp.width).offset(-5)
            make.height.equalTo(30)
        })

        self.addChildViewController(postsViewController)
        self.view.addSubview(postsViewController.tableView)
        postsViewController.didMove(toParentViewController: self)
        postsViewController.posts = posts
        postsViewController.delegate = self

        self.view.addSubview(bottomView)
        self.view.addSubview(createPostButton)

        self.scrollBegan(UIScrollView()) //Decieve the page so it automatically adjusts the bottom view
    }

    override func viewWillAppear(_ animated: Bool) {
        self.fetchPosts()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if shouldShowPostingSheet {
            self.showPostingSheet(self.createPostButton)
            shouldShowPostingSheet = !shouldShowPostingSheet
        }
        Analytics.timeUserEntered(self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Analytics.timeUserExit(self, properties: nil)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        postsViewController.tableView.snp.makeConstraints({ make in
            make.top.equalTo(self.buttonStackView.snp.bottom).offset(10)
            make.width.equalTo(self.view.snp.width).offset(-10)
            make.bottom.equalTo(self.view.snp.bottom)
            make.centerX.equalTo(self.view.snp.centerX)
        })

        bottomView.snp.makeConstraints({ make in
            make.width.equalTo(self.view.snp.width)
            make.height.equalTo(75)
        })

        createPostButton.snp.makeConstraints({ make in
            make.edges.equalTo(bottomView).inset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func createFilterButton( _ title: String) -> Button {
        let button = Button(type: .custom)
        button.setTitle(title, for: UIControlState())
        button.setImage(UIImage(named: "oval")!, for: UIControlState())
        button.addTarget(self, action: .filterButtonTapped, for: .touchUpInside)
        button.backgroundColor = .white
        button.setTitleColor(UIColor.wmCoolBlueColor(), for: UIControlState())
        button.layer.cornerRadius = 15.0
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        button.setFontSize(12.0)
        button.isSelected = false
        return button
    }

    /**
     Filters the currently displayed posts based on the tapped button.
     Analytics data is also logged to the server
     
     - note: `Post to me button` has a tag of 5 whilst `Post to all button` has a tag of 10
     - parameter button: the tapped button
     */
    func filterButtonTapped( _ button: Button) {
        func design( _ button: UIButton, selected: Bool) {
            if !selected {
                button.backgroundColor = .white
                button.setTitleColor(UIColor.wmCoolBlueColor(), for: UIControlState())
            } else {
                button.backgroundColor = UIColor.wmCoolBlueColor()
                button.setTitleColor(.white, for: UIControlState())
            }
        }

        let otherButtonTag = button.tag == 5 ? 10 : 5
        let otherButton = self.view.viewWithTag(otherButtonTag) as! Button

        if button.isSelected {
            self.postsViewController.posts = self.posts
            design(button, selected: false)
            design(otherButton, selected: false)
        } else {
            if button.tag == 5 {
                self.postsViewController.posts = self.posts.filter({ $0.isPrivate })
            } else {
                self.postsViewController.posts = self.posts.filter({ !$0.isPrivate })
            }
            design(button, selected: !button.isSelected)
            design(otherButton, selected: button.isSelected)
            otherButton.isSelected = button.isSelected
        }

        button.isSelected = !button.isSelected
        self.postsViewController.posts.sort(by: { $0.createdAt!.compare($1.createdAt! as Date) == ComparisonResult.orderedDescending })
        self.postsViewController.tableView.reloadData()

        Analytics.trackUserUsedMyPostsFilter()
    }

    func fetchPosts() {
        ParseService.fetchPostsForUser(PFUser.current()!, callback: { posts in
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
    func showPostingSheet( _ sender: UIButton) {
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
        let actionSheet = JTSActionSheet(theme: theme, title: "", actionItems: [swipeItItem, writeItItem], cancel: cancelItem)
        actionSheet?.show(in: self.view)
    }

}

extension MyPostsViewController: PostsTableVCDelegate {

    func shouldSearchPrivatePosts() -> Bool { return true }
    func canDeletePost() -> Bool { return true }
    func shouldShowMeLabelOnCell() -> Bool { return false }
    func canShowEmpathiseButton() -> Bool { return false }

    /**
     Editing a Post
     
     - parameter post: The post to be edited
     - todo
        [ ] Migrate to `PostsTableViewController` as the functionality is common to both EveryMynd and MyMynd
     */
    func editPost(_ post: Post) {
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
    func scrollBegan( _ scrollView: UIScrollView) {
        if( self.lastContentOffSet < scrollView.contentOffset.y) {
            //Scrolling to the bottom
            UIView.animate(withDuration: 1.5, delay: 1.5, options: .curveEaseInOut, animations: {
                self.bottomView.snp.updateConstraints({ make in
                    make.bottom.equalTo(self.view.snp.bottom).offset(100)
                })
                //self.bottomView.snp
            }, completion: nil)
        } else {
            //Scrolling to the top
            UIView.animate(withDuration: 5.0, delay: 1.0, options: .curveEaseIn, animations: {
                self.bottomView.snp.updateConstraints({ make in
                    make.bottom.equalTo(self.view.snp.bottom)
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
