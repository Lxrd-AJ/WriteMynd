//
//  Extensions.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 04/12/2015.
//  Copyright © 2015 The Leaf. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    class func loadFromNibName( nibNamed:String, bundle:NSBundle? = nil ) -> UIView? {
        return UINib(nibName: nibNamed, bundle: bundle).instantiateWithOwner(nil , options: nil)[0] as? UIView
    }
}

extension Dictionary where Value: IntegerLiteralConvertible, Key: StringLiteralConvertible {
    func max() -> String {
        var maxValue: Int = -1; var maxKey: String = "";
        for key in self.keys {
            if (self[key] as? Int) > maxValue { maxValue = (self[key] as? Int)!; maxKey = String(key); }
        }
        return maxKey
    }
    
    func min() -> String {
        return String(self.keys.reduce(self.keys.first, combine: {
            if (self[$0!] as? Int) < (self[$1] as? Int) { return $0 }
            else{ return $1 }
        }))
    }
}