//
//  ParseService.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 10/12/2015.
//  Copyright © 2015 The Leaf. All rights reserved.
//

import Foundation
import Parse

class ParseService {
    
    class func fetchPostsForUser( user:PFUser, callback:(posts:[Post]) -> Void ) {
        let fetchQuery: PFQuery = PFQuery( className: "Post" )
        fetchQuery.whereKey("parent", equalTo: user )
        fetchQuery.orderByDescending("createdAt")
        fetchQuery.findObjectsInBackgroundWithBlock({ (posts:[PFObject]?, error:NSError?) -> Void in
            if let postObjs = posts { callback(posts: postObjs.map( Post.convertPFObjectToPost ) ) }
            else{ callback(posts: []) }
        })
    }
}