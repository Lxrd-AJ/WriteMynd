//
//  SettingsTableViewController.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 03/02/2016.
//  Copyright © 2016 The Leaf. All rights reserved.
//

import UIKit
import MMDrawerController
import Parse

class SettingsTableViewController: UITableViewController {
    
    let rows: [String] = [
        "Set a daily reminder",
        "Log out"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "SettingsCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func toggleMenuNavigation(sender: AnyObject) {
        self.mm_drawerController.toggleDrawerSide(.Left, animated: true, completion: nil)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SettingsCell")!
        let cellText = rows[indexPath.row]

        cell.textLabel?.text = cellText
        cell.textLabel?.textColor = UIColor(red: 99/255, green: 60/255, blue: 134/255, alpha: 1)
        cell.textLabel?.font = UIFont(name: "Avenir", size: 17.0)
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let rowText = rows[ indexPath.row ]
        switch rowText {
        case "Log out":
            PFUser.logOut()
            let meVC: MeViewController = storyboard!.instantiateViewControllerWithIdentifier("MeViewController") as! MeViewController
            self.mm_drawerController.centerViewController = UINavigationController(rootViewController: meVC)
        default:
            print("Unhandled cell select")
        }
    }
}
