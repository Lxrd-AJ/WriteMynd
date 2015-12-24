//
//  MenuViewController.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 22/12/2015.
//  Copyright © 2015 The Leaf. All rights reserved.


import UIKit
import MMDrawerController

class MenuViewController: UITableViewController {
    
    let menuItems: [String] = ["Me","Feed","My Mynd","Science","Settings"]
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
        print( menuItems[indexPath.row] )
        switch menuItems[indexPath.row] {
        case "My Mynd":
            let dashboardController: DashboardController = storyboard!.instantiateViewControllerWithIdentifier("DashboardController") as! DashboardController
            self.navController?.pushViewController(dashboardController, animated: true)
            self.drawerController?.closeDrawerAnimated(true, completion: nil)
        default:
            break;
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
