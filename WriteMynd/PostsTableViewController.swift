//
//  PostsTableViewController.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 18/03/2016.
//  Copyright © 2016 The Leaf. All rights reserved.
//

import UIKit
import Parse
import SwiftDate
//import DOFavoriteButton

/***
 ScrollViewDelegate Extensions and Protocol definition
 The protocol propagates the scroll messages to the `PostsTableViewController` delegate
 */
protocol PostsTableVCDelegate {
    func scrollBegan( scrollView:UIScrollView )
    func editPost( post:Post )
    func shouldShowSearchController() -> Bool
    func shouldShowMeLabelOnCell() -> Bool
    func canDeletePost() -> Bool
    func shouldSearchPrivatePosts() -> Bool
}
extension PostsTableVCDelegate {
    func scrollBegan( scrollView:UIScrollView ){}
    func editPost( post:Post ){}
    func shouldShowSearchController() -> Bool { return true }
    func shouldShowMeLabelOnCell() -> Bool { return true }
    func canDeletePost() -> Bool { return false }
    func shouldSearchPrivatePosts() -> Bool{ return false }
}

/**
 - note: https://github.com/dzenbot/DZNEmptyDataSet for Empty Posts UI
 - note: Pull to refresh UI https://github.com/uzysjung/UzysAnimatedGifPullToRefresh
 */
class PostsTableViewController: UITableViewController {
    
    let CELL_IDENTIFIER = "WriteMynd And Chill Cell"
    var posts:[Post] = [] {
        didSet(_posts){
            self.updateBackground()
        }
    }
    var empathisedPosts: [EmpathisedPost] = [] {
        //Mark the respective posts as empathised
        didSet(emPosts){
            let _ = emPosts.map({ emPost in
                let _ = self.posts.map({ post in
                    if emPost.postID == post.ID {
                        post.isEmpathised = true
                    }
                })
            })
        }
    }
    var currentCellSelection = -1
    var delegate: PostsTableVCDelegate?

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
        self.updateBackground() //Because this method gets called on `reloadData`
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

        if let user = PFUser.currentUser() where post.author.objectId == user.objectId {
            cell.backgroundColor = UIColor.wmDarkSkyBlue10Color()
            cell.isPrivateLabel.text = "mine"
            cell.isPrivateLabel.textColor = UIColor.blueColor()
            cell.empathiseButton.hidden = true
        }else{
            cell.backgroundColor = UIColor.whiteColor()
            cell.isPrivateLabel.text = ""
            cell.empathiseButton.setImage(UIImage(named: "empathise_heart_filled")!, forState: .Normal)
            cell.empathiseButton.hidden = false
        }
        
        if post.text.characters.count > 100 && currentCellSelection != indexPath.section {
            cell.postLabel.text = "\(post.text.substringToIndex(post.text.startIndex.advancedBy(100)))..."
            cell.readMoreButton.hidden = false
        }else{
            cell.postLabel.text = post.text
            cell.readMoreButton.hidden = true
        }
        
        if post.text == "" {
            cell.setNeedsLayout()
            cell.emojiImageView.image = UIImage( named: post.emoji.value().imageNameLarge )
        }else{
            cell.emojiImageView.image = UIImage( named: post.emoji.value().imageName )
        }
        
        if currentCellSelection == indexPath.section {
            cell.readMoreButton.hidden = false
            cell.readMoreButton.setTitle("Read Less", forState: .Normal)
        }else{
            cell.readMoreButton.setTitle("Read More", forState: .Normal)
        }
        
        //Check if the user has empathised the post
        if post.isEmpathised {
            cell.empathiseButton.setImage(UIImage(named: "empathise_heart_filled"), forState: .Normal)
        }else{
            cell.empathiseButton.setImage(UIImage(named: "empathise_heart"), forState: .Normal)
        }
        
        cell.layer.cornerRadius = 5
        cell.layer.borderColor = UIColor.whiteColor().CGColor
        cell.clipsToBounds = true
        
        cell.empathiseButton.tag = indexPath.section
        cell.empathiseButton.sizeToFit()
        cell.hashTagsLabel.setTitle(post.hashTags.reduce("", combine: { $0! + " " + $1 }), forState: .Normal)
        cell.hashTagsLabel.setFontSize(15)
        cell.hashTagsLabel.addTarget(self, action: .hashTagsButtonTapped, forControlEvents: .TouchUpInside)
        cell.dateLabel.font = cell.dateLabel.font.fontWithSize(13)
        cell.dateLabel.text = "\(post.createdAt!.monthName) " + post.createdAt!.toString(DateFormat.Custom("dd 'at' HH:mm"))!
        cell.empathiseButton.addTarget(self, action: .empathisePost, forControlEvents: .TouchUpInside)
        cell.readMoreButton.addTarget(self, action: .extendPostInCell, forControlEvents: .TouchUpInside)
        cell.ellipsesButton.addTarget(self, action: .showActionSheet, forControlEvents: .TouchUpInside)
        cell.readMoreButton.tag = indexPath.section
        cell.ellipsesButton.tag = indexPath.section
        cell.updateEmojiConstraints()
        
