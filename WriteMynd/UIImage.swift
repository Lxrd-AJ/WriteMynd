//
//  File.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 28/04/2016.
//  Copyright © 2016 The Leaf. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    static func fromColor( color:UIColor ) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
}
