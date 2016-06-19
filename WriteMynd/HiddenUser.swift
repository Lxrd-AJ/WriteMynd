//
//  HiddenUser.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 15/06/2016.
//  Copyright © 2016 The Leaf. All rights reserved.
//

import Foundation
import Parse

class HiddenUser {
    var blockedUser: PFUser
    var user:PFUser
    
    init( blockedUser:PFUser, user:PFUser ){
        self.user = user
        self.blockedUser = blockedUser
    }
    
    func save(){
        let object = PFObject(className: "HiddenUser")
        object["user"] = self.user
        object["blockedUser"] = self.blockedUser
        object.saveEventually()
    }
    
    class func convertPFObjectToHiddenUser( object:PFObject ) -> HiddenUser {
        return HiddenUser(blockedUser: object["blockedUser"] as! PFUser, user: object["user"] as! PFUser)
    }
}
