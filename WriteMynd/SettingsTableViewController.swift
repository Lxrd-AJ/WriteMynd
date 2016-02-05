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
import RMDateSelectionViewController

class SettingsTableViewController: UITableViewController {
    
    let REMINDER_SWITCH: String = "REMINDER_SWITCH"
    let rows: [String] = [
        "Set a daily reminder",
        "Log out"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "SettingsCell")
        
        //TODO: Check if the user's time string is in the user defaults, if true add the timestring to after "Set a daily reminder"
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
        
        switch cellText {
        //TODO: Check for the user's time string in the defaults and if it exists, color the cell
        case "Set a daily reminder":
            let reminderSwitch = UISwitch(frame: CGRectZero)
            let switchValue = NSUserDefaults.standardUserDefaults().boolForKey(REMINDER_SWITCH)
            reminderSwitch.setOn(switchValue, animated: false)
            reminderSwitch.addTarget(self, action: "dailyReminderSwitchTapped:", forControlEvents: .ValueChanged)
            cell.accessoryView = reminderSwitch
        default:
            print("Unhandled cell customisation")
        }
        
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
    
    func dailyReminderSwitchTapped( sender:UISwitch ){
        NSUserDefaults.standardUserDefaults().setBool(sender.on, forKey: REMINDER_SWITCH)
        let application:UIApplication = UIApplication.sharedApplication()
        
        if sender.on {
            print("On")
            //Show the time selector/picker
            //If successful
                //dismiss the picker
                //Add the new time cell string to the table rows array 
                //Save the time string to the user's defaults
                //and reload the table
            //Switch off the time picker and dismiss
        }else{
            print("Off")
        }
    }
}
