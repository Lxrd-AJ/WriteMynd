//
//  HiddenPost.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 27/03/2016.
//  Copyright © 2016 The Leaf. All rights reserved.
//

import Foundation
import Parse

class HiddenPost {
    var user: PFUser
    var postID: String
    
    init( postID:String, user:PFUser ){
        self.user = user
        self.postID = postID
    }
    
    func save(){
        let object = PFObject(className: "HiddenPost")
        object["user"] = self.user
        object["postID"] = self.postID
        object.saveEventually()
    }
    
    class func convertPFObjectToHiddenPost( object:PFObject ) -> HiddenPost {
        return HiddenPost(postID: object["post"] as! String, user: object["user"] as! PFUser)
    }
}
