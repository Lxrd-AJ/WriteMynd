//
//  MyMyndViewController.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 24/03/2016.
//  Copyright © 2016 The Leaf. All rights reserved.
//

import UIKit
import Parse
import Charts

class MyMyndViewController: ViewController {
    
    let dashboardVC = DashboardController()
    let myPostsVC = MyPostsViewController()
    
    var posts:[Post] = []
    
    lazy var myProfileButton: Button = {
        let button = Button()
        button.setTitle("My Profile", forState: .Normal)
        button.setTitleColor(.wmCoolBlueColor(), forState: .Normal)
        button.setFontSize(25.0)
        button.backgroundColor = UIColor.wmDarkSkyBlue10Color()
        button.addTarget(self, action: .toggleProfileAndPost, forControlEvents: .TouchUpInside)
        button.tag = 0
        return button
    }()
    
    lazy var myPostsButton: Button = {
        let button = Button()
        button.setTitle("My Posts", forState: .Normal)
        button.setTitleColor(.wmCoolBlueColor(), forState: .Normal)
        button.setFontSize(25.0)
        button.backgroundColor = UIColor.wmDarkSkyBlue10Color()
        button.addTarget(self, action: .toggleProfileAndPost, forControlEvents: .TouchUpInside)
        button.tag = 1
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.wmBackgroundColor()
        self.automaticallyAdjustsScrollViewInsets = false
        
        //MARK: Constraints 
        self.view.addSubview(myProfileButton)
        myProfileButton.snp_makeConstraints(closure: { make in
            make.top.equalTo(self.snp_topLayoutGuideBottom)
            make.left.equalTo(self.view.snp_left)
            make.width.equalTo(self.view.snp_width).multipliedBy(0.5)
            make.height.equalTo(50)
        })
        
        self.view.addSubview(myPostsButton)
        myPostsButton.snp_makeConstraints(closure: { make in
            //make.size.equalTo(myProfileButton.snp_size)
            make.top.equalTo(myProfileButton.snp_top)
            make.right.equalTo(self.view.snp_right)
            make.width.equalTo(self.view.snp_width).multipliedBy(0.5)
            make.height.equalTo(50)
        })
        //END MARK
        
        ParseService.fetchPostsForUser(PFUser.currentUser()!, callback: { posts in
            self.posts = posts //Check if redundant 
            self.myPostsVC.posts = self.posts
        })
        
        //Toggle to the My profile tab
        self.toggleProfileAndPost(myPostsButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension MyMyndViewController {
    func toggleProfileAndPost( sender: Button ){
        sender.backgroundColor = UIColor.wmSlateGreyColor()
        
        if sender.tag == 0 { //My profile button
            self.myPostsButton.backgroundColor = UIColor.wmDarkSkyBlue10Color()
            
            //Remove the posts table view controller if in the view 
            if self.myPostsVC.view.superview != nil {
                myPostsVC.willMoveToParentViewController(nil)
                myPostsVC.view.removeFromSuperview()
                myPostsVC.removeFromParentViewController()
            }
            
            //Add the Dashboard as a child view controller
            self.addChildViewController(dashboardVC)
            
            self.view.addSubview(dashboardVC.view)
            
            dashboardVC.didMoveToParentViewController(self)
            dashboardVC.view.snp_makeConstraints(closure: { make in
                make.top.equalTo(self.myProfileButton.snp_bottom)
                make.width.equalTo(self.view.snp_width)
                make.bottom.equalTo(self.view.snp_bottom)
                make.centerX.equalTo(self.view.snp_centerX)
            })
            
        }else if sender.tag == 1 {
            self.myProfileButton.backgroundColor = UIColor.wmDarkSkyBlue10Color()            
            
            //Remove the Dashboard Child Controller
            dashboardVC.willMoveToParentViewController(nil)
            dashboardVC.view.removeFromSuperview()
            dashboardVC.removeFromParentViewController()
            
            //Add the posts table view controller
            self.addChildViewController(myPostsVC)
            self.view.addSubview(myPostsVC.view)
            myPostsVC.didMoveToParentViewController(self)
            myPostsVC.view.snp_makeConstraints(closure: { make in
                make.top.equalTo(myProfileButton.snp_bottom)
                make.bottom.equalTo(self.view.snp_bottom)
                make.width.equalTo(self.view.snp_width)
                make.centerX.equalTo(self.view.snp_centerX)
            })
            myPostsVC.postsViewController.posts = self.posts
        }
    }
}

private extension Selector {
    static let toggleProfileAndPost = #selector(MyMyndViewController.toggleProfileAndPost(_:))
}