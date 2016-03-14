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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //Parse configurations
        Parse.setApplicationId("psbQTCZJnowKHs9FT534pLsRKOtgxQvkNTmYctOD",clientKey: "JZVNrhm8472sSy8tuXNibdzOI7Xx1k3OJnVoIAXt")
        
        //UI Configurations
        UILabel.appearance().font = UIFont(name: "Avenir", size: 17.0)
        UINavigationBar.appearance().barTintColor = UIColor.whiteColor()//
        UIBarButtonItem.appearance().tintColor = UIColor(red: 99/255, green: 60/255, blue: 134/255, alpha: 1) //UIColor.whiteColor()
        
        //App Configurations
        let meVC: MeViewController = storyboard.instantiateViewControllerWithIdentifier("MeViewController") as! MeViewController
        let menuVC: MenuViewController = storyboard.instantiateViewControllerWithIdentifier("MenuViewController") as! MenuViewController
        let navigationController: UINavigationController = UINavigationController(rootViewController: meVC)
        let drawerController: MMDrawerController = MMDrawerController(centerViewController: navigationController, leftDrawerViewController: menuVC)
        menuVC.navController = navigationController
        menuVC.drawerController = drawerController
        drawerController.openDrawerGestureModeMask = [.BezelPanningCenterView]
        drawerController.closeDrawerGestureModeMask = [.BezelPanningCenterView,.PanningCenterView]
        
        //Local Notifications
        if let localNotification:UILocalNotification = launchOptions?[UIApplicationLaunchOptionsLocalNotificationKey] as? UILocalNotification {
            application.applicationIconBadgeNumber = 0 //localNotification.applicationIconBadgeNumber--
            print("Application launched by local Notification \n \(localNotification.applicationIconBadgeNumber)")
        }
        application.applicationIconBadgeNumber = 0 //HACK: Remove later
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window!.rootViewController = drawerController
        window!.makeKeyAndVisible()
        
        return true
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        application.applicationIconBadgeNumber = 0
        if application.applicationState == .Active {
            print("Local Notification recieved whilst active")
            //TODO: Display an unintrusive notification
        }
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

