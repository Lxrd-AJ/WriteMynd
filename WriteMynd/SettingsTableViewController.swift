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
import SwiftSpinner

/**
 Settings page for the entire app, Here the user can 
    * Set Reminders
    * Get Help , Zendesk URL https://writemynd.zendesk.com/
    * Log Out
 - todo:
    - [ ] Use Constant strings to represent the row text to avoid errors
 */
class SettingsTableViewController: UITableViewController {
    
    let REMINDER_SWITCH: String = "REMINDER_SWITCH_" + PFUser.current()!.objectId!
    let REMINDER_DATE: String = "REMINDER_DATE_" + PFUser.current()!.objectId!
    
    //Settings Table
    let TROUBLE_APP = "Having trouble with the app?"
    let TIMER = "Reminder set"
    let EMAIL_FEEDBACK = "Send Feedback via Email"
    let LEGAL = "Legal Stuff"
    let REGISTER_ACCOUNT = "Register your account"
    let reminderSwitch = UISwitch(frame: CGRect.zero)
    
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
        self.tableView.tableHeaderView?.contentMode = .center
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SettingsCell")
        self.tableView.separatorColor = UIColor.wmSilverTwoColor()
        
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "stroke5"))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "hamburger"), style: .plain, target: self, action: .toggleMenu)
        
        //Check if the user's time string is in the user defaults, if true add the "Timer" string to after "Set a daily reminder"
        if let _ = UserDefaults.standard.object(forKey: REMINDER_DATE) , UserDefaults.standard.bool(forKey: REMINDER_SWITCH) {
            self.rows.insert(TIMER, at: 1)
        }
        
        if PFAnonymousUtils.isLinked(with: PFUser.current()) {
            self.rows.insert(REGISTER_ACCOUNT, at: self.rows.count - 1 )
        }
        
        print("\(UIApplication.shared.scheduledLocalNotifications!.count) local notification(s) active")
        //Zendesk Configurations
        ZDKConfig.instance().initialize(withAppId: "5da13e96950d04535c6ae060f94b79cd713ef65de89b0ef2", zendeskUrl: "https://writemynd.zendesk.com", clientId: "mobile_sdk_client_8deeb7714b32b75f45de")
        ZDKConfig.instance().userIdentity = ZDKAnonymousIdentity()
        //ZDKRMA.configure(<#T##configBlock: ((ZDKAccount?, ZDKRMAConfigObject?) -> Void)!##((ZDKAccount?, ZDKRMAConfigObject?) -> Void)!##(ZDKAccount?, ZDKRMAConfigObject?) -> Void#>)
        ZDKRMA.configure({ (account:ZDKAccount?,config:ZDKRMAConfigObject?) -> Void in
            //config.dialogActions = []
            config?.additionalRequestInfo = "Testing WriteMynd"
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Ask the user for feedback, **Only shows if criteria in Zendesk admin have been met**
        //ZDKRMA.showAlwaysInView(self.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func toggleMenuNavigation(_ sender: AnyObject) {
        self.mm_drawerController.toggle(.left, animated: true, completion: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell")!
        let cellText = rows[(indexPath as NSIndexPath).row]

        cell.textLabel?.text = cellText
        cell.textLabel?.textColor = UIColor(red: 99/255, green: 60/255, blue: 134/255, alpha: 1)
        cell.textLabel?.font = Label.font()
        cell.accessoryView = nil
        cell.backgroundColor = UIColor.white
        
        switch cellText {
        case "Set a daily reminder":
            let switchValue = UserDefaults.standard.bool(forKey: REMINDER_SWITCH)
            reminderSwitch.setOn(switchValue, animated: false)
            reminderSwitch.addTarget(self, action: .reminderSwitchAction, for: .valueChanged)
            cell.accessoryView = reminderSwitch
        case TIMER:
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            let scheduleDate = UserDefaults.standard.object(forKey: self.REMINDER_DATE) as! Date
            label.text = "\(scheduleDate.string(format: DateFormat.custom("HH:mm")))"
            cell.accessoryView = label
            cell.backgroundColor = UIColor(red: 3/255, green: 201/255, blue: 169/255, alpha: 1)
        default: break
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let rowText = rows[ (indexPath as NSIndexPath).row ]
        guard rowText != "Set a daily reminder" else{ return false }
        return true
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let rowText = rows[ (indexPath as NSIndexPath).row ]
        
        switch rowText {
        case "Log out":
            if PFAnonymousUtils.isLinked(with: PFUser.current()) {
                let alertController = UIAlertController(title: "Wait", message: "It looks like you haven’t created an account yet. If you log out now you’ll lose everything.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Create account to keep my data ", style: .default, handler: { _ in
                    self.registerUser()
                }))
                alertController.addAction(UIAlertAction(title: "That's ok, log me out", style: .destructive, handler: { _ in self.logout() }))
                alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }else{
                print("Logging out")
               self.logout()
            }
        case TROUBLE_APP:
            ZDKRequests.presentRequestCreation(with: self.navigationController)
        case EMAIL_FEEDBACK:
            let mailVC = self.configureMailComposeVC()
            if MFMailComposeViewController.canSendMail() {
                self.present(mailVC, animated: true, completion: nil)
            }else{
                let alertController = UIAlertController(title: "Error 99", message: "An Error occurred, it seems we couldn't send the mail", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        case LEGAL:
            self.navigationController?.pushViewController(LegalViewController(), animated: true)
        case TIMER:
            self.dailyReminderSwitchTapped(reminderSwitch)
        case REGISTER_ACCOUNT:
            self.registerUser()
        default:
            print("Unhandled cell select")
        }
    }
    
}

extension SettingsTableViewController {
    
    /**
     - todo [ ] Consider cancelling all local notifications before logging out
     */
    func logout(){
        SwiftSpinner.show("Logging out...")
        PFUser.logOut()
        self.mm_drawerController.centerViewController = UINavigationController(rootViewController: WelcomeViewController())
        SwiftSpinner.hide()
    }
    
    func registerUser(){
        let alertController = UIAlertController(title: "Account Registration", message: "Enter a username and password to link your current data with your new account", preferredStyle: .alert )
        let registerAction = UIAlertAction(title: "Register", style: .default, handler: { _ in
            let email = alertController.textFields![0] as UITextField
            let password1 = alertController.textFields![1] as UITextField
            //let password2 = alertController.textFields![2] as UITextField
            
            PFUser.current()!.username = email.text
            PFUser.current()!.email = email.text
            PFUser.current()!.password = password1.text
            
            SwiftSpinner.setTitleFont(Label.font())
            
            do{
                try PFUser.current()?.signUp()
                SwiftSpinner.show("Successfully registered your account", animated: true).addTapHandler({
                    if self.rows.contains(self.REGISTER_ACCOUNT) {
                        let idx = self.rows.index(of: self.REGISTER_ACCOUNT)
                        self.rows.remove(at: idx!)
                        self.tableView.reloadData()
                    }
                    SwiftSpinner.hide()
                }, subtitle: "Tap to dismiss!")
            }catch let error as NSError {
                print(error)
                print(error.localizedDescription)
                SwiftSpinner.show(error.localizedDescription).addTapHandler({ SwiftSpinner.hide() }, subtitle: "Tap to dismiss!")
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alertController.addTextField(configurationHandler: { textField in
            textField.placeholder = "Email"
        })
        alertController.addTextField(configurationHandler: { textfield in
            textfield.placeholder = "Password"
            textfield.isSecureTextEntry = true
        })
        alertController.addTextField(configurationHandler: { textfield in
            textfield.placeholder = "Confirm password"
            textfield.isSecureTextEntry = true
            NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: textfield, queue: OperationQueue.main, using: { notification in
                var enable = false
                if let emailField = alertController.textFields![0] as UITextField? , emailField.text != "" {
                    enable = true
                }
                if let pass1 = alertController.textFields![1] as UITextField?, let pass2 = alertController.textFields![2] as UITextField? {
                    if pass1.text == pass2.text {
                        enable = true
                    }else{ enable = false }
                }
                registerAction.isEnabled = enable
            })
        })
        registerAction.isEnabled = false
        
        alertController.addAction(registerAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func dailyReminderSwitchTapped( _ sender:UISwitch ){
        UserDefaults.standard.set(sender.isOn, forKey: REMINDER_SWITCH)
        if sender.isOn {
            self.showTimePicker(sender)
        }else{
            //Remove any existing local notification, update UI and UserDefaults
            Notifications.cancelAllLocalNotifications()
            self.rows = rows.filter({ $0 != TIMER })
            UserDefaults.standard.removeObject(forKey: REMINDER_DATE)
            self.tableView.reloadData()
        }        
    }
    
    func configureMailComposeVC() -> MFMailComposeViewController {
        let composerVC = MFMailComposeViewController()
        composerVC.mailComposeDelegate = self
        composerVC.setToRecipients(["support@writemynd.freshdesk.com","lizzie@writemynd.com"])
        if let email = PFUser.current()?.email {
            composerVC.setSubject("Feedback on WriteMynd from \(email)")
        }else{
            composerVC.setSubject("Feedback on WriteMynd")
        }
        
        return composerVC
    }
    
    func toggleMenu( _ sender:UIBarButtonItem ){
        self.mm_drawerController.toggle(.left, animated: true, completion: nil)
    }
    
    fileprivate func showTimePicker( _ sender:UISwitch ){
        //Show the time selector/picker
        let selectAction: RMAction = RMAction<UIDatePicker>(title: "Select", style: .done, andHandler: {
            (controller:RMActionController) -> Void in
            Notifications.cancelAllLocalNotifications()
            let date:Date = (controller.contentView).date
            let reminderDate = Notifications.scheduleRepeatingNotification(date, interval: .day)
            
            //Add the new time cell string to the table rows array
            if !self.rows.contains(self.TIMER) {
                self.rows.insert(self.TIMER, at: 1)
            }

            UserDefaults.standard.set(reminderDate, forKey: self.REMINDER_DATE)
            self.tableView.reloadData()
        })!
        let cancelAction: RMAction = RMAction<UIDatePicker>(title: "Cancel", style: .cancel, andHandler: {
            (controller:RMActionController) -> Void in
            self.tableView.reloadData()
        })!
        let timeSelectionController = RMDateSelectionViewController(style: .white, title: "Choose a time", message: "Select a time you would like us to remind you", select: selectAction, andCancel: cancelAction)!
        timeSelectionController.datePicker.datePickerMode = .time
        self.present(timeSelectionController, animated: true, completion: nil)
    }
}

extension SettingsTableViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

private extension Selector {
    static let reminderSwitchAction = #selector(SettingsTableViewController.dailyReminderSwitchTapped(_:))
    static let toggleMenu = #selector(SettingsTableViewController.toggleMenu(_:))
}