        //Delegate requirements
        self.updateDelegateRequirements(cell)
        
        return cell
    }
    
    
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if( indexPath.section == currentCellSelection){
            let post = self.posts[ indexPath.section ]
            return CGFloat(post.text.characters.count) + 65.0
        }
        return 150.0
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5.0
    }
    
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
}

/**
 Extension to contain all Selectors used in `PostsTableViewController`
 */
extension PostsTableViewController {
    
    func updateBackground(){
        if self.posts.count > 0 {
            self.tableView.backgroundView?.hidden = true
        }else{
            let imgV = UIImageView(image: UIImage(named: "manInTheMirror"))
            imgV.contentMode = .Center
            self.tableView.backgroundView = imgV
        }
    }
    
    func updateDelegateRequirements( cell: PostTableViewCell ){
        if let delegate = self.delegate {
            if delegate.shouldShowMeLabelOnCell() {
                cell.isPrivateLabel.hidden = false
            }else{
                cell.isPrivateLabel.hidden = true
            }
        }
    }
    
    func hashTagsButtonTapped( sender:Button ){
        let searchController = SearchViewController()
        searchController.searchParameters = sender.titleLabel!.text!.componentsSeparatedByString("#")
            .filter({ $0 != " " })//Extra Space added by us in `reduce`
            .map({ "#\($0)" })
        if let delegate = self.delegate {
            searchController.shouldSearchPrivatePosts = delegate.shouldSearchPrivatePosts()
            if delegate.shouldShowSearchController() {
                self.navigationController?.pushViewController(searchController, animated: true)
            }
        }else{
            self.navigationController?.pushViewController(searchController, animated: true)
        }
    }
    
    /**
     - note: A good alternative is https://github.com/okmr-d/DOAlertController if it were updated
     */
    func showActionSheet( sender:Button ){
        let index = sender.tag //The index of the current cell(row) that was touched
        let post = self.posts[ index ]
        let alertController = UIAlertController(title: "Post Actions", message: "Choose an action to perform on the post", preferredStyle: .ActionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Destructive, handler: { cancelAction in })
        let hidePost = UIAlertAction(title: "Hide Post", style: .Default, handler: { hideAction in
            let postToHide = HiddenPost(postID: post.ID!, user: PFUser.currentUser()!)
            self.posts.removeAtIndex(index)
            postToHide.save()
            self.tableView.reloadData()
        })
        let editPostAction = UIAlertAction(title: "Edit Post", style: .Default, handler: { editAction in
            self.delegate?.editPost(post)
        })
        let deletePostAction = UIAlertAction(title: "Delete Post", style: .Destructive, handler: { deleteAction in
            let post = self.posts.removeAtIndex(index)
            post.delete()
            self.tableView.reloadData()
        })
        
        if post.author.objectId == PFUser.currentUser()?.objectId {
            alertController.addAction(editPostAction)
        }else{
            alertController.addAction(hidePost)
        }
        
        if let _delegate = self.delegate where _delegate.canDeletePost() && (post.author.objectId == PFUser.currentUser()?.objectId){
            alertController.addAction(deletePostAction)
        }
        
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func extendPostInCell( sender:Button ) {
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
        
        if self.currentCellSelection > 0 {
            self.tableView.reloadSections(NSIndexSet(index: sender.tag), withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    func empathisePost( sender:Button ){
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
            sender.setImage(UIImage(named: "empathise_heart"), forState: .Normal)
        }else{ //Empathise the post
            sender.setImage(UIImage(named: "empathise_heart_filled"), forState: .Normal)
            
            //Save the post
            let empathisedPost = EmpathisedPost(user: PFUser.currentUser()!, ID: post.ID!)
            empathisedPosts += [empathisedPost]
            empathisedPost.save()
            post.isEmpathised = true
            
            Analytics.trackUserEmpathisesWith(post)
        }
    }
}

extension PostsTableViewController {

}

extension PostsTableViewController {
    override func scrollViewWillBeginDragging( scrollView: UIScrollView){
        delegate?.scrollBegan( scrollView )
    }
}

private extension Selector {
    static let hashTagsButtonTapped = #selector(PostsTableViewController.hashTagsButtonTapped(_:))
    static let extendPostInCell = #selector(PostsTableViewController.extendPostInCell(_:))
    static let empathisePost = #selector(PostsTableViewController.empathisePost(_:))
    static let showActionSheet = #selector(PostsTableViewController.showActionSheet(_:))
}