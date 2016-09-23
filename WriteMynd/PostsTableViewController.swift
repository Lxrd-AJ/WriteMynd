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
    func scrollBegan( _ scrollView:UIScrollView )
    func editPost( _ post:Post )
    func shouldShowSearchController() -> Bool
    func shouldShowMeLabelOnCell() -> Bool
    func canDeletePost() -> Bool
    func canShowOptionsButton() -> Bool
    func shouldSearchPrivatePosts() -> Bool
    func canShowEmpathiseButton() -> Bool
    func postsDataNeedsRefreshing()
}
extension PostsTableVCDelegate {
    func scrollBegan( _ scrollView:UIScrollView ){}
    func editPost( _ post:Post ){}
    func shouldShowSearchController() -> Bool { return true }
    func shouldShowMeLabelOnCell() -> Bool { return true }
    func canDeletePost() -> Bool { return false }
    func shouldSearchPrivatePosts() -> Bool{ return false }
    func canShowOptionsButton() -> Bool { return true }
    func canShowEmpathiseButton() -> Bool { return true }
    func postsDataNeedsRefreshing(){}
}

/**
 - note: https://github.com/dzenbot/DZNEmptyDataSet for Empty Posts UI
 - note: https://github.com/Ramotion/circle-menu to replace the Action sheet
 */
class PostsTableViewController: UITableViewController {
    
    let CELL_IDENTIFIER = "WriteMynd And Chill Cell"
    let infoLabel: Label = Label()
    var posts:[Post] = [] { didSet(_posts){ self.updateBackgroundView() } }
    var empathisedPosts: [EmpathisedPost] = [] {
        //Mark the respective posts as empathised
        didSet(emPosts){
            let _ = emPosts.map({ emPost in
                let _ = self.posts.map({ post in if emPost.postID == post.ID { post.isEmpathised = true } })
            })
        }
    }
    var currentCellSelection = -1
    var delegate: PostsTableVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(PostTableViewCell.self , forCellReuseIdentifier: CELL_IDENTIFIER)
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.separatorColor = UIColor.clear
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 150.0
        
        infoLabel.text = "There doesn't seem to be any posts here at the moment. Why not write how you feel?"
        infoLabel.textAlignment = .center
        infoLabel.numberOfLines = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        self.updateBackgroundView()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.updateBackgroundView() //Because this method gets called on `reloadData`
        return 1
    }
    
    // Make the background color show through
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PostTableViewCell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER, for: indexPath) as! PostTableViewCell
        let post: Post = self.posts[ (indexPath as NSIndexPath).section ]

        if let user = PFUser.current() , post.author.objectId == user.objectId {
            cell.backgroundColor = UIColor.wmDarkSkyBlue10Color()
            cell.isPrivateLabel.text = "mine"
            cell.isPrivateLabel.textColor = UIColor.blue
            cell.empathiseButton.isHidden = true
        }else{
            cell.backgroundColor = UIColor.white
            cell.isPrivateLabel.text = ""
            cell.empathiseButton.setImage(UIImage(named: "empathise_heart_filled")!, for: UIControlState())
            cell.empathiseButton.isHidden = false
        }
        
        if post.text.characters.count >= 140 && currentCellSelection != (indexPath as NSIndexPath).section {
            cell.postLabel.text = "\(post.text.substring(to: post.text.characters.index(post.text.startIndex, offsetBy: 140)))..."
            cell.readMoreButton.isHidden = false
        }else{
            cell.postLabel.text = post.text
            cell.readMoreButton.isHidden = true
        }
        
        if currentCellSelection == (indexPath as NSIndexPath).section {
            cell.readMoreButton.isHidden = false
            cell.postLabel.sizeToFit()
            cell.readMoreButton.setTitle("Read Less", for: UIControlState())
        }else{
            cell.readMoreButton.setTitle("Read More", for: UIControlState())
        }
        
        if post.text == "" {
            cell.setNeedsLayout()
            cell.emojiImageView.image = UIImage( named: post.emoji.value().imageNameLarge )
        }else{
            cell.emojiImageView.image = UIImage( named: post.emoji.value().imageName )
        }
        
        //Check if the user has empathised the post
        if post.isEmpathised {
            cell.empathiseButton.setImage(UIImage(named: "empathise_heart_filled"), for: UIControlState())
        }else{
            cell.empathiseButton.setImage(UIImage(named: "empathise_heart"), for: UIControlState())
        }
        
        cell.layer.cornerRadius = 5
        cell.layer.borderColor = UIColor.white.cgColor
        cell.clipsToBounds = true
        
        cell.empathiseButton.tag = (indexPath as NSIndexPath).section
        cell.empathiseButton.sizeToFit()
        cell.hashTagsLabel.setTitle(post.hashTags.reduce("", { $0! + " " + $1 }), for: UIControlState())
        cell.hashTagsLabel.addTarget(self, action: .hashTagsButtonTapped, for: .touchUpInside)
        cell.dateLabel.text = "\(post.createdAt!.monthName) " + post.createdAt!.toString(DateFormat.Custom("dd 'at' HH:mm"))!
        cell.empathiseButton.addTarget(self, action: .empathisePost, for: .touchUpInside)
        cell.readMoreButton.addTarget(self, action: .extendPostInCell, for: .touchUpInside)
        cell.ellipsesButton.addTarget(self, action: .showActionSheet, for: .touchUpInside)
        cell.readMoreButton.tag = (indexPath as NSIndexPath).section
        cell.ellipsesButton.tag = (indexPath as NSIndexPath).section
        cell.updateEmojiConstraints()
        
        //Delegate requirements
        self.updateDelegateRequirements(cell)
        
        return cell
    }
    
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if( (indexPath as NSIndexPath).section == currentCellSelection){
            return UITableViewAutomaticDimension
        }
        return 150.0
    }

    /**
     Estimates the height of the cell.
     If the cell is not being expanded, the default height of 150.0 is returned, else if it is being expanded, the new height is 
     calculated by using the `boundingRectWithSize` method of `NSString` to estimate the new height to fit the current cell
     */
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        //print("Index path \(indexPath.section) \n Current Cell Selection \(currentCellSelection)")
        if( (indexPath as NSIndexPath).section == currentCellSelection){
            let post = self.posts[ (indexPath as NSIndexPath).section ]
            //return CGFloat(post.text.characters.filter({ $0 != " " }).count)
            //return CGFloat(post.text.characters.count)
            
            //let size = (post.text as NSString).sizeWithAttributes([NSFontAttributeName:Label.font()])
            
            let rect = (post.text as NSString).boundingRect(with: CGSize(width: tableView.frame.width,height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:Label.font()], context: nil)
            //print("Cell text width \(rect.width) with height \(rect.height)")
            return rect.height;
        }
        return 150.0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5.0
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
}

