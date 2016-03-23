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
    var onFinishCallback: (() ->  Void)?
    
    lazy var promptMessage: Label = {
        var label = Label()
        label.text = "Create a hashtag"
        label.textColor = UIColor.wmCoolBlueColor()
        return label
    }()
    
    lazy var hashtagField: UITextField = {
        let field = UITextField()
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 30))
        field.placeholder = ""
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.lightGrayColor().CGColor
        field.font = Label.font()
        field.backgroundColor = UIColor.whiteColor()
        field.adjustsFontSizeToFitWidth = true
        field.leftView = paddingView
        field.leftViewMode = .Always
        field.delegate = self
        field.textColor = UIColor.wmSlateGreyColor()
        field.tag = 10
        return field
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubViews()
    }
    
    func addSubViews() {
        self.addSubview(promptMessage)
        self.addSubview(hashtagField)
    }
    
    func setupConstraints(){        
        self.promptMessage.snp_makeConstraints(closure: { make in
            make.top.equalTo(self.snp_top)
            make.left.equalTo(self.snp_leftMargin)
        })
        self.hashtagField.snp_makeConstraints(closure: { make in
            make.top.equalTo(self.promptMessage.snp_bottom)
            make.width.equalTo(self.snp_width).offset(-20)
            make.centerX.equalTo(self.snp_centerX)
            make.height.equalTo(45)
        })
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HashTagView: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.onFinishCallback?()
        return true
    }
}
