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

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}


extension UIView {

    class func loadFromNibName( _ nibNamed: String, bundle: Bundle? = nil) -> UIView? {
        return UINib(nibName: nibNamed, bundle: bundle).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }

    func addBorder(edges: UIRectEdge, colour: UIColor = UIColor.white, thickness: CGFloat = 1) -> [UIView] {

        var borders = [UIView]()

        func border() -> UIView {
            let border = UIView(frame: CGRect.zero)
            border.backgroundColor = colour
            border.translatesAutoresizingMaskIntoConstraints = false
            return border
        }

        if edges.contains(.top) || edges.contains(.all) {
            let top = border()
            addSubview(top)
            addConstraints(
                           NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[top(==thickness)]",
                                                          options: [],
                                                          metrics: ["thickness": thickness],
                                                          views: ["top": top]))
            addConstraints(
                           NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[top]-(0)-|",
                                                          options: [],
                                                          metrics: nil,
                                                          views: ["top": top]))
            borders.append(top)
        }

        if edges.contains(.left) || edges.contains(.all) {
            let left = border()
            addSubview(left)
            addConstraints(
                           NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[left(==thickness)]",
                                                          options: [],
                                                          metrics: ["thickness": thickness],
                                                          views: ["left": left]))
            addConstraints(
                           NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[left]-(0)-|",
                                                          options: [],
                                                          metrics: nil,
                                                          views: ["left": left]))
            borders.append(left)
        }

        if edges.contains(.right) || edges.contains(.all) {
            let right = border()
            addSubview(right)
            addConstraints(
                           NSLayoutConstraint.constraints(withVisualFormat: "H:[right(==thickness)]-(0)-|",
                                                          options: [],
                                                          metrics: ["thickness": thickness],
                                                          views: ["right": right]))
            addConstraints(
                           NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[right]-(0)-|",
                                                          options: [],
                                                          metrics: nil,
                                                          views: ["right": right]))
            borders.append(right)
        }

        if edges.contains(.bottom) || edges.contains(.all) {
            let bottom = border()
            addSubview(bottom)
            addConstraints(
                           NSLayoutConstraint.constraints(withVisualFormat: "V:[bottom(==thickness)]-(0)-|",
                                                          options: [],
                                                          metrics: ["thickness": thickness],
                                                          views: ["bottom": bottom]))
            addConstraints(
                           NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[bottom]-(0)-|",
                                                          options: [],
                                                          metrics: nil,
                                                          views: ["bottom": bottom]))
            borders.append(bottom)
        }

        return borders
    }
}

extension Dictionary where Value: ExpressibleByIntegerLiteral, Key: ExpressibleByStringLiteral {
    func max() -> String {
//        var maxValue: Int = -1; var maxKey: String = "";
//        for key in self.keys {
//            if (self[key] as? Int) > maxValue { maxValue = (self[key] as? Int)!; maxKey = String(key); }
//        }
//        return maxKey
        guard self.keys.first != nil else { return "" }
//        return String(self.keys.reduce(self.keys.first! , combine: {
//            if (self[$0] as? Int) > (self[$1] as? Int) { return $0 }
//            else{ return $1 }
//        }))
        return self.keys().sorted { s1, s2 in return (self[s1] as? Int) > (self[s2] as? Int) }.first! as! String
    }

    func min() -> String {
        guard self.keys.first != nil else { return "" }
        return String(describing: self.keys.reduce(self.keys.first!, {
            if (self[$0] as? Int) < (self[$1] as? Int) { return $0 }
                else { return $1 }
        }))
    }

    func maxTuple () -> (Int, Int) {
        //maxTuple ( current_highest, total_value )
        guard self.keys.first != nil else { return (0, 0) }
        return self.keys.reduce((self[self.keys.first!] as! Int, 0), { (_tuple: (Int, Int), curKey) in
            var tuple = _tuple;
            let _curKey = self[curKey] as! Int
            if _curKey > tuple.0 { tuple.0 = _curKey }
            tuple.1 += _curKey
            return tuple
        })
    }


    func maxPercent () -> Int {
        let maxTuple: (highest: Int, total: Int) = self.maxTuple()
        return Int((Float(maxTuple.highest) / Float(maxTuple.total)) * Float(100))
    }

    func minTuple () -> (Int, Int) {
        //minTuple ( current_lowest, total_value )
        guard self.keys.first != nil else { return (0, 0) }
        return self.keys.reduce((self[self.keys.first!] as! Int, 0), { (_tuple: (Int, Int), curKey) in
            var tuple = _tuple;
            let _curKey = self[curKey] as! Int
            if _curKey < tuple.0 { tuple.0 = _curKey }
            tuple.1 += _curKey
            return tuple
        })
    }

    func minPercent () -> Int {
        let minTuple: (lowest: Int, total: Int) = self.minTuple()
        return Int((Float(minTuple.lowest) / Float(minTuple.total)) * Float(100))
    }
}

extension Dictionary {
    func keys() -> [Key] {
        return [Key](self.keys)
    }
}



/**
 Extensions to shuffle an array
 */
extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Iterator.Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}


extension MutableCollection where Indices.Iterator.Element == Index {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled , unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            guard d != 0 else { continue }
            let i = index(firstUnshuffled, offsetBy: d)
            swap(&self[firstUnshuffled], &self[i])
        }
    }
}

extension Array where Element: EmpathisedPost {

    func containsPost( _ post: Post) -> Bool {
        var result = false
        for emPost in self {
            if emPost.postID == post.ID {
                result = true
                break
            }
        }
        return result
    }
}


//class LineXAxis: ChartXAxisValueFormatter {
//    @objc func stringForXValue(_ index: Int, original: String, viewPortHandler: ViewPortHandler) -> String {
//        let double = Double(original)
//        guard double != nil else { return original }
//        return String(Int(double!))
//    }
//}

