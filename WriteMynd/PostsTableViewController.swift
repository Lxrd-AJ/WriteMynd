//
//  PostsTableViewController.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 18/03/2016.
//  Copyright © 2016 The Leaf. All rights reserved.
//

import UIKit

class PostsTableViewController: UITableViewController {
    
    let CELL_IDENTIFIER = "WriteMynd And Chill Cell"
    var posts:[Post] = []

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
        //print(post.emoji)
        let dateFormatter = NSDateFormatter()
    
        dateFormatter.dateStyle = .LongStyle
        dateFormatter.timeStyle = .MediumStyle
        
        if post.isPrivate {
            cell.backgroundColor = UIColor(red: 236/250, green: 236/250, blue: 236/255, alpha: 1.0)
            cell.isPrivateLabel.text = "me"
            cell.isPrivateLabel.textColor = UIColor.blueColor()
            cell.empathiseButton.hidden = true
        }else{
            cell.backgroundColor = UIColor.whiteColor()
            cell.isPrivateLabel.text = ""
            cell.empathiseButton.setImage(UIImage(named: "Hearts")!, forState: .Normal)
        }
        cell.layer.cornerRadius = 5
        cell.layer.borderColor = UIColor.whiteColor().CGColor
        cell.clipsToBounds = true
        
        cell.emojiLabel.text = post.emoji
        cell.dateLabel.text = dateFormatter.stringFromDate(post.createdAt!)
        cell.postLabel.text = post.text
        cell.hashTagsLabel.text = post.hashTags.reduce("", combine: { $0! + " " + $1 })
        cell.ellipsesButton.setTitle("...", forState: .Normal)
        cell.ellipsesButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        
        cell.dateLabel.font = cell.dateLabel.font.fontWithSize(13)
        cell.hashTagsLabel.font = cell.hashTagsLabel.font.fontWithSize(15)

        return cell
    }
    
    
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        let count = posts[indexPath.section].text.characters.count * 20
//        guard count < 200 else{ return 200.0 }//Maximum height
//        guard count >= 0 else{ return 100.0 }//Minimum height
        return 200.0
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5.0
    }
    
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

}
