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
    
    let menuItems: [String] = ["My Posts","Dashboard","Feed","The Thinking","Settings"]
    var navController: UINavigationController?
    var drawerController: MMDrawerController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = .wmCoolBlueColor()
        tableView.separatorColor = .white
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
        
        tableView.tableHeaderView?.snp_makeConstraints({ make in
            make.top.equalTo(self.view.snp.topMargin).offset(15)
            make.left.equalTo(self.tableView.snp.left).offset(5)
        })
        
        tableView.tableFooterView?.snp_makeConstraints({ make in
            make.bottom.equalTo(self.view.snp.bottomMargin)
            make.width.equalTo(self.tableView.snp.width)
            make.height.equalTo(150)
        })
    }

    //Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuViewCell
        let backgroundView = UIView()
        
        backgroundView.backgroundColor = UIColor.wmSlateGreyColor()
        cell.titleLabel.text = menuItems[(indexPath as NSIndexPath).row]
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var controller: UIViewController
        
        switch menuItems[(indexPath as NSIndexPath).row] {
        case "My Posts":
            controller = MyPostsViewController()
        case "Feed":
            controller = EveryMyndController()
        case "Dashboard":
            controller = DashboardController()
        case "The Thinking":
            controller = ThinkingViewController()
        case "Settings":
            controller = SettingsTableViewController()
        default:
            controller = ViewController()
            break;
        }
        
        self.drawerController?.centerViewController = UINavigationController(rootViewController: controller)
        self.drawerController?.closeDrawer(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
}

extension MenuViewController {
    
    func tableViewHeader() -> UIView {
        let button = UIButton(type: .custom)
        button.setBackgroundImage(UIImage(named: "cross-menu"), for: UIControlState())
        button.addTarget(self, action: .closeDrawer, for: .touchUpInside)
        return button
    }
    
    func tableViewFooter() -> UIView {
        let footerStackView = UIStackView()
        let logo = UIImageView(image: UIImage(named: "wm-logo-menu"))
        let logOutButton = Button()
        
        logo.contentMode = .center
        logOutButton.setTitle("Log out", for: UIControlState())
        logOutButton.backgroundColor = UIColor.wmGreenishTealColor()
        logOutButton.setFontSize(17)
        logOutButton.addTarget(self, action: .logOutUser, for: .touchUpInside)
        
        footerStackView.axis = .vertical
        footerStackView.alignment = .fill
        footerStackView.distribution = .fillProportionally
        footerStackView.spacing = 6.0
        
        footerStackView.addArrangedSubview(logo)
        footerStackView.addArrangedSubview(logOutButton)
        
        return footerStackView
    }
    
    func closeDrawerButtonTapped( _ sender:Button ){
        self.drawerController?.closeDrawer(animated: true, completion: nil)
    }
    
    func logOutButtonTapped( _ sender: Button ){
        if PFAnonymousUtils.isLinked(with: PFUser.current()) {
            let alertController = UIAlertController(title: "Wait", message: "It looks like you haven’t created an account yet. If you log out now you’ll lose everything.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Create account to keep my data", style: .default, handler: { _ in
                let settingsVC = SettingsTableViewController()
                self.mm_drawerController.closeDrawer(animated: true, completion: nil)
                self.mm_drawerController.centerViewController = UINavigationController(rootViewController: settingsVC)
                settingsVC.registerUser()
            }))
            alertController.addAction(UIAlertAction(title: "That's ok, log me out", style: .destructive, handler: { _ in self.logout() }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }else{
            self.logout()
        }
    }
    
    func logout(){
        SwiftSpinner.show("Logging out...", animated: true)
        PFUser.logOut()
        SwiftSpinner.hide()
        self.mm_drawerController.closeDrawer(animated: true, completion: nil)
        self.drawerController?.centerViewController = UINavigationController(rootViewController: WelcomeViewController())
    }
}

private extension Selector{
    static let closeDrawer = #selector(MenuViewController.closeDrawerButtonTapped(_:))
    static let logOutUser = #selector(MenuViewController.logOutButtonTapped(_:))
}
