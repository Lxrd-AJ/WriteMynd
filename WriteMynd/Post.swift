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
    var emoji: String //TODO: Change to Character, //TODO_FOR_TODO: Change from Character to a Custom Struct Emoji
    var text: String
    var hashTags: [String]
    var isPrivate: Bool = true
    var author: PFUser
    var createdAt: NSDate?
    var updatedAt: NSDate?
    
    init( emoji:String, text:String, hashTags:[String] , author:PFUser ){
        self.emoji = emoji; self.text = text; self.hashTags = hashTags; self.author = author
    }
    
    convenience init(){
        self.init(emoji: "",text: "",hashTags: [], author:PFUser())
    }
    
    func save() {
        let postData: PFObject = PFObject(className: "Post")
        postData["emoji"] = self.emoji
        postData["text"] = self.text
        postData["hashTags"] = self.hashTags
        postData["private"] = self.isPrivate
        postData["parent"] = author
        postData.saveInBackground()
    }
    
    class func convertPFObjectToPost( postObj:PFObject ) -> Post {
        let emoji = postObj["emoji"] as! String
        let text = postObj["text"] as! String
        let hashTags = postObj["hashTags"] as! [String]
        let isPrivate = postObj["private"] as! Bool
        let author = postObj["parent"] as! PFUser
        let post = Post(emoji: emoji, text: text, hashTags: hashTags, author: author)
        post.isPrivate = isPrivate
        post.createdAt = postObj.createdAt
        post.updatedAt = postObj.updatedAt
        return post
    }
}
