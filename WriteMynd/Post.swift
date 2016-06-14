//
//  Post.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 06/12/2015.
//  Copyright © 2015 The Leaf. All rights reserved.
//

import Foundation
import Parse

class Post {
    
    var ID: String?
    var emoji: Emoji
    var text: String
    var hashTags: [String]
    var isPrivate: Bool = true //TODO: Discard booleans and use PFACL to enforce constraints
    var author: PFUser
    var createdAt: NSDate?
    var updatedAt: NSDate?
    var isEmpathised: Bool //Used locally to determine if the current user has empathised the post
    var reportCount: Int
    
    init( emoji:Emoji, text:String, hashTags:[String] , author:PFUser ){
        self.emoji = emoji;
        self.isEmpathised = false
        self.text = text; self.hashTags = hashTags; self.author = author
        self.reportCount = 0
    }
    
    /**
     Saves the current object by creating a new one if the object doesn't exists i.e ID is nil or updates the 
     current object on the server
     */
    func save() {
        var postData: PFObject
        if self.ID != nil { //Update the object
            postData = PFObject(withoutDataWithClassName: "Post", objectId: self.ID)
        }else{
            postData = PFObject(className: "Post")
            self.ID = postData.objectId
        }
        
        postData["emoji"] = self.emoji.value().name
        postData["text"] = self.text
        postData["hashTags"] = self.hashTags
        postData["private"] = self.isPrivate
        postData["parent"] = author
        postData["reportCount"] = self.reportCount
        
        postData.saveInBackground()
    }
    
    func delete(){
        if let id = self.ID {
            PFObject(withoutDataWithClassName: "Post", objectId: id).deleteInBackground()
        }
    }
    
    class func convertPFObjectToPost( postObj:PFObject ) -> Post {
        let emojiText = postObj["emoji"] as! String
        var emoji:Emoji
        if emojiText == "🙂"{ //Temporary Hack for Testing
            emoji = Emoji.Happy
        }else{
            emoji = Emoji.toEnum(emojiText)
        }
        let text = postObj["text"] as! String
        let hashTags = postObj["hashTags"] as! [String]
        let isPrivate = postObj["private"] as! Bool
        let author = postObj["parent"] as! PFUser
        let post = Post(emoji: emoji, text: text, hashTags: hashTags, author: author)
        post.isPrivate = isPrivate
        post.createdAt = postObj.createdAt
        post.updatedAt = postObj.updatedAt
        post.ID = postObj.objectId
        if let count = postObj["reportCount"] as? Int {
            post.reportCount = count;
        }
        return post
    }
}
