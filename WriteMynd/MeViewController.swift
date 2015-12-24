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

class MeViewController: UIViewController {
    
    var showPostController:Bool = true
    var posts:[Post] = []
    @IBOutlet weak var tableView:UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        showPostController = true
        tableView.dataSource = self
    }
    
    override func viewDidAppear(animated: Bool) {
        //Check if User exists
        if let _ = PFUser.currentUser() {
            if showPostController {
                self.performSegueWithIdentifier("showPostController", sender: self)
                showPostController = false
            }else{
                SwiftSpinner.show("Patience is a Virtue \n Fetching your Posts")
                fetchPosts()
            }
        }else{
            //Present Signup/Login Page
            let loginVC:LoginViewController = LoginViewController()
            loginVC.signUpController = SignUpViewController()
            self.presentViewController(loginVC, animated: true, completion: nil)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated. 
    }
    
    @IBAction func unwindToSegue( segue:UIStoryboardSegue ) {}
    
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



