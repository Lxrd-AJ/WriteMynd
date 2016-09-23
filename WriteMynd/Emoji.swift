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
    
    case happy
    case sad
    case angry
    case scared
    case meh
    case none
    
    func value() -> (name:String, imageName:String, color:UIColor, imageNameLarge:String ){
        switch self {
        case .happy:
            return (name:"Happy", imageName:"happy", color: UIColor.wmLightGoldColor(), imageNameLarge:"happy-large" )
        case .sad:
            return (name:"Sad", imageName:"sad", color: UIColor.wmSoftBlueColor(), imageNameLarge:"sad-large" )
        case .angry:
            return (name:"Angry", imageName:"angry", color: UIColor.wmOrangePinkColor(), imageNameLarge:"angry-large" )
        case .scared:
            return (name:"Scared", imageName:"fear", color: UIColor.wmGreenishTealTwoColor(), imageNameLarge:"fear-large" )
        case .meh:
            return (name:"Meh", imageName:"meh", color: UIColor.wmSilverTwoColor(), imageNameLarge:"mEHH" )
        default:
            return (name:"Smiley", imageName:"", color: UIColor.lightGray, imageNameLarge:"" )
        }
    }
    
    static func toEnum( _ string:String ) -> Emoji {
        switch string {
            case "Happy": return .happy
            case "Sad": return .sad
            case "Angry": return .angry
            case "Scared": return .scared
            case "Meh": return .meh
            case "None": return .none
        default: return .none
        }
    }
}
