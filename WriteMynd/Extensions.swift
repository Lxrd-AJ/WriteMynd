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




class LineXAxis: ChartXAxisValueFormatter {
    @objc func stringForXValue(index: Int, original: String, viewPortHandler: ChartViewPortHandler) -> String {
        let double = Double(original)
        guard double != nil else { return original }
        return String(Int(double!))
    }
}

