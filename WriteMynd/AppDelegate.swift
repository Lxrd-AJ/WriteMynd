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

let MixpanelService = Mixpanel.sharedInstanceWithToken("35657d737e9e58ce0c79c4bb4cc8a94e");

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //Parse configurations
        Parse.setApplicationId("psbQTCZJnowKHs9FT534pLsRKOtgxQvkNTmYctOD",clientKey: "JZVNrhm8472sSy8tuXNibdzOI7Xx1k3OJnVoIAXt")
        
        //Mixpanel Config
        if let email = PFUser.currentUser()?.email {
            MixpanelService.registerSuperProperties(["user":email])
        }
        
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
        //let meVC: EveryMyndController = storyboard.instantiateViewControllerWithIdentifier("EveryMyndController") as! EveryMyndController
        let signupVC = WelcomeViewController()
        let menuVC: MenuViewController = storyboard.instantiateViewControllerWithIdentifier("MenuViewController") as! MenuViewController
        let navigationController: UINavigationController = UINavigationController(rootViewController: signupVC)
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
        window!.tintColor = UIColor.wmCoolBlueColor()
        
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
        application.applicationIconBadgeNumber = 0
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

