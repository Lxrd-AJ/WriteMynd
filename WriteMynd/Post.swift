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
    var isPrivate: Bool = true
    var author: PFUser
    var createdAt: NSDate?
    var updatedAt: NSDate?
    var isEmpathised: Bool //Used locally to determine if the current user has empathised the post
    
    init( emoji:Emoji, text:String, hashTags:[String] , author:PFUser ){
        self.emoji = emoji;
        self.isEmpathised = false
        self.text = text; self.hashTags = hashTags; self.author = author
    }
    
    func save() {
        let postData: PFObject = PFObject(className: "Post")
        postData["emoji"] = self.emoji.value().name
        postData["text"] = self.text
        postData["hashTags"] = self.hashTags
        postData["private"] = self.isPrivate
        postData["parent"] = author
        self.ID = postData.objectId
        postData.saveInBackground()
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
        return post
    }
}
