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
        case .Sad:
            return (name:"Sad", imageName:"sad", color: UIColor.wmSoftBlueColor() )
        case .Angry:
            return (name:"Angry", imageName:"angry", color: UIColor.wmOrangePinkColor() )
        case .Scared:
            return (name:"Scared", imageName:"fear", color: UIColor.wmGreenishTealTwoColor() )
        case .Meh:
            return (name:"Meh", imageName:"meh", color: UIColor.wmSilverTwoColor() )
        default:
            return (name:"", imageName:"", color: UIColor.lightGrayColor() )
        }
    }
    
    static func toEnum( string:String ) -> Emoji {
        switch string {
            case "Happy": return .Happy
            case "Sad": return .Sad
            case "Angry": return .Angry
            case "Scared": return .Scared
            case "Meh": return .Meh
            case "None": return .None
        default: return .None
        }
    }
}