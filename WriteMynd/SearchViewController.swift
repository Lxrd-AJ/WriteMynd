//
//  SearchViewController.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 29/03/2016.
//  Copyright © 2016 The Leaf. All rights reserved.
//

import UIKit

/**
 - todo: 
    [ ] Implement a delegate protocol to prevent the posts from displaying further search controller
 */
class SearchViewController: UIViewController {

    let postsController = PostsTableViewController()
    var searchParameters: [String] = []
    
    lazy var searchTextField: FloatLabelTextField = {
        let field = FloatLabelTextField()
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 30))
        field.placeholder = "Search results"
        field.font = Label.font()
        field.backgroundColor = UIColor.clearColor()
        field.adjustsFontSizeToFitWidth = true
        field.leftView = paddingView
        field.leftViewMode = .Always
        field.textColor = .wmCoolBlueColor()
        field.titleActiveTextColour = UIColor.wmSilverColor()
        field.delegate = self
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
        //postsController.delegate = self
        postsController.tableView.snp_makeConstraints(closure: { make in
            make.top.equalTo(searchTextField.snp_bottom)
            make.bottom.equalTo(self.view.snp_bottom)
            make.width.equalTo(self.view.snp_width).offset(-20)
            make.centerX.equalTo(self.view.snp_centerX)
        })
        
        if searchParameters.count > 0 {
            searchTextField.text = searchDisplayText(searchParameters)
            ParseService.getPostsWith(searchParameters, callback: { posts in
                print(posts)
                self.postsController.posts = posts
                self.postsController.tableView.reloadData()
            })
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
    func searchDisplayText( searchParams:[String] ) -> String {
        return searchParams.reduce("", combine: { (searchText,param) in "\(searchText)\(param)"})
    }
}

extension SearchViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(textField: UITextField) {
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
