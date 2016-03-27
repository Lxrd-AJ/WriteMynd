//
//  Extensions.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 04/12/2015.
//  Copyright © 2015 The Leaf. All rights reserved.
//

import Foundation
import UIKit
import Charts

// Color palette

extension UIColor {
    class func wmCoolBlueColor() -> UIColor {
        return UIColor(red: 87.0 / 255.0, green: 132.0 / 255.0, blue: 199.0 / 255.0, alpha: 1.0)
    }
    class func wmDarkSkyBlue10Color() -> UIColor {
        return UIColor(red: 68.0 / 255.0, green: 179.0 / 255.0, blue: 232.0 / 255.0, alpha: 0.1)
    }
    class func wmSlateGreyColor() -> UIColor {
        return UIColor(red: 84.0 / 255.0, green: 93.0 / 255.0, blue: 103.0 / 255.0, alpha: 1.0)
    }
    class func wmSilverColor() -> UIColor {
        return UIColor(red: 184.0 / 255.0, green: 192.0 / 255.0, blue: 201.0 / 255.0, alpha: 1.0)
    }
    class func wmGreenishTealColor() -> UIColor {
        return UIColor(red: 63.0 / 255.0, green: 208.0 / 255.0, blue: 174.0 / 255.0, alpha: 1.0)
    }
    class func wmBackgroundColor() -> UIColor {
        return UIColor(red: 246/255, green: 247/255, blue: 251/255, alpha: 1)
    }
}

extension UIView{
    
    class func loadFromNibName( nibNamed:String, bundle:NSBundle? = nil ) -> UIView? {
        return UINib(nibName: nibNamed, bundle: bundle).instantiateWithOwner(nil , options: nil)[0] as? UIView
    }
    
    func addBorder(edges edges: UIRectEdge, colour: UIColor = UIColor.whiteColor(), thickness: CGFloat = 1) -> [UIView] {
        
        var borders = [UIView]()
        
        func border() -> UIView {
            let border = UIView(frame: CGRectZero)
            border.backgroundColor = colour
            border.translatesAutoresizingMaskIntoConstraints = false
            return border
        }
        
        if edges.contains(.Top) || edges.contains(.All) {
            let top = border()
            addSubview(top)
            addConstraints(
                NSLayoutConstraint.constraintsWithVisualFormat("V:|-(0)-[top(==thickness)]",
                    options: [],
                    metrics: ["thickness": thickness],
                    views: ["top": top]))
            addConstraints(
                NSLayoutConstraint.constraintsWithVisualFormat("H:|-(0)-[top]-(0)-|",
                    options: [],
                    metrics: nil,
                    views: ["top": top]))
            borders.append(top)
        }
        
        if edges.contains(.Left) || edges.contains(.All) {
            let left = border()
            addSubview(left)
            addConstraints(
                NSLayoutConstraint.constraintsWithVisualFormat("H:|-(0)-[left(==thickness)]",
                    options: [],
                    metrics: ["thickness": thickness],
                    views: ["left": left]))
            addConstraints(
                NSLayoutConstraint.constraintsWithVisualFormat("V:|-(0)-[left]-(0)-|",
                    options: [],
                    metrics: nil,
                    views: ["left": left]))
            borders.append(left)
        }
        
        if edges.contains(.Right) || edges.contains(.All) {
            let right = border()
            addSubview(right)
            addConstraints(
                NSLayoutConstraint.constraintsWithVisualFormat("H:[right(==thickness)]-(0)-|",
                    options: [],
                    metrics: ["thickness": thickness],
                    views: ["right": right]))
            addConstraints(
                NSLayoutConstraint.constraintsWithVisualFormat("V:|-(0)-[right]-(0)-|",
                    options: [],
                    metrics: nil,
                    views: ["right": right]))
            borders.append(right)
        }
        
        if edges.contains(.Bottom) || edges.contains(.All) {
            let bottom = border()
            addSubview(bottom)
            addConstraints(
                NSLayoutConstraint.constraintsWithVisualFormat("V:[bottom(==thickness)]-(0)-|",
                    options: [],
                    metrics: ["thickness": thickness],
                    views: ["bottom": bottom]))
            addConstraints(
                NSLayoutConstraint.constraintsWithVisualFormat("H:|-(0)-[bottom]-(0)-|",
                    options: [],
                    metrics: nil,
                    views: ["bottom": bottom]))
            borders.append(bottom)
        }
        
        return borders
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
        guard self.keys.first != nil else{ return "" }
        return String(self.keys.reduce(self.keys.first! , combine: {
            if (self[$0] as? Int) < (self[$1] as? Int) { return $0 }
            else{ return $1 }
        }))
    }
    
    func maxTuple () -> (Int,Int) {
        //maxTuple ( current_highest, total_value )
        guard self.keys.first != nil else{ return (0,0) }
        return self.keys.reduce((self[self.keys.first!] as! Int, 0), combine: { (var tuple:(Int,Int), curKey) in
            let _curKey = self[curKey] as! Int
            if _curKey > tuple.0 { tuple.0 = _curKey }
            tuple.1 += _curKey
            return tuple
        })
    }
    
    func maxPercent () -> Int {
        let maxTuple: (highest:Int,total:Int) = self.maxTuple()
        return Int((Float(maxTuple.highest) / Float(maxTuple.total)) * Float(100))
    }
    
    func minTuple () -> (Int,Int) {
        //minTuple ( current_lowest, total_value )
        guard self.keys.first != nil else{ return (0,0) }
        return self.keys.reduce((self[self.keys.first!] as! Int, 0), combine: { (var tuple:(Int,Int), curKey) in
            let _curKey = self[curKey] as! Int
            if _curKey < tuple.0 { tuple.0 = _curKey }
            tuple.1 += _curKey
            return tuple
        })
    }
    
    func minPercent () -> Int {
        let minTuple: (lowest:Int,total:Int) = self.minTuple()
        return Int((Float(minTuple.lowest) / Float(minTuple.total)) * Float(100))
    }
}

extension Dictionary {
    func keys() -> [Key]{
        return [Key](self.keys)
    }
}



/**
 Extensions to shuffle an array
 */
extension CollectionType {
    /// Return a copy of `self` with its elements shuffled
    func shuffle() -> [Generator.Element] {
        var list = Array(self)
        list.shuffleInPlace()
        return list
    }
}
extension MutableCollectionType where Index == Int {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffleInPlace() {
        // empty and single-element collections don't shuffle
        if count < 2 { return }
        
        for i in 0..<count - 1 {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
}

extension Array where Element: EmpathisedPost {
    
    func containsPost( post:Post ) -> Bool {
        var result = false
        for emPost in self {
            if emPost.postID == post.ID{
                result = true
                break
            }
        }
        return result
    }
}


class LineXAxis: ChartXAxisValueFormatter {
    @objc func stringForXValue(index: Int, original: String, viewPortHandler: ChartViewPortHandler) -> String {
        let double = Double(original)
        guard double != nil else { return original }
        return String(Int(double!))
    }
}

