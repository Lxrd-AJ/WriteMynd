//
//  MenuViewController.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 22/12/2015.
//  Copyright © 2015 The Leaf. All rights reserved.


import UIKit
import MMDrawerController
import Parse
import SwiftSpinner

/**
 - todo:
    [ ] Replace each menuItem name with a const string **type saftey**
 */
class MenuViewController: UITableViewController {
    
    let menuItems: [String] = ["My Posts","Dashboard","Every Mynd","The Thinking","Settings"]
    var navController: UINavigationController?
    var drawerController: MMDrawerController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = .wmCoolBlueColor()
        tableView.separatorColor = .whiteColor()
        tableView.alwaysBounceVertical = false
        //tableView.tableHeaderView = self.tableViewHeader()
        tableView.tableFooterView = self.tableViewFooter()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        tableView.tableHeaderView?.snp_makeConstraints(closure: { make in
            make.top.equalTo(self.snp_topLayoutGuideBottom).offset(15)
            make.left.equalTo(self.tableView.snp_left).offset(5)
        })
        
        tableView.tableFooterView?.snp_makeConstraints(closure: { make in
            make.bottom.equalTo(self.snp_bottomLayoutGuideBottom)
            make.width.equalTo(self.tableView.snp_width)
            make.height.equalTo(150)
        })
    }

    //Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath) as! MenuViewCell
        let backgroundView = UIView()
        
        backgroundView.backgroundColor = UIColor.wmSlateGreyColor()
        cell.titleLabel.text = menuItems[indexPath.row]
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var controller: UIViewController
        
        switch menuItems[indexPath.row] {
        case "My Posts":
            controller = MyPostsViewController()
        case "Every Mynd":
            controller = EveryMyndController()
        case "Dashboard":
            controller = DashboardController()
        case "The Thinking":
            controller = ThinkingViewController()
        case "Settings":
            controller = storyboard!.instantiateViewControllerWithIdentifier("SettingsTableViewController") as! SettingsTableViewController
        default:
            controller = ViewController()
            break;
        }
        
        self.drawerController?.centerViewController = UINavigationController(rootViewController: controller)
        self.drawerController?.closeDrawerAnimated(true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80.0
    }
    
}

extension MenuViewController {
    
    func tableViewHeader() -> UIView {
        let button = UIButton(type: .Custom)
        button.setBackgroundImage(UIImage(named: "cross-menu"), forState: .Normal)
        button.addTarget(self, action: .closeDrawer, forControlEvents: .TouchUpInside)
        return button
    }
    
    func tableViewFooter() -> UIView {
        let footerStackView = UIStackView()
        let logo = UIImageView(image: UIImage(named: "wm-logo-menu"))
        let logOutButton = Button()
        
        logo.contentMode = .Center
        logOutButton.setTitle("Log out", forState: .Normal)
        logOutButton.backgroundColor = UIColor.wmGreenishTealColor()
        logOutButton.setFontSize(17)
        logOutButton.addTarget(self, action: .logOutUser, forControlEvents: .TouchUpInside)
        
        footerStackView.axis = .Vertical
        footerStackView.alignment = .Fill
        footerStackView.distribution = .FillProportionally
        footerStackView.spacing = 6.0
        
        footerStackView.addArrangedSubview(logo)
        footerStackView.addArrangedSubview(logOutButton)
        
        return footerStackView
    }
    
    func closeDrawerButtonTapped( sender:Button ){
        self.drawerController?.closeDrawerAnimated(true, completion: nil)
    }
    
    func logOutButtonTapped( sender: Button ){
        if PFAnonymousUtils.isLinkedWithUser(PFUser.currentUser()) {
            let alertController = UIAlertController(title: "Wait", message: "It looks like you haven’t created an account yet. If you log out now you’ll lose everything.", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Create account to keep my data", style: .Default, handler: { _ in
                let settingsVC = SettingsTableViewController()
                self.mm_drawerController.closeDrawerAnimated(true, completion: nil)
                self.mm_drawerController.centerViewController = UINavigationController(rootViewController: settingsVC)
                settingsVC.registerUser()
            }))
            alertController.addAction(UIAlertAction(title: "That's ok, log me out", style: .Destructive, handler: { _ in self.logout() }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }else{
            self.logout()
        }
    }
    
    func logout(){
        SwiftSpinner.show("Logging out...", animated: true)
        PFUser.logOut()
        SwiftSpinner.hide()
        self.mm_drawerController.closeDrawerAnimated(true, completion: nil)
        self.drawerController?.centerViewController = UINavigationController(rootViewController: WelcomeViewController())
    }
}

private extension Selector{
    static let closeDrawer = #selector(MenuViewController.closeDrawerButtonTapped(_:))
    static let logOutUser = #selector(MenuViewController.logOutButtonTapped(_:))
}
