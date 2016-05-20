//
//  Emoji.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 19/03/2016.
//  Copyright © 2016 The Leaf. All rights reserved.
//

import Foundation
import UIKit

enum Emoji {
    
    case Happy
    case Sad
    case Angry
    case Scared
    case Meh
    case None
    
    func value() -> (name:String, imageName:String, color:UIColor, imageNameLarge:String ){
        switch self {
        case .Happy:
            return (name:"Happy", imageName:"happy", color: UIColor.wmLightGoldColor(), imageNameLarge:"happy-large" )
        case .Sad:
            return (name:"Sad", imageName:"sad", color: UIColor.wmSoftBlueColor(), imageNameLarge:"sad-large" )
        case .Angry:
            return (name:"Angry", imageName:"angry", color: UIColor.wmOrangePinkColor(), imageNameLarge:"angry-large" )
        case .Scared:
            return (name:"Scared", imageName:"fear", color: UIColor.wmGreenishTealTwoColor(), imageNameLarge:"fear-large" )
        case .Meh:
            return (name:"Meh", imageName:"meh", color: UIColor.wmSilverTwoColor(), imageNameLarge:"mEHH" )
        default:
            return (name:"Smiley", imageName:"", color: UIColor.lightGrayColor(), imageNameLarge:"" )
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