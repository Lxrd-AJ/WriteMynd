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
    
    /**
     - todo:
        [ ] Change to use Promises
     */
    class func fetchPostsForUser( user:PFUser, callback:(posts:[Post]) -> Void ) {
        let fetchQuery: PFQuery = PFQuery( className: "Post" )
        //fetchQuery.whereKey("parent", equalTo: user )
        fetchQuery.whereKey("private", notEqualTo: true)
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
        let object = PFObject(withoutDataWithClassName: "EmpathisedPost", objectId: empathisedPost.objectID)
        object.deleteEventually()
    }
    
}