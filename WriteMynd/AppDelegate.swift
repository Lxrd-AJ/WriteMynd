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
import Fabric
import Crashlytics
import Bolts

let serverURL = "http://178.62.103.146:8080" //http://178.62.103.146:8080

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var drawerController: MMDrawerController = MMDrawerController()
    let parseConfiguration = ParseClientConfiguration {
        $0.applicationId = "rJrwXVeierGtuubX09tjfFY8lNAdcuniTH0EdHbAhE"
        $0.server = serverURL + "/parse"
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //Parse configurations
        Parse.enableLocalDatastore()
        Parse.initialize(with: parseConfiguration)
        
        //Mixpanel Config
        Analytics.setup()
        Analytics.trackAppUsageBegan()
        
        //UI Configurations
        UILabel.appearance().font = UIFont(name: "Montserrat-Regular.ttf", size: 17.0)
        UINavigationBar.appearance().barTintColor = UIColor.white//
        UINavigationBar.appearance().tintColor = UIColor.wmCoolBlueColor()
        UIBarButtonItem.appearance().tintColor = UIColor(red: 99/255, green: 60/255, blue: 134/255, alpha: 1) //UIColor.whiteColor()
        UIBarButtonItem.appearance().setTitleTextAttributes([
            NSFontAttributeName: UIFont(name: "Montserrat-Regular", size: 15.0)!,
            NSForegroundColorAttributeName: UIColor.wmCoolBlueColor()]
        , for: UIControlState())
        
        //App Configurations
        let signupVC = WelcomeViewController()
        let menuVC: MenuViewController = storyboard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        let navigationController: UINavigationController = UINavigationController(rootViewController: signupVC)
        drawerController = MMDrawerController(center: navigationController, leftDrawerViewController: menuVC)
        menuVC.navController = navigationController
        menuVC.drawerController = drawerController
        drawerController.openDrawerGestureModeMask = [.bezelPanningCenterView]
        drawerController.closeDrawerGestureModeMask = [.bezelPanningCenterView,.panningCenterView]
        
        //Local Notifications
        //SwiftDate.Region.setDefaultRegion(Region.LocalRegion())
        if let localNotification:UILocalNotification = launchOptions?[UIApplicationLaunchOptionsKey.localNotification] as? UILocalNotification {
            application.applicationIconBadgeNumber = 0 //localNotification.applicationIconBadgeNumber--
            print("Application launched by local Notification \n \(localNotification.applicationIconBadgeNumber)")
            let everyMyndVC = EveryMyndController()
            everyMyndVC.shouldShowPostingSheet = true 
            drawerController.centerViewController = UINavigationController(rootViewController: everyMyndVC)
            Analytics.trackAppLaunchFromNotification(true)
        }
        application.applicationIconBadgeNumber = 0 //HACK: Remove later
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = drawerController
        window!.makeKeyAndVisible()
        window!.tintColor = UIColor.wmCoolBlueColor()
        
        //Fabric Crashlytics
        Fabric.with([Crashlytics.self])

        if let shortcutItem = launchOptions?[UIApplicationLaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem {
            print("Application launched from shortcut item => \(shortcutItem.type)")
            _ = handleQuickAction(shortcutItem)
            return false
        }
        return true //so that `performActionForShortcutItem` would not be called
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        application.applicationIconBadgeNumber = 0
        Analytics.trackAppLaunchFromNotification(true)
        if application.applicationState == .active {
            print("Local Notification recieved whilst active")
            //TODO: Display an unintrusive notification **google whisper**
        }else if application.applicationState == .inactive || application.applicationState == .background{
            //Opened from local push notification in background
        }
    }
    
    /**
     Deep linking.
     Handles incoming urls for deep links to sections of the app, atm it currently does nothing but pattern match
     
     - parameter application:       <#application description#>
     - parameter url:               <#url description#>
     - parameter sourceApplication: <#sourceApplication description#>
     - parameter annotation:        <#annotation description#>
     
     - note:
        Facebook deep link URL https://fb.me/923854597724718
     
     - returns: <#return value description#>
     */
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        print("Application opening \(url) from source application \(sourceApplication)")
        if url.host == "post" {
            switch url.path {
            case "/main":
                print("App should load my posts page")
            default:
                print("No page matched... returning false")
                return false
            }
            return true
        }else{ return false }
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        print("Performing shortcut item \(shortcutItem.type)")
        completionHandler( handleQuickAction(shortcutItem) )
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        Analytics.trackAppUsageEnded()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        application.applicationIconBadgeNumber = 0
        Analytics.trackAppUsageBegan()
    }

    func applicationWillTerminate(_ application: UIApplication) {
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
    
    func handleQuickAction( _ shortcutItem: UIApplicationShortcutItem ) -> Bool {
        print("Handling Action \(shortcutItem.localizedTitle)")
        guard PFUser.current() != nil else{ return false }
        var actionHandled = false
        
        let everymynd = EveryMyndController()
        let type = shortcutItem.type.components(separatedBy: ".").last!
        if let shortcutType = ShortCut.init(rawValue: type) , let nav = drawerController.centerViewController as? UINavigationController{
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

