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
import SwiftDate
import ZendeskSDK
import MessageUI

/**
 Settings page for the entire app, Here the user can 
    * Set Reminders
    * Get Help , Zendesk URL https://writemynd.zendesk.com/
    * Log Out
 - todo:
    - [ ] Use Constant strings to represent the row text to avoid errors
 */
class SettingsTableViewController: UITableViewController {
    
    let REMINDER_SWITCH: String = "REMINDER_SWITCH"
    let REMINDER_DATE: String = "REMINDER_DATE"
    
    //Settings Table
    let TROUBLE_APP = "Having trouble with the app?"
    let TIMER = "Reminder set"
    let EMAIL_FEEDBACK = "Send Feedback via Email"
    let LEGAL = "Legal Stuff"
    let reminderSwitch = UISwitch(frame: CGRectZero)
    
    lazy var rows: [String] = {
        return [
            "Set a daily reminder",
            self.TROUBLE_APP,
            self.EMAIL_FEEDBACK,
            self.LEGAL,
            "Log out"
        ]

    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.wmBackgroundColor()
        
        self.tableView.tableFooterView = UIView()
        self.tableView.tableHeaderView = UIImageView(image: UIImage(named: "spannerMan"))
        self.tableView.tableHeaderView?.contentMode = .Center
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "SettingsCell")
        self.tableView.separatorColor = UIColor.wmSilverTwoColor()
        
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "stroke5"))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "hamburger"), style: .Plain, target: self, action: .toggleMenu)

        
        //Check if the user's time string is in the user defaults, if true add the "Timer" string to after "Set a daily reminder"
        if let _ = NSUserDefaults.standardUserDefaults().objectForKey(REMINDER_DATE) where NSUserDefaults.standardUserDefaults().boolForKey(REMINDER_SWITCH) {
            self.rows.insert(TIMER, atIndex: 1)
        }
        
        //Zendesk Configurations
        ZDKConfig.instance().initializeWithAppId("5da13e96950d04535c6ae060f94b79cd713ef65de89b0ef2", zendeskUrl: "https://writemynd.zendesk.com", andClientId: "mobile_sdk_client_8deeb7714b32b75f45de")
        ZDKConfig.instance().userIdentity = ZDKAnonymousIdentity()
        ZDKRMA.configure({ (account:ZDKAccount!,config:ZDKRMAConfigObject!) -> Void in
            //config.dialogActions = []
            config.additionalRequestInfo = "Testing WriteMynd"
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        //Ask the user for feedback, **Only shows if criteria in Zendesk admin have been met**
        //ZDKRMA.showAlwaysInView(self.view)
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
        cell.textLabel?.font = Label.font()
        cell.accessoryView = nil
        cell.backgroundColor = UIColor.whiteColor()
        
        switch cellText {
        case "Set a daily reminder":
            let switchValue = NSUserDefaults.standardUserDefaults().boolForKey(REMINDER_SWITCH)
            reminderSwitch.setOn(switchValue, animated: false)
            reminderSwitch.addTarget(self, action: .reminderSwitchAction, forControlEvents: .ValueChanged)
            cell.accessoryView = reminderSwitch
        case TIMER:
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            //let hour = NSUserDefaults.standardUserDefaults().integerForKey(REMINDER_HOUR)
            //let minute = NSUserDefaults.standardUserDefaults().integerForKey(REMINDER_MINUTE)
            let scheduleDate = NSUserDefaults.standardUserDefaults().objectForKey(self.REMINDER_DATE) as! NSDate
            label.text = "\(scheduleDate.toString(DateFormat.Custom("HH:mm"))!)"
            cell.accessoryView = label
            cell.backgroundColor = UIColor(red: 3/255, green: 201/255, blue: 169/255, alpha: 1)
        default: break
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        let rowText = rows[ indexPath.row ]
        guard rowText != "Set a daily reminder" else{ return false }
        return true
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let rowText = rows[ indexPath.row ]
        
        switch rowText {
        case "Log out":
            PFUser.logOut()
            let meVC: EveryMyndController = storyboard!.instantiateViewControllerWithIdentifier("EveryMyndController") as! EveryMyndController
            self.mm_drawerController.centerViewController = UINavigationController(rootViewController: meVC)
        case TROUBLE_APP:
            ZDKRequests.showRequestCreationWithNavController(self.navigationController)
        case EMAIL_FEEDBACK:
            let mailVC = self.configureMailComposeVC()
            if MFMailComposeViewController.canSendMail() {
                self.presentViewController(mailVC, animated: true, completion: nil)
            }else{
                let alertController = UIAlertController(title: "Error 99", message: "An Error occurred, it seems we couldn't send the mail", preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        case LEGAL:
            self.navigationController?.pushViewController(LegalViewController(), animated: true)
        case TIMER:
            self.dailyReminderSwitchTapped(reminderSwitch)
        default:
            print("Unhandled cell select")
        }
    }
    
}

extension SettingsTableViewController {
    func dailyReminderSwitchTapped( sender:UISwitch ){
        NSUserDefaults.standardUserDefaults().setBool(sender.on, forKey: REMINDER_SWITCH)
        
        if sender.on {
            print("On")
            self.showTimePicker(sender)
        }else{
            //Remove any existing local notification
            UIApplication.sharedApplication().cancelAllLocalNotifications()
            UIApplication.sharedApplication().applicationIconBadgeNumber = 0;
            //Remove the Timer string
            self.rows = rows.filter({ $0 != TIMER })
            //Remove it from the User Defaults
            //NSUserDefaults.standardUserDefaults().removeObjectForKey(REMINDER_HOUR)
            //NSUserDefaults.standardUserDefaults().removeObjectForKey(REMINDER_MINUTE)
            NSUserDefaults.standardUserDefaults().removeObjectForKey(REMINDER_DATE)
            
            self.tableView.reloadData()
        }
        
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func createRepeatingNotification( hour:Int, minute:Int ) -> NSDate {
        //Setup the local notification date
        let calendar:NSCalendar = NSCalendar.autoupdatingCurrentCalendar()
        var scheduleDate = NSDate() //start counting from now
        let dateComponent:NSDateComponents = calendar.components([NSCalendarUnit.Day, NSCalendarUnit.Month, NSCalendarUnit.Year,NSCalendarUnit.Hour , NSCalendarUnit.Minute], fromDate: scheduleDate)
        //        if dateComponent.hour >= 9 {
        //            scheduleDate = scheduleDate.dateByAddingTimeInterval(86400) //The following day
        //            dateComponent = calendar.components([NSCalendarUnit.Day, NSCalendarUnit.Month, NSCalendarUnit.Year,NSCalendarUnit.Hour , NSCalendarUnit.Minute], fromDate: scheduleDate)
        //        }
        dateComponent.hour = hour; dateComponent.minute = minute;
        scheduleDate = calendar.dateFromComponents(dateComponent)!
        print( "Display time = \(scheduleDate.toString(DateFormat.Custom("HH:mm")))" )
        return scheduleDate
    }
    
    func configureMailComposeVC() -> MFMailComposeViewController {
        let composerVC = MFMailComposeViewController()
        composerVC.mailComposeDelegate = self
        composerVC.setToRecipients(["lizziebarclay@hotmail.co.uk"])
        composerVC.setSubject("Feedback on WriteMynd from \(PFUser.currentUser()!.email!)")
        return composerVC
    }
    
    func toggleMenu( sender:UIBarButtonItem ){
        self.mm_drawerController.toggleDrawerSide(.Left, animated: true, completion: nil)
    }
    
    private func showTimePicker( sender:UISwitch ){
        //Show the time selector/picker
        let selectAction: RMAction = RMAction(title: "Select", style: .Done, andHandler: {
            (controller:RMActionController) -> Void in
            let date:NSDate = (controller.contentView as! UIDatePicker).date
            print("Date selected = \(date)")
            let reminderDate = self.createRepeatingNotification(date.hour, minute: date.minute)
            //Add the new time cell string to the table rows array
            if !self.rows.contains(self.TIMER) {
                self.rows.insert(self.TIMER, atIndex: 1)
            }
            //Create a local notification for the selected time
            let localNotification:UILocalNotification = UILocalNotification()
            let userNotificationTypes:UIUserNotificationType = [ .Alert, .Badge, .Sound ]
            let settings:UIUserNotificationSettings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
            let application = UIApplication.sharedApplication()
            
            localNotification.fireDate = reminderDate
            localNotification.alertBody = "Take 10 minutes to do something good for your mind"
            localNotification.alertAction = "Make a Post"
            localNotification.timeZone = NSTimeZone.defaultTimeZone()
            localNotification.alertTitle = "WriteMynd"
            localNotification.repeatInterval = .Day
            localNotification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
            
            application.registerUserNotificationSettings(settings)
            application.scheduleLocalNotification(localNotification)
            //print(localNotification)
            //print("\n")
            //print(UIApplication.sharedApplication().scheduledLocalNotifications)
            //Save the time to the user's defaults
            //NSUserDefaults.standardUserDefaults().setInteger(date.hour, forKey: self.REMINDER_HOUR)
            //NSUserDefaults.standardUserDefaults().setInteger(date.minute, forKey: self.REMINDER_MINUTE)
            NSUserDefaults.standardUserDefaults().setObject(reminderDate, forKey: self.REMINDER_DATE)
            //and reload the table
            self.tableView.reloadData()
        })!
        let cancelAction: RMAction = RMAction(title: "Cancel", style: .Cancel, andHandler: {
            (controller:RMActionController) -> Void in
            //Switch off the time picker and dismiss
            sender.setOn(false, animated: true)
        })!
        let timeSelectionController: RMDateSelectionViewController = RMDateSelectionViewController(style: .Default, title: "Choose a time", message: "Select a time you would like us to remind you", selectAction: selectAction, andCancelAction: cancelAction)!
        timeSelectionController.datePicker.datePickerMode = .Time
        self.presentViewController(timeSelectionController, animated: true, completion: nil)
    }
}

extension SettingsTableViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}

private extension Selector {
    static let reminderSwitchAction = #selector(SettingsTableViewController.dailyReminderSwitchTapped(_:))
    static let toggleMenu = #selector(SettingsTableViewController.toggleMenu(_:))
}