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

private let MixpanelService = Mixpanel.sharedInstanceWithToken("35657d737e9e58ce0c79c4bb4cc8a94e");

private let POST_EMPATHISED = "USER_EMPATHISES A POST"
private let USER_SEARCHED = "USER_SEARCHED_FOR"
private let APP_USAGE_BEGAN = "APP_USAGE_BEGAN"
private let APP_LAUNCH_FROM_LOCAL_NOTIFICATION = "APP_LAUNCH_FROM_LOCAL_NOTIFICATION"
private let APP_USAGE = "APP_USAGE"
private let USER_MADE_POST_WITH_MORE_100_WORDS = "USER_MADE_POST_WITH_MORE_100_WORDS"
private let USER_MADE_POST_WITH_MORE_50_WORDS = "USER_MADE_POST_WITH_MORE_50_WORDS"
private let USER_SWIPED_8_WORDS_CONSECUTIVELY = "USER_SWIPED_8_WORDS_CONSECUTIVELY"
private let USER_MADE_POST_WRITING_FEATURE = "USER_MADE_POST_WRITING_FEATURE"

class Analytics {
    
    private static let email:String? = PFUser.currentUser()?.email
    private static var swipeHistory:[Swipe] = []
    
    class func setup(){
        if let email = PFUser.currentUser()?.email {
            MixpanelService.registerSuperProperties(["user":email])
        }
    }
    
    class func trackAppLaunchFromNotification( local:Bool ){
        MixpanelService.track(APP_LAUNCH_FROM_LOCAL_NOTIFICATION)
    }
    
    class func trackAppUsageBegan(){
        if let email = email { MixpanelService.identify(email) }
        MixpanelService.people.increment([APP_USAGE:1])
        MixpanelService.timeEvent(APP_USAGE_BEGAN)
    }
    
    class func trackAppUsageEnded(){ MixpanelService.track(APP_USAGE_BEGAN) }
    
    class func trackSearchFor( query:String ){
        MixpanelService.track( USER_SEARCHED, properties: [
                "query": query
            ])
    }
    
    /**
     Tracks the swipe the user just made by recording the emotion, the user swiped on and also increments
     the counter of the number of swipes made by the user
     
     - parameter swipe: The swipe to track
     */
    class func trackUserMade( swipe:Swipe ){
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
    
    class func trackUserViewed( page: UIViewController ){
        switch page {
        case page is EveryMyndController: 
            MixpanelService.track("USER_VIEWED_EVERYMYND")
        default:
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
    class func trackUserMade( post:Post ){
        if let email = email { MixpanelService.identify(email) }
        MixpanelService.people.increment(["POSTS_MADE":1])
        MixpanelService.track("USER_MADE_POST", properties: [
            "Feeling": post.emoji.value().name,
            "private_post": post.isPrivate
            ])
        //Categorise based on the number of words
        guard post.text != "" else{ return }
        MixpanelService.track(USER_MADE_POST_WRITING_FEATURE)
        let words = post.text.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if words.count >= 100 {
            MixpanelService.track(USER_MADE_POST_WITH_MORE_100_WORDS)
        }else if words.count >= 50 {
            MixpanelService.track(USER_MADE_POST_WITH_MORE_50_WORDS)
        }
    }
    
    class func trackUserEmpathisesWith( post:Post ){ MixpanelService.track( POST_EMPATHISED ) }
}