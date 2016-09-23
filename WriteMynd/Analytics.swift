//
//  Analytics.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 20/05/2016.
//  Copyright © 2016 The Leaf. All rights reserved.
//

import Foundation
import Mixpanel
import Parse

private let MixpanelService = Mixpanel.sharedInstance(withToken: "35657d737e9e58ce0c79c4bb4cc8a94e");

private let POST_EMPATHISED = "USER_EMPATHISES A POST"
private let USER_SEARCHED = "USER_SEARCHED_FOR"
private let APP_USAGE_BEGAN = "APP_USAGE_BEGAN"
private let APP_LAUNCH_FROM_LOCAL_NOTIFICATION = "APP_LAUNCH_FROM_LOCAL_NOTIFICATION"
private let APP_USAGE = "APP_USAGE"
private let USER_MADE_POST_WITH_MORE_100_WORDS = "USER_MADE_POST_WITH_MORE_100_WORDS"
private let USER_MADE_POST_WITH_MORE_50_WORDS = "USER_MADE_POST_WITH_MORE_50_WORDS"
private let USER_SWIPED_8_WORDS_CONSECUTIVELY = "USER_SWIPED_8_WORDS_CONSECUTIVELY"
private let USER_MADE_POST_WRITING_FEATURE = "USER_MADE_POST_WRITING_FEATURE"
private let USER_IN_WRITE_POST_PAGE = "USER_IN_WRITE_POST_PAGE"
private let USER_SET_LOCAL_NOTIFICATION = "USER_SET_LOCAL_NOTIFICATION"
private let USER_REMOVED_LOCAL_NOTIFICATION = "USER_REMOVED_LOCAL_NOTIFICATION"

class Analytics {
    
    fileprivate static let email:String? = PFUser.current()?.email
    fileprivate static var swipeHistory:[Swipe] = []
    
    class func setup(){
        if let email = PFUser.current()?.email {
            MixpanelService.registerSuperProperties(["user":email])
        }
    }
    
    class func trackUserUsedMyPostsFilter(){
        MixpanelService.track("USER_USED_FILTER_IN_MY_POSTS")
    }
    
    class func trackUserSetNotificationFor( _ date:Date ){
        MixpanelService.track(USER_SET_LOCAL_NOTIFICATION, properties: [
            "fire_date": date
            ])
    }
    
    class func trackUserRemovedNotificationFor( _ date:Date ){
        MixpanelService.track(USER_REMOVED_LOCAL_NOTIFICATION, properties: [
            "fire_date": date
            ])
    }
    
    class func trackUserHid( _ post: Post ){
        MixpanelService.track("USER_HID_POST", properties: [
            "post_text":post.text,
            "post_emoji": post.emoji.value().name
            ])
    }
    
    class func trackAppLaunchFromNotification( _ local:Bool ){
        MixpanelService.track(APP_LAUNCH_FROM_LOCAL_NOTIFICATION)
    }
    
    class func trackAppUsageBegan(){
        if let email = email { MixpanelService.identify(email) }
        MixpanelService.people.increment([APP_USAGE:1])
        MixpanelService.timeEvent(APP_USAGE_BEGAN)
    }
    
    class func trackAppUsageEnded(){ MixpanelService.track(APP_USAGE_BEGAN) }
    
    class func trackSearchFor( _ query:String ){
        MixpanelService.track( USER_SEARCHED, properties: [
                "query": query
            ])
    }
    
    /**
     Tracks the swipe the user just made by recording the emotion, the user swiped on and also increments
     the counter of the number of swipes made by the user
     
     - parameter swipe: The swipe to track
     */
    class func trackUserMade( _ swipe:Swipe ){
        if let email = email { MixpanelService.identify(email) }
        let emotion = swipe.feeling
        MixpanelService.track("USER_SWIPED", properties: [
            "emotion": emotion
            ])
        MixpanelService.people.increment(["SWIPES":1])
        Analytics.swipeHistory.append(swipe)
        if Analytics.swipeHistory.count == 8 {
            MixpanelService.track(USER_SWIPED_8_WORDS_CONSECUTIVELY)
        }
    }
    
    class func trackUserViewed( _ page: UIViewController ){
        switch page {
//        case _ as EveryMyndController:
//            MixpanelService.track()
        case let page as EmojiChartDetailViewController:
            MixpanelService.track("USER_TAPPED_THROUGH_PIE_CHART",properties: [
                "chart_section": page.emoji.value().name
                ])
        default:
            print("Unknown page: \(page)")
            break;
        }
    }
    
    /**
     Similar to `trackUserViewed` but here the duration spent in this page is 
     logged and when the user leaves this page is logged in `timeUserExit`
     
     - parameter page: the page to monitor
     */
    class func timeUserEntered( _ page:UIViewController ){
        switch page {
        case _ as WriteViewController:
            MixpanelService.timeEvent(USER_IN_WRITE_POST_PAGE)
        case _ as DashboardController:
            MixpanelService.timeEvent("USER_IN_DASHBOARD")
        case _ as ThinkingViewController:
            MixpanelService.timeEvent("USER_IN_THINKING_PAGE")
        case _ as MyPostsViewController:
            MixpanelService.timeEvent("USER_IN_MY_POSTS")
        case _ as EveryMyndController:
            MixpanelService.timeEvent("USER_VIEWED_EVERYMYND")
        default:
            print("Unknown page: \(page)")
            break;
        }
    }
    
    /**
     Tracks the time the user exited this page
     
     - parameter page: the page to log on user exit
     */
    class func timeUserExit( _ page:UIViewController,properties:[AnyHashable: Any]? ){
        switch page {
        case _ as WriteViewController:
            MixpanelService.track(USER_IN_WRITE_POST_PAGE, properties: properties)
        case _ as DashboardController:
            MixpanelService.track("USER_IN_DASHBOARD", properties: properties)
        case _ as ThinkingViewController:
            MixpanelService.track("USER_IN_THINKING_PAGE", properties: properties)
        case _ as MyPostsViewController:
            MixpanelService.track("USER_IN_MY_POSTS", properties: properties)
        case _ as EveryMyndController:
            MixpanelService.track("USER_VIEWED_EVERYMYND", properties: properties)
        default:
            print("Unknown page: \(page)")
            break;
        }
    }
    
    /**
     Tracks the post made by the user.
     Updates the count of posts made by the user and tracks the feeling and privacy of the post.
     Logs if the post the user made is a written one.
     Also checks the number of words used in the post to determine if they are above 50, 100
     
     - parameter post: The post to track
     */
    class func trackUserMade( _ post:Post ){
        if let email = email { MixpanelService.identify(email) }
        MixpanelService.people.increment(["POSTS_MADE":1])
        MixpanelService.track("USER_MADE_POST", properties: [
            "Feeling": post.emoji.value().name,
            "private_post": post.isPrivate
            ])
        //Categorise based on the number of words
        guard post.text != "" else{ return }
        MixpanelService.track(USER_MADE_POST_WRITING_FEATURE)
        let words = post.text.components(separatedBy: CharacterSet.whitespacesAndNewlines)
        if words.count >= 100 {
            MixpanelService.track(USER_MADE_POST_WITH_MORE_100_WORDS)
        }else if words.count >= 50 {
            MixpanelService.track(USER_MADE_POST_WITH_MORE_50_WORDS)
        }
    }
    
    class func trackUserEmpathisesWith( _ post:Post ){ MixpanelService.track( POST_EMPATHISED ) }
}