/**
 Extension to contain all Selectors used in `PostsTableViewController`
 */
extension PostsTableViewController {
    
    /**
     - todo
        * Remove the background view image + text to the container view instead
        * Use a clear color as the table view's background view
     */
    func updateBackgroundView(){
        if self.posts.count > 0 {
            self.tableView.backgroundView?.isHidden = true
        }else{
            let imgV = UIImageView(image: UIImage(named: "manInTheMirror"))
            imgV.contentMode = .center
            self.tableView.backgroundView = imgV
        }
    }
    
    func updateDelegateRequirements( _ cell: PostTableViewCell ){
        if let delegate = self.delegate {
            if delegate.shouldShowMeLabelOnCell() {
                cell.isPrivateLabel.isHidden = false
            }else{
                cell.isPrivateLabel.isHidden = true
            }
            
            if delegate.canShowOptionsButton() {
                cell.ellipsesButton.isHidden = false
            }else{
                cell.ellipsesButton.isHidden = true
            }
            
            //cell.empathiseButton.hidden = !delegate.canShowEmpathiseButton()
        }
    }
    
    func hashTagsButtonTapped( _ sender:Button ){
        let searchController = SearchViewController()
        searchController.searchParameters = sender.titleLabel!.text!.components(separatedBy: "#")
            .filter({ $0 != " " })//Extra Space added by us in `reduce`
            .map({ "#\($0)" })
        searchController.empathisedPosts = self.empathisedPosts
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
    func showActionSheet( _ sender:Button ){
        let index = sender.tag //The index of the current cell(row) that was touched
        let post = self.posts[ index ]
        let alertController = UIAlertController(title: "Post actions", message: "Choose an action to perform on the post", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: { cancelAction in })
        let hidePost = UIAlertAction(title: "Hide post", style: .default, handler: { hideAction in
            self.hidePost(post, atIndex: index)
            Analytics.trackUserHid(post)
            self.tableView.reloadData()
        })
        let editPostAction = UIAlertAction(title: "Edit post", style: .default, handler: { editAction in
            self.delegate?.editPost(post)
        })
        let deletePostAction = UIAlertAction(title: "Delete post", style: .destructive, handler: { deleteAction in
            let post = self.posts.remove(at: index)
            post.delete()
            self.tableView.reloadData()
        })
        let flagAction = UIAlertAction(title: "Report post", style: .destructive, handler: { flagAction in
            self.hidePost(post, atIndex: index)
            let reportedPost = ReportedPost(postID: post.ID!, reporter: PFUser.current()!)
            post.reportCount += 1;
            post.save()
            reportedPost.save()
            self.tableView.reloadData()
            self.showAlert("Thanks for flagging this post as offensive. We have removed the post and will investigate this further", withTitle: "Noted!")
        })
        let blockUserAction = UIAlertAction(title: "Block user", style: .destructive, handler: { blockAction in
            let authorToBlock = post.author
            let hiddenUser = HiddenUser(blockedUser: authorToBlock, user: PFUser.current()!)
            hiddenUser.save()
            self.posts.remove(at: index)
            self.tableView.reloadData()
            self.showAlert("User has been blocked from you! You will no longer see posts from this user in your feed!", withTitle: "Noted!", completionHandler: { action in
                self.delegate?.postsDataNeedsRefreshing()
            })
        })
        
        if post.author.objectId == PFUser.current()?.objectId {
            alertController.addAction(editPostAction)
        }else{
            alertController.addAction(hidePost)
            alertController.addAction(flagAction)
            alertController.addAction(blockUserAction)
        }
        
        if let _delegate = self.delegate , _delegate.canDeletePost() && (post.author.objectId == PFUser.current()?.objectId){
            alertController.addAction(deletePostAction)
        }
        
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    /**
     This is the functionality for the `read more` button.
     It marks the cell as collapsed or expanded and requests the table view changes it height by calling begin and end updates.
     If the current cell is to be expanded, the table view uses `UITableViewAutomaticDimension` for the height as suggested by
     the estimated number of characters in the cell
     
     - parameter sender: the read more button
     */
    func extendPostInCell( _ sender:Button ) {
//        if sender.selected {
//            sender.selected = false
//            //print("Sender deselected, should be false => \(sender.selected)")
//            self.currentCellSelection = -1000
//        }else{
//            sender.selected = true
//            //print("Sender should be selected, true => \(sender.selected)")
//            self.currentCellSelection = sender.tag
//        }
        
        if sender.tag == self.currentCellSelection {
            //print("Should collapse the cell")
            self.currentCellSelection = -1000
        }else{
            //print("Should expand the cell")
            self.currentCellSelection = sender.tag
        }
        
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        self.tableView.reloadData()
        
        if self.currentCellSelection > 0 {
            //print("Sender tag \(sender.tag), currentSelection \(self.currentCellSelection)")
            if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: sender.tag)) as? PostTableViewCell {
                self.tableView.scrollRectToVisible(cell.frame, animated: true)
            }
            self.tableView.reloadSections(IndexSet(integer: sender.tag), with: UITableViewRowAnimation.automatic)
        }
    }
    
