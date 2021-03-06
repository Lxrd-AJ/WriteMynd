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
import DGElasticPullToRefresh
import JTImageButton


class EveryMyndController: ViewController {
    
    var posts:[Post] = []
    var lastContentOffSet: CGFloat = 0.0 //tracker to determine if user scrolling up/down
    var shouldShowPostingSheet: Bool = false 
    let postsController: PostsTableViewController = PostsTableViewController()
    let loadingView: DGElasticPullToRefreshLoadingView = DGElasticPullToRefreshLoadingViewCircle()
    var postsEmphasised:[Post]{
        return postsController.posts.filter({ post in
            return post.isEmpathised
        })
    }
    lazy var everyMyndLabel: Label = {
        let label:Label = Label()
        label.text = "Feed"; label.sizeToFit();
        label.adjustsFontSizeToFitWidth = true
        label.font = label.font.withSize(25.0)
        label.textColor = UIColor.wmCoolBlueColor()
        return label
    }()
    lazy var empathiseButton: Button = {
        let button = Button()
        button.backgroundColor = UIColor.white
        button.setTitle("Saved posts", for: UIControlState())
        button.setTitleColor(UIColor.wmCoolBlueColor(), for: UIControlState())
        button.layer.cornerRadius = 14.0
        button.setImage(UIImage(named: "empathiseHeart"), for: UIControlState())
        button.addTarget(self, action: .showOnlyEmphasisedPosts,for: .touchUpInside)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        button.setFontSize(14.0)
        return button
    }()
    lazy var createPostButton: Button = {
        let button: Button = Button.buttonWithImage("Create a post", imageName: "plusIcon", fontSize:16)
        button.backgroundColor = UIColor.wmGreenishTealColor()
        button.addTarget(self, action: .showPostingSheet, for: .touchUpInside)
        button.alpha = 0.8
        return button;
    }()
    lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
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
        postsController.didMove(toParentViewController: self)
        postsController.delegate = self
        
        loadingView.tintColor = UIColor.wmCoolBlueColor()
        postsController.tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            self?.postsController.tableView.backgroundView?.isHidden = true
            self?.fetchPosts()
        }, loadingView: loadingView)
        postsController.tableView.dg_setPullToRefreshFillColor(UIColor.wmSoftBlueColor())
        postsController.tableView.dg_setPullToRefreshBackgroundColor(UIColor.wmBackgroundColor())
        
        self.view.addSubview( everyMyndLabel )
        self.view.addSubview(empathiseButton)
        self.view.addSubview(bottomView);
        bottomView.addSubview(createPostButton)
        self.scrollBegan(UIScrollView()) //Decieve the page so it automatically adjusts the bottom view
        
        if (PFUser.current() != nil) {
            postsController.tableView.isHidden = false //true
            fetchPosts()
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        everyMyndLabel.snp.makeConstraints({ make in
            make.top.equalTo(self.topLayoutGuide.snp.bottom).offset(5)
            make.left.equalTo(self.view).offset(10)
            make.width.lessThanOrEqualTo(screenWidth * 0.4)
        })
        
        empathiseButton.snp.makeConstraints({ make in
            make.top.equalTo(everyMyndLabel.snp.top)
            make.right.equalTo(self.view.snp.right).offset(-10)
            make.width.equalTo(169.0)
            make.height.equalTo(29.0)
        })
        
        bottomView.snp.makeConstraints({ make in
            make.width.equalTo(self.view.snp.width)
            make.centerX.equalTo(self.view.snp.centerX)
            make.height.equalTo(75)
        })
        
        createPostButton.snp.makeConstraints({ make in
            make.edges.equalTo(bottomView).inset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        })
        
        postsController.tableView.snp.makeConstraints({ make in
            make.top.equalTo(everyMyndLabel.snp.bottom).offset(6)
            make.centerX.equalTo(self.view.snp.centerX)
            make.bottom.equalTo(self.view.snp.bottom)
            make.width.equalTo(screenWidth - 20)
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchPosts()
        
        //Track the user viewing `EveryMynd` event
        Analytics.timeUserEntered(self)
        
        if shouldShowPostingSheet {
            self.showPostingSheet(self.createPostButton)
            shouldShowPostingSheet = !shouldShowPostingSheet
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Analytics.timeUserExit(self, properties: nil)
    }
    
    deinit{
        self.postsController.tableView.dg_removePullToRefresh()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated. 
    }
    
    @IBAction func unwindToSegue( _ segue:UIStoryboardSegue ) {}
    
    @IBAction func showMenu( _ sender: UIBarButtonItem ){
        self.mm_drawerController.toggle(.left, animated: true, completion: nil)
    }
}

extension EveryMyndController {
    
    func showOnlyEmphasisedPosts( _ sender:Button ){
        if sender.isSelected {
            sender.backgroundColor = UIColor.white
            sender.setTitleColor(UIColor.wmCoolBlueColor(), for: UIControlState())
            sender.setImage(UIImage(named:"empathiseHeart"), for: UIControlState())
            sender.isSelected = false
            self.postsController.posts = self.posts
        }else{
            sender.backgroundColor = UIColor.wmCoolBlueColor()
            sender.setTitleColor(UIColor.white, for: UIControlState())
            sender.setImage(UIImage(named:"empathise_heart_filled"), for: UIControlState())
            sender.isSelected = true
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
    func showPostingSheet( _ sender:UIButton ){
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
    
    /**
     Fechtes the posts for the user within limits and also fetches the empathises posts by the user
     - todo:
        [ ] Use Promises to eradicate the callbacks
     */
    func fetchPosts(){
        ParseService.fetchPostsForUserFeed(PFUser.current(), callback: { (posts:[Post]) -> Void in
            self.postsController.tableView.dg_stopLoading()
            
            self.postsController.posts = posts
            self.postsController.tableView.reloadData()
            self.posts = posts
            
            ParseService.fetchEmpathisedPosts(PFUser.current(), callback: { (emPosts:[EmpathisedPost]) -> Void in
                self.postsController.empathisedPosts = emPosts
                self.postsController.tableView.isHidden = false
                self.postsController.tableView.reloadData()
                self.view.setNeedsLayout()
            })
        })
    }

}

extension EveryMyndController: PostsTableVCDelegate {
    
    func editPost(_ post: Post) {
        let writeVC = WriteViewController()
        writeVC.post = post
        self.navigationController?.pushViewController(writeVC, animated: true)
    }
    
    func canDeletePost() -> Bool { return true }
    
    func scrollBegan( _ scrollView:UIScrollView ) {
        if( self.lastContentOffSet < scrollView.contentOffset.y ){
            //Scrolling to the bottom
            UIView.animate(withDuration: 1.5, delay: 1.5, options: .curveEaseInOut, animations: {
                self.bottomView.snp.updateConstraints({ make in
                    make.bottom.equalTo(self.view.snp.bottom).offset(100)
                })
                }, completion: nil)
        }else{
            //Scrolling to the top
            UIView.animate(withDuration: 5.0, delay: 1.0, options: .curveEaseIn, animations: {
                self.bottomView.snp.updateConstraints({ make in
                    make.bottom.equalTo(self.view.snp.bottom)
                })
                }, completion: nil)
        }
        self.lastContentOffSet = scrollView.contentOffset.y
    }
    
    func postsDataNeedsRefreshing(){ self.fetchPosts() }
    
}

private extension Selector {
    static let showOnlyEmphasisedPosts = #selector(EveryMyndController.showOnlyEmphasisedPosts(_:))
    static let showPostingSheet = #selector(EveryMyndController.showPostingSheet(_:))
}
