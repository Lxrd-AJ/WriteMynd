//
//  Notifications.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 28/05/2016.
//  Copyright © 2016 The Leaf. All rights reserved.
//

import Foundation
import UIKit

class Notifications {
    
    class func scheduleRepeatingNotification( date:NSDate, interval: NSCalendarUnit ) -> NSDate{
        let calendar:NSCalendar = NSCalendar.autoupdatingCurrentCalendar()
        let scheduleDate = calendar.dateBySettingHour(date.hour, minute: date.minute, second: date.second, ofDate: NSDate(), options: NSCalendarOptions.MatchNextTime)
        let localNotification:UILocalNotification = UILocalNotification()
        let userNotificationTypes:UIUserNotificationType = [ .Alert, .Badge, .Sound ]
        let settings:UIUserNotificationSettings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
        let application = UIApplication.sharedApplication()
        
        localNotification.fireDate = scheduleDate
        localNotification.alertBody = "Take 10 minutes to do something good for your mind"
        localNotification.alertAction = "Make a Post"
        localNotification.timeZone = NSTimeZone.defaultTimeZone()
        localNotification.alertTitle = "WriteMynd"
        localNotification.repeatInterval = .Day
        localNotification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
        localNotification.soundName = UILocalNotificationDefaultSoundName
        
        application.registerUserNotificationSettings(settings)
        application.scheduleLocalNotification(localNotification)
        Analytics.trackUserSetNotificationFor( scheduleDate! )
        
        return scheduleDate!
    }
    
    class func cancelAllLocalNotifications(){
        if let notification = UIApplication.sharedApplication().scheduledLocalNotifications?.first {
            Analytics.trackUserRemovedNotificationFor( notification.fireDate! )
        }
        
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0;
    }
}