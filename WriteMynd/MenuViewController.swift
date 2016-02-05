//
//  MenuViewController.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 22/12/2015.
//  Copyright © 2015 The Leaf. All rights reserved.


import UIKit
import MMDrawerController

class MenuViewController: UITableViewController {
    
    let menuItems: [String] = ["Me","My Mynd","Settings"]//["Me","Feed","My Mynd","Science","Settings"]
    var navController: UINavigationController?
    var drawerController: MMDrawerController?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        cell.titleLabel.text = menuItems[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var controller: UIViewController
        
        switch menuItems[indexPath.row] {
        case "Me":
            controller = storyboard!.instantiateViewControllerWithIdentifier("MeViewController") as! MeViewController
            (controller as! MeViewController).showPostController = false
        case "My Mynd":
            controller = storyboard!.instantiateViewControllerWithIdentifier("DashboardController") as! DashboardController
        case "Settings":
            controller = storyboard!.instantiateViewControllerWithIdentifier("SettingsTableViewController") as! SettingsTableViewController
        default:
            controller = UIViewController()
            break;
        }
        
        self.drawerController?.centerViewController = UINavigationController(rootViewController: controller)
        self.drawerController?.closeDrawerAnimated(true, completion: nil)
    }
    
}
