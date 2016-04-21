//
//  ParseService.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 10/12/2015.
//  Copyright © 2015 The Leaf. All rights reserved.
//

import Foundation
import Parse

/**
    - todo:
        [ ] Use Promises
 */
class ParseService {
    
    class func getSwipesForUser( user:PFUser, callback:(swipes:[Swipe]) -> Void ) -> Void {
        let query = PFQuery(className: "Swipe")
        query.whereKey("parent", equalTo: user)
        query.orderByDescending("createdAt")
        query.limit = 1000;
        query.findObjectsInBackgroundWithBlock({ (swipes:[PFObject]?, error:NSError?) -> Void in
            if let objects = swipes {
                callback(swipes: objects.map(Swipe.convertToSwipe) )
            }else{ callback(swipes: []) }
        })
    }
    
    class func getPostsWith( hashTags:[String], callback:(posts:[Post]) -> Void ){
        let query = PFQuery(className: "Post")
        query.whereKey("hashTags", containedIn: hashTags)
        //query.whereKey("hashTags", containsAllObjectsInArray: hashTags)
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock({ (posts:[PFObject]?, error:NSError?) -> Void in
            if let objects = posts {
                callback(posts: objects.map( Post.convertPFObjectToPost ) )
            }else{ callback(posts: []) }
        })
    }
    
    class func fetchPostsForUser( user:PFUser, callback:(posts:[Post]) -> Void ) {
        let fetchQuery: PFQuery = PFQuery( className: "Post" )
        fetchQuery.whereKey("parent", equalTo: user)
        fetchQuery.orderByDescending("createdAt")
        fetchQuery.findObjectsInBackgroundWithBlock({ (posts:[PFObject]?, error:NSError?) -> Void in
            if let postObjs = posts { callback(posts: postObjs.map( Post.convertPFObjectToPost ) ) }
            else{ callback(posts: []) }
        })
    }
    
    class func fetchPostsForUserFeed( user:PFUser, callback:(posts:[Post]) -> Void ) {
        let fetchQuery: PFQuery = PFQuery( className: "Post" )
        let hiddenPostsQuery: PFQuery = PFQuery( className: "HiddenPost")
        hiddenPostsQuery.whereKey("user", equalTo: user)
        fetchQuery.whereKey("private", notEqualTo: true)
        fetchQuery.whereKey("objectId", doesNotMatchKey: "postID", inQuery: hiddenPostsQuery)
        fetchQuery.orderByDescending("createdAt")
        fetchQuery.findObjectsInBackgroundWithBlock({ (posts:[PFObject]?, error:NSError?) -> Void in
            if let postObjs = posts { callback(posts: postObjs.map( Post.convertPFObjectToPost ) ) }
            else{ callback(posts: []) }
        })
    }
    
    class func fetchPrivatePostsForUser( user:PFUser, callback:(posts:[Post]) -> Void ) {
        let fetchQuery: PFQuery = PFQuery( className: "Post" )
        fetchQuery.whereKey("parent", equalTo: user)
        fetchQuery.whereKey("private", equalTo: true)
        fetchQuery.orderByDescending("createdAt")
        fetchQuery.findObjectsInBackgroundWithBlock({ (posts:[PFObject]?, error:NSError?) -> Void in
            if let postObjs = posts { callback(posts: postObjs.map( Post.convertPFObjectToPost ) ) }
            else{ callback(posts: []) }
        })
    }
    
    class func fetchEmpathisedPosts( user:PFUser, callback:(empathisesPosts:[EmpathisedPost]) -> Void ){
        let query = PFQuery(className: "EmpathisedPost")
        query.whereKey("user", equalTo: user)
        query.findObjectsInBackgroundWithBlock({ (emPosts:[PFObject]?, error:NSError?) -> Void in
            if let posts = emPosts {
                callback(empathisesPosts: posts.map(EmpathisedPost.convertPFObjectToEmpathisedPost))
            }else{ callback(empathisesPosts: []) }
        })
    }
    
    class func dempathisePost( empathisedPost:EmpathisedPost ){
        PFObject(withoutDataWithClassName: "EmpathisedPost", objectId: empathisedPost.objectID).deleteInBackground()
    }
    
}