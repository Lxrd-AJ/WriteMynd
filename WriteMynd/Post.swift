//
//  Post.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 06/12/2015.
//  Copyright © 2015 The Leaf. All rights reserved.
//

import Foundation

class Post {
    var emoji: String
    var text: String
    var hashTags: [String]
    
    init( emoji:String, text:String, hashTags:[String] ){
        self.emoji = emoji; self.text = text; self.hashTags = hashTags
    }
    
    convenience init(){
        self.init(emoji: "",text: "",hashTags: [])
    }
}
