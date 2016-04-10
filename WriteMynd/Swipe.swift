//
//  Swipe.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 03/02/2016.
//  Copyright © 2016 The Leaf. All rights reserved.
//

import Foundation
import Parse

struct Swipe {
    var value: Int
    var feeling: String
    var author: PFUser
    var createdAt: NSDate
    
    init( value:Int, feeling:String ){
        self.value = value
        self.feeling = feeling
        self.author = PFUser.currentUser()! //By default, you have to be signed in to make a post
        self.createdAt = NSDate()
    }
    
    func save(){        
        let swipeObj: PFObject = PFObject(className: "Swipe")
        swipeObj["value"] = self.value
        swipeObj["feeling"] = self.feeling
        swipeObj["parent"] = self.author
        swipeObj.saveInBackground()
    }
    
    static func convertToSwipe( object:PFObject ) -> Swipe {
        var swipe = Swipe(value: (object["value"] as! Int), feeling: (object["feeling"] as! String) )
        swipe.author = PFUser.currentUser()!
        if let date = object.createdAt { swipe.createdAt = date }
        else{ print("Error No swipe date") }
        return swipe 
    }
}
