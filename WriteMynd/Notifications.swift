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
    
    class func scheduleRepeatingNotification( _ date:Date, interval: NSCalendar.Unit ) -> Date{
        let calendar:Calendar = Calendar.autoupdatingCurrent
        let scheduleDate = calendar.dateBySettingHour(date.hour, minute: date.minute, second: date.second, ofDate: Date(), options: NSCalendar.Options.MatchNextTime)
        let localNotification:UILocalNotification = UILocalNotification()
        let userNotificationTypes:UIUserNotificationType = [ .alert, .badge, .sound ]
        let settings:UIUserNotificationSettings = UIUserNotificationSettings(types: userNotificationTypes, categories: nil)
        let application = UIApplication.shared
        
        localNotification.fireDate = scheduleDate
        localNotification.alertBody = "Take 10 minutes to do something good for your mind"
        localNotification.alertAction = "Make a Post"
        localNotification.timeZone = TimeZone.current
        localNotification.alertTitle = "Write Mynd"
        localNotification.repeatInterval = .day
        localNotification.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber + 1
        localNotification.soundName = UILocalNotificationDefaultSoundName
        
        application.registerUserNotificationSettings(settings)
        application.scheduleLocalNotification(localNotification)
        Analytics.trackUserSetNotificationFor( scheduleDate! )
        
        return scheduleDate!
    }
    
    class func cancelAllLocalNotifications(){
        if let notification = UIApplication.shared.scheduledLocalNotifications?.first {
            Analytics.trackUserRemovedNotificationFor( notification.fireDate! )
        }
        
        UIApplication.shared.cancelAllLocalNotifications()
        UIApplication.shared.applicationIconBadgeNumber = 0;
    }
}
