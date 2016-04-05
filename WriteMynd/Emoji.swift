//
//  Emoji.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 19/03/2016.
//  Copyright © 2016 The Leaf. All rights reserved.
//

import Foundation

enum Emoji {
    
    case Happy
    case Sad
    case Angry
    case Scared
    case Meh
    case None
    
    func value() -> (name:String, imageName:String, color:UIColor ){
        switch self {
        case .Happy:
            return (name:"Happy", imageName:"happy", color: UIColor.wmLightGoldColor() )
        default:
            return (name:"", imageName:"", color: UIColor.lightGrayColor() )
        }
    }
    
    static func toEnum( string:String ) -> Emoji {
        switch string {
        case "Happy": return .Happy
        default: return .None
        }
    }
}