    func empathisePost( _ sender:Button ){
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
            sender.setImage(UIImage(named: "empathise_heart"), for: UIControlState())
        }else{ //Empathise the post
            sender.setImage(UIImage(named: "empathise_heart_filled"), for: UIControlState())
            
            //Save the post
            let empathisedPost = EmpathisedPost(user: PFUser.current()!, ID: post.ID!)
            empathisedPosts += [empathisedPost]
            empathisedPost.save()
            post.isEmpathised = true
            
            Analytics.trackUserEmpathisesWith(post)
        }
    }
    
    func hidePost( _ post:Post , atIndex:Int ){
        let postToHide = HiddenPost(postID: post.ID!, user: PFUser.current()!)
        self.posts.remove(at: atIndex)
        postToHide.save()
    }
    
    func showAlert( _ message:String, withTitle:String, completionHandler:((UIAlertAction) -> Void)? = nil){
        let alertController = UIAlertController(title: withTitle, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: completionHandler))
        self.present(alertController, animated: true, completion: nil)
    }
}

extension PostsTableViewController {
    override func scrollViewWillBeginDragging( _ scrollView: UIScrollView){
        delegate?.scrollBegan( scrollView )
    }
}

private extension Selector {
    static let hashTagsButtonTapped = #selector(PostsTableViewController.hashTagsButtonTapped(_:))
    static let extendPostInCell = #selector(PostsTableViewController.extendPostInCell(_:))
    static let empathisePost = #selector(PostsTableViewController.empathisePost(_:))
    static let showActionSheet = #selector(PostsTableViewController.showActionSheet(_:))
}
