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
    
    init( value:Int, feeling:String ){
        self.value = value
        self.feeling = feeling
        self.author = PFUser.currentUser()! //By default, you have to be signed in to make a post
    }
    
    func save(){        
        let swipeObj: PFObject = PFObject(className: "Swipe")
        swipeObj["value"] = self.value
        swipeObj["feeling"] = self.feeling
        swipeObj["parent"] = self.author
        swipeObj.saveInBackground()
    }
}
