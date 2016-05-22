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

class Analytics {
    
    private static let email:String = PFUser.currentUser()!.email!
    
    class func setup(){
        if let email = PFUser.currentUser()?.email {
            MixpanelService.registerSuperProperties(["user":email])
        }
    }
    
    class func trackAppUsageBegan(){ MixpanelService.timeEvent(APP_USAGE_BEGAN) }
    
    class func trackAppUsageEnded(){ MixpanelService.track(APP_USAGE_BEGAN) }
    
    class func trackSearchFor( query:String ){
        MixpanelService.track( USER_SEARCHED, properties: [
                "query": query
            ])
    }
    
    class func trackUserMade( swipe:Swipe ){
        let emotion = swipe.feeling
        MixpanelService.track("USER_SWIPED", properties: [
            "emotion": emotion
            ])
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
     Updates the count of posts made by the user and tracks the feeling and privacy of the post
     
     - parameter post: The post to track
     */
    class func trackUserMade( post:Post ){
        MixpanelService.identify(email)
        MixpanelService.people.increment(["POSTS_MADE":1])
        MixpanelService.track("USER_MADE_POST", properties: [
            "Feeling": post.emoji.value().name,
            "private_post": post.isPrivate
            ])
    }
    
    class func trackUserEmpathisesWith( post:Post ){ MixpanelService.track( POST_EMPATHISED ) }
}