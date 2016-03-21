//
//  HashTagView.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 21/03/2016.
//  Copyright © 2016 The Leaf. All rights reserved.
//

import UIKit
import SnapKit

class HashTagView: UIView {
    
    lazy var hashtagField: UITextField = {
        let field = UITextField()
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 30))
        field.placeholder = dailyQuestion[Int( arc4random_uniform(UInt32(dailyQuestion.count)))]
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.lightGrayColor().CGColor
        field.font = Label.font()
        field.backgroundColor = UIColor.whiteColor()
        field.adjustsFontSizeToFitWidth = true
        field.leftView = paddingView
        field.leftViewMode = .Always
        //field.delegate = self
        field.tag = 10
        return field
    }()
    lazy var promptMessage: Label = {
        var label = Label()
        label.text = "Create a hashtag"
        label.textColor = UIColor.wmCoolBlueColor()
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
