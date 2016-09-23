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
        label.text = "Categorise your post"
        label.textColor = UIColor.wmCoolBlueColor()
        return label
    }()
    
    lazy var hashtagField: UITextField = {
        let field = UITextField()
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 30))
        field.placeholder = ""
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.font = Label.font()
        field.backgroundColor = UIColor.white
        field.adjustsFontSizeToFitWidth = true
        field.leftView = paddingView
        field.leftViewMode = .always
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == " " {
            textField.text = textField.text! + "#"
            
            let start = textField.position(from: textField.beginningOfDocument, offset: range.location+1)
            let end = textField.position(from: start!, offset: range.length)
            let _range = textField.textRange(from: start!, to: end!)
            
            textField.selectedTextRange = _range            
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.onFinishCallback?()
        return true
    }
}
