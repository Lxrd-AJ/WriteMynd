//
//  EmpathisedPost.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 19/03/2016.
//  Copyright © 2016 The Leaf. All rights reserved.
//

import Foundation
import Parse

class EmpathisedPost {
    
    var user: PFUser
    var postID: String
    var likedDate: NSDate?
    var objectID: String?
    
    init( user:PFUser, ID:String ){
        self.user = user;
        self.postID = ID
    }
    
    func save() {
        let object = PFObject(className: "EmpathisedPost")
        object["user"] = self.user
        object["postID"] = self.postID
        self.objectID = object.objectId
        object.saveInBackground()
    }
    
    class func convertPFObjectToEmpathisedPost( object:PFObject ) -> EmpathisedPost {
        let empathisedPost = EmpathisedPost(user: object["user"] as! PFUser, ID: object["postID"] as! String)
        empathisedPost.likedDate = object.createdAt
        empathisedPost.objectID = object.objectId
        return empathisedPost
    }
    
}