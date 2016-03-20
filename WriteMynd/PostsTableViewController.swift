//
//  PostsTableViewController.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 18/03/2016.
//  Copyright © 2016 The Leaf. All rights reserved.
//

import UIKit
import Parse
import DOFavoriteButton

class PostsTableViewController: UITableViewController {
    
    let CELL_IDENTIFIER = "WriteMynd And Chill Cell"
    var posts:[Post] = []
    var empathisedPosts: [EmpathisedPost] = []
    var currentCellSelection = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(PostTableViewCell.self , forCellReuseIdentifier: CELL_IDENTIFIER)
        self.tableView.backgroundColor = UIColor.clearColor()
        self.tableView.separatorColor = UIColor.clearColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return posts.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // Make the background color show through
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clearColor()
        return headerView
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: PostTableViewCell = tableView.dequeueReusableCellWithIdentifier(CELL_IDENTIFIER, forIndexPath: indexPath) as! PostTableViewCell
        let post: Post = self.posts[ indexPath.section ]
        let dateFormatter = NSDateFormatter()
    
        dateFormatter.dateStyle = .LongStyle
        dateFormatter.timeStyle = .MediumStyle

        if let user = PFUser.currentUser() where post.author.objectId == user.objectId {
            cell.backgroundColor = UIColor.wmDarkSkyBlue10Color()
            cell.isPrivateLabel.text = "me"
            cell.isPrivateLabel.textColor = UIColor.blueColor()
            cell.empathiseButton.hidden = true
        }else{
            cell.backgroundColor = UIColor.whiteColor()
            cell.isPrivateLabel.text = ""
            cell.empathiseButton.setImage(UIImage(named: "Hearts")!, forState: .Normal)
            cell.empathiseButton.hidden = false
        }
        
        if post.text.characters.count > 100 && currentCellSelection != indexPath.section {
            cell.postLabel.text = "\(post.text.substringToIndex(post.text.startIndex.advancedBy(100)))..."
            cell.readMoreButton.hidden = false
        }else{
            cell.postLabel.text = post.text
            cell.readMoreButton.hidden = true
        }
        
        if currentCellSelection == indexPath.section {
            cell.readMoreButton.hidden = false
            cell.readMoreButton.setTitle("Read Less", forState: .Normal)
        }else{
            cell.readMoreButton.setTitle("Read More", forState: .Normal)
        }
        
        if post.isEmpathised {
            cell.empathiseButton.backgroundColor = UIColor.redColor()
        }else{
            cell.empathiseButton.backgroundColor = UIColor.clearColor()
        }
        
        cell.layer.cornerRadius = 5
        cell.layer.borderColor = UIColor.whiteColor().CGColor
        cell.clipsToBounds = true
        
        cell.empathiseButton.tag = indexPath.section
        cell.emojiImageView.image = UIImage( named: post.emoji.value().imageName )
        cell.dateLabel.text = dateFormatter.stringFromDate(post.createdAt!)
        cell.hashTagsLabel.text = post.hashTags.reduce("", combine: { $0! + " " + $1 })
        cell.dateLabel.font = cell.dateLabel.font.fontWithSize(13)
        cell.hashTagsLabel.font = cell.hashTagsLabel.font.fontWithSize(15)
        cell.empathiseButton.addTarget(self, action: "empathisePost:", forControlEvents: .TouchUpInside)
        cell.readMoreButton.addTarget(self, action: "extendPostInCell:", forControlEvents: .TouchUpInside)
        cell.readMoreButton.tag = indexPath.section
        
        return cell
    }
    
    
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        let count = posts[indexPath.section].text.characters.count * 20
//        guard count < 200 else{ return 200.0 }//Maximum height
//        guard count >= 0 else{ return 100.0 }//Minimum height
        if( indexPath.section == currentCellSelection){ return 225 }
        return 150.0
    }
    
//    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return 250.0
//    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5.0
    }
    
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
}

extension PostsTableViewController {
    
    func extendPostInCell( sender:Button ) {
        print(sender.selected)
        
        if sender.selected {
            sender.selected = false
            self.currentCellSelection = -1000
        }else{
            sender.selected = true
            self.currentCellSelection = sender.tag
        }
        
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        self.tableView.reloadData()
    }
    
    func empathisePost( sender:DOFavoriteButton ){
        let post = self.posts[sender.tag]
        if post.isEmpathised {
            //Dempathise the post
            self.empathisedPosts = self.empathisedPosts.filter({ empathisedPost in
                if empathisedPost.postID == post.ID {
                    ParseService.dempathisePost(empathisedPost)
                    return false
                }else{ return true }
            })
            post.isEmpathised = false
            sender.backgroundColor = UIColor.clearColor()
        }else{
            sender.backgroundColor = UIColor.redColor()
            
            //Save the post
            let empathisedPost = EmpathisedPost(user: PFUser.currentUser()!, ID: post.ID!)
            empathisedPosts += [empathisedPost]
            empathisedPost.save()
            post.isEmpathised = true
        }
    }
    
    func reloadData(){
        //Merge the empathises posts to the current posts
        let _ = self.posts.map({ post in
            if self.empathisedPosts.containsPost(post){
                post.isEmpathised = true
                self.tableView.reloadData()
            }
        })
    }
}
