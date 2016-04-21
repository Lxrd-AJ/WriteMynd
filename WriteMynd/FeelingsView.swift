//
//  FeelingsView.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 23/03/2016.
//  Copyright © 2016 The Leaf. All rights reserved.
//

import UIKit

class FeelingsView: UIView {

    var onFinishCallback: (() -> Void)?
    
    lazy var promptMessage: Label = {
        var label = Label()
        label.text = "Write a Post"
        label.textColor = UIColor.wmCoolBlueColor()
        return label
    }()
    
    lazy var feelingsTextView: UITextView = {
        let textView = UITextView()
        textView.font = Label.font()
        textView.tintColor = UIColor.blueColor()
        textView.textColor = UIColor.wmSlateGreyColor()
        textView.delegate = self
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.lightGrayColor().CGColor
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(promptMessage)
        self.addSubview(feelingsTextView)
    }
    
    func setupConstraints() -> Void {
        self.promptMessage.snp_makeConstraints(closure: { make in
            make.top.equalTo(self.snp_top)
            make.left.equalTo(self.snp_leftMargin)
        })
        self.feelingsTextView.snp_makeConstraints(closure: {make in
            make.top.equalTo(self.promptMessage.snp_bottom)
            make.width.equalTo(self.snp_width).offset(-20)
            make.centerX.equalTo(self.snp_centerX)
            make.height.equalTo(100)
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension FeelingsView: UITextViewDelegate {
    
    func textViewDidBeginEditing(textView: UITextView) {
        textView.tintColor = UIColor.blueColor()
        print("Textfield did begin editing")
    }
    /**
     - note: http://stackoverflow.com/questions/703754/how-to-dismiss-keyboard-for-uitextview-with-return-key
     */
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            textView.resignFirstResponder()
            onFinishCallback?()
            return false
        }
        return true;
    }
}