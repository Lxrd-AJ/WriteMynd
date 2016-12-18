//
//  FeelingsView.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 23/03/2016.
//  Copyright © 2016 The Leaf. All rights reserved.
//

import UIKit
import SZTextView

class FeelingsView: UIView {
    
    lazy var promptMessage: Label = {
        var label = Label()
        label.text = "Write a Post"
        label.textColor = UIColor.wmCoolBlueColor()
        return label
    }()
    
    lazy var feelingsTextView: SZTextView = {
        let textView = SZTextView()
        textView.font = Label.font()
        textView.textColor = UIColor.wmSlateGreyColor()
        textView.delegate = self
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.lightGray.cgColor

        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(promptMessage)
        self.addSubview(feelingsTextView)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }
    
    func setupConstraints() -> Void {
        self.promptMessage.snp.makeConstraints({ make in
            make.top.equalTo(self.snp.top)
            make.left.equalTo(self.snp.leftMargin)
        })
        self.feelingsTextView.snp.makeConstraints({make in
            make.top.equalTo(self.promptMessage.snp.bottom)
            make.width.equalTo(self.snp.width).offset(-20)
            make.centerX.equalTo(self.snp.centerX)
            make.height.equalTo(150)
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FeelingsView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        textView.isUserInteractionEnabled = true
        textView.isEditable = true
        textView.isScrollEnabled = true
        return true
    }
}
