//
//  AppDelegate.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 04/12/2015.
//  Copyright © 2015 The Leaf. All rights reserved.
//

import UIKit
import Parse
import MMDrawerController
import Mixpanel
import SwiftDate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var drawerController: MMDrawerController = MMDrawerController()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //Parse configurations
        Parse.enableLocalDatastore()
        Parse.setApplicationId("psbQTCZJnowKHs9FT534pLsRKOtgxQvkNTmYctOD",clientKey: "JZVNrhm8472sSy8tuXNibdzOI7Xx1k3OJnVoIAXt")
        
        //Mixpanel Config
        Analytics.setup()
        Analytics.trackAppUsageBegan()
        
        //UI Configurations
        UILabel.appearance().font = UIFont(name: "Montserrat-Regular.ttf", size: 17.0)
        UINavigationBar.appearance().barTintColor = UIColor.whiteColor()//
        UINavigationBar.appearance().tintColor = UIColor.wmCoolBlueColor()
        UIBarButtonItem.appearance().tintColor = UIColor(red: 99/255, green: 60/255, blue: 134/255, alpha: 1) //UIColor.whiteColor()
        UIBarButtonItem.appearance().setTitleTextAttributes([
            NSFontAttributeName: UIFont(name: "Montserrat-Regular", size: 15.0)!,
            NSForegroundColorAttributeName: UIColor.wmCoolBlueColor()]
        , forState: .Normal)
        
        //App Configurations
        let signupVC = WelcomeViewController()
        let menuVC: MenuViewController = storyboard.instantiateViewControllerWithIdentifier("MenuViewController") as! MenuViewController
        let navigationController: UINavigationController = UINavigationController(rootViewController: signupVC)
        drawerController = MMDrawerController(centerViewController: navigationController, leftDrawerViewController: menuVC)
        menuVC.navController = navigationController
        menuVC.drawerController = drawerController
        drawerController.openDrawerGestureModeMask = [.BezelPanningCenterView]
        drawerController.closeDrawerGestureModeMask = [.BezelPanningCenterView,.PanningCenterView]
        
        //Local Notifications
        SwiftDate.Region.setDefaultRegion(Region.LocalRegion())
        if let localNotification:UILocalNotification = launchOptions?[UIApplicationLaunchOptionsLocalNotificationKey] as? UILocalNotification {
            application.applicationIconBadgeNumber = 0 //localNotification.applicationIconBadgeNumber--
            print("Application launched by local Notification \n \(localNotification.applicationIconBadgeNumber)")
            let everyMyndVC = EveryMyndController()
            everyMyndVC.shouldShowPostingSheet = true 
            drawerController.centerViewController = UINavigationController(rootViewController: everyMyndVC)
            Analytics.trackAppLaunchFromNotification(true)
        }
        application.applicationIconBadgeNumber = 0 //HACK: Remove later
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window!.rootViewController = drawerController
        window!.makeKeyAndVisible()
        window!.tintColor = UIColor.wmCoolBlueColor()
        
        if let shortcutItem = launchOptions?[UIApplicationLaunchOptionsShortcutItemKey] as? UIApplicationShortcutItem {
            print("Application launched from shortcut item => \(shortcutItem.type)")
            handleQuickAction(shortcutItem)
            return false
        }
        return true //so that `performActionForShortcutItem` would not be called
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        application.applicationIconBadgeNumber = 0
        Analytics.trackAppLaunchFromNotification(true)
        if application.applicationState == .Active {
            print("Local Notification recieved whilst active")
            //TODO: Display an unintrusive notification **google whisper**
        }else if application.applicationState == .Inactive || application.applicationState == .Background{
            //Opened from local push notification in background
        }
    }
    
    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
        print("Performing shortcut item \(shortcutItem.type)")
        completionHandler( handleQuickAction(shortcutItem) )
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        Analytics.trackAppUsageEnded()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        application.applicationIconBadgeNumber = 0
        Analytics.trackAppUsageBegan()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        Analytics.trackAppUsageEnded()
    }

}

extension AppDelegate {
    
    enum ShortCut: String {
        case WriteIt = "writeIt"
        case SwipeIt = "swipeIt"
        case Reflect = "reflect"
    }
    
    func handleQuickAction( shortcutItem: UIApplicationShortcutItem ) -> Bool {
        print("Handling Action \(shortcutItem.localizedTitle)")
        guard PFUser.currentUser() != nil else{ return false }
        var actionHandled = false
        
        let everymynd = EveryMyndController()
        let type = shortcutItem.type.componentsSeparatedByString(".").last!
        if let shortcutType = ShortCut.init(rawValue: type) , nav = drawerController.centerViewController as? UINavigationController{
            switch shortcutType {
            case .WriteIt:
                actionHandled = true
                nav.pushViewController(everymynd, animated: true)
                nav.pushViewController(WriteViewController(), animated: true)
            case .SwipeIt:
                actionHandled = true
                nav.pushViewController(everymynd, animated: true)
                nav.pushViewController(SwipeViewController(), animated: true)
            case .Reflect:
                actionHandled = true
                nav.pushViewController(MyMyndViewController(), animated: true)
            }
        }
        
        return actionHandled
    }
}

