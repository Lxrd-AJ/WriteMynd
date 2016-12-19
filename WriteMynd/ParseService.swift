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
    
    class func getSwipesForUser( _ user:PFUser, callback:@escaping (_ swipes:[Swipe]) -> Void ) -> Void {
        let query = PFQuery(className: "Swipe")
        query.whereKey("parent", equalTo: user)
        query.order(byDescending: "createdAt")
        query.limit = 1000;
        query.findObjectsInBackground(block: { (swipes:[PFObject]?, error:Error?) -> Void in
            if let objects = swipes {
                callback(objects.map(Swipe.convertToSwipe) )
            }else{ callback([]) }
        })
    }
    
    // -TODO: Do not fetch private posts
    class func getPostsWith( _ hashTags:[String], callback:@escaping (_ posts:[Post]) -> Void, forUser:PFUser? ){
        let query = PFQuery(className: "Post")
        query.whereKey("hashTags", containedIn: hashTags)
        //query.whereKey("hashTags", containsAllObjectsInArray: hashTags)
        if let user = forUser {
            query.whereKey("parent", equalTo: user)
        }
        query.order(byDescending: "createdAt")
        query.findObjectsInBackground(block: { (posts:[PFObject]?, error:Error?) -> Void in
            if let objects = posts {
                callback(objects.map( Post.convertPFObjectToPost ) )
            }else{ callback([]) }
        })
    }
    
    class func fetchPostsForUser( _ user:PFUser, callback:@escaping (_ posts:[Post]) -> Void ) {
        let fetchQuery: PFQuery = PFQuery( className: "Post" )
        fetchQuery.whereKey("parent", equalTo: user)
        fetchQuery.order(byDescending: "createdAt")
        fetchQuery.findObjectsInBackground(block: { (posts:[PFObject]?, error:Error?) -> Void in
            if let postObjs = posts { callback(postObjs.map( Post.convertPFObjectToPost ) ) }
            else{ callback([]) }
        })
    }
    
    class func fetchPostsForUserFeed( _ user:PFUser?, callback:@escaping (_ posts:[Post]) -> Void ) {
        guard user != nil else{ return; }
        let fetchQuery: PFQuery = PFQuery( className: "Post" )
        let hiddenPostsQuery: PFQuery = PFQuery( className: "HiddenPost")
        let hiddenUserQuery = PFQuery(className: "HiddenUser")
        let reportedPostsQuery = PFQuery(className: "ReportedPost")
        hiddenPostsQuery.whereKey("user", equalTo: user!)
        hiddenUserQuery.whereKey("user", equalTo: user!)
        fetchQuery.whereKey("private", notEqualTo: true)
        fetchQuery.whereKey("objectId", doesNotMatchKey: "postID", in: hiddenPostsQuery)
        fetchQuery.whereKey("objectId", doesNotMatchKey: "postID", in: reportedPostsQuery)
        fetchQuery.whereKey("parent", doesNotMatchKey: "blockedUser", in: hiddenUserQuery) //Do not include posts from blocked users
        fetchQuery.order(byDescending: "createdAt")
        fetchQuery.findObjectsInBackground(block: { (posts:[PFObject]?, error:Error?) -> Void in
            if let postObjs = posts { callback(postObjs.map( Post.convertPFObjectToPost ) ) }
            else{ callback([]) }
        })
    }
    
    class func fetchPrivatePostsForUser( _ user:PFUser, callback:@escaping (_ posts:[Post]) -> Void ) {
        let fetchQuery: PFQuery = PFQuery( className: "Post" )
        fetchQuery.whereKey("parent", equalTo: user)
        fetchQuery.whereKey("private", equalTo: true)
        fetchQuery.order(byDescending: "createdAt")
        fetchQuery.findObjectsInBackground(block: { (posts:[PFObject]?, error:Error?) -> Void in
            if let postObjs = posts { callback(postObjs.map( Post.convertPFObjectToPost ) ) }
            else{ callback([]) }
        })
    }
    
    class func fetchEmpathisedPosts( _ user:PFUser?, callback:@escaping (_ empathisesPosts:[EmpathisedPost]) -> Void ){
        guard user != nil else{ return; }
        let query = PFQuery(className: "EmpathisedPost")
        query.whereKey("userID", equalTo: user!.objectId!)
        query.findObjectsInBackground(block: { (emPosts:[PFObject]?, error:Error?) -> Void in
            if let posts = emPosts {
                callback(posts.map(EmpathisedPost.convertPFObjectToEmpathisedPost))
            }else{ callback([]) }
        })
    }
    
    class func dempathisePost( _ empathisedPost:EmpathisedPost ){
        PFObject(withoutDataWithClassName: "EmpathisedPost", objectId: empathisedPost.objectID).deleteInBackground()
    }
    
}
