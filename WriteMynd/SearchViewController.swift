//
//  SearchViewController.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 29/03/2016.
//  Copyright © 2016 The Leaf. All rights reserved.
//

import UIKit
import Parse

/**
 - todo: 
    [x] Implement a delegate protocol to prevent the posts from displaying further search controller
 */
class SearchViewController: UIViewController {

    let postsController = PostsTableViewController()
    var searchParameters: [String] = []
    var shouldSearchPrivatePosts: Bool = false
    
    lazy var searchTextField: FloatLabelTextField = {
        let field = FloatLabelTextField()
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 30))
        field.placeholder = "Search for hashtags"
        field.font = Label.font()
        field.backgroundColor = UIColor.clearColor()
        field.adjustsFontSizeToFitWidth = true
        field.leftView = paddingView
        field.leftViewMode = .Always
        field.textColor = .wmCoolBlueColor()
        field.titleActiveTextColour = UIColor.wmSilverColor()
        field.delegate = self
        field.autocorrectionType = .No
        field.autocapitalizationType = .None
        field.returnKeyType = .Search
        field.addBorder(edges: [.Bottom], colour: UIColor.lightGrayColor(), thickness: 0.5)
        return field
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "stroke5"))
        self.view.backgroundColor = UIColor.wmBackgroundColor()
        
        //MARK: View Constraints
        self.view.addSubview(searchTextField)
        searchTextField.snp_makeConstraints(closure: { make in
            make.top.equalTo(self.snp_topLayoutGuideBottom).offset(10)
            make.width.equalTo(self.view.snp_width)
            make.height.equalTo(50)
        })
        //END MARK
        
        //Adding the table view controller to display posts
        self.addChildViewController(postsController)
        self.view.addSubview(postsController.tableView)
        postsController.didMoveToParentViewController(self)
        postsController.delegate = self
        postsController.tableView.snp_makeConstraints(closure: { make in
            make.top.equalTo(searchTextField.snp_bottom)
            make.bottom.equalTo(self.view.snp_bottom)
            make.width.equalTo(self.view.snp_width).offset(-20)
            make.centerX.equalTo(self.view.snp_centerX)
        })
        postsController.tableView.backgroundView = UIImageView(image: UIImage(named: "manInTheMirror"))
        postsController.tableView.backgroundView?.contentMode = .Center
        
        if searchParameters.count > 0 {
            searchTextField.text = searchDisplayText(searchParameters)
            search(searchTextField.text!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

/**
 Extension to contain custom functions for `SearchViewController`
 */
extension SearchViewController {
    
    func toggleBackground( visible:Bool ){
        postsController.tableView.backgroundView?.hidden = visible
    }
    
    /**
     Creates a string to display in the label as the search text by combining an array of strings into a single string
     
     - parameter searchParams: Usually the hashtags
     
     - returns: text to display
     */
    func searchDisplayText( searchParams:[String] ) -> String {
        return searchParams.reduce("", combine: { (searchText,param) in "\(searchText)\(param)"})
    }
    
    func search( text:String ){
        var searchText = text;
        if text.characters.first != "#" {
            searchText = "#" + text
        }
        print("Search text \(searchText)")
        
        Analytics.trackSearchFor(searchText)
        if shouldSearchPrivatePosts {
            ParseService.getPostsWith([searchText], callback: { posts in
                print(posts)
                self.postsController.posts = posts
                self.postsController.tableView.reloadData()
                if posts.count > 0 {
                    self.toggleBackground(true)
                }else{ self.toggleBackground(false) }
                }, forUser: PFUser.currentUser()!)
        }else{
            ParseService.getPostsWith([searchText], callback: { posts in
                print(posts)
                self.postsController.posts = posts
                self.postsController.tableView.reloadData()
                if posts.count > 0 {
                    self.toggleBackground(true)
                }else{ self.toggleBackground(false) }
                }, forUser: nil)
        }
    }
}

extension SearchViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(textField: UITextField) {
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.search(textField.text!)
        return true
    }
}

extension SearchViewController: PostsTableVCDelegate {
    func shouldShowSearchController() -> Bool { return false }
    func canShowOptionsButton() -> Bool { return false }
    func canShowEmpathiseButton() -> Bool { return false }
}