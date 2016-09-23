//
//  SwipeOnBoarding.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 28/03/2016.
//  Copyright © 2016 The Leaf. All rights reserved.
//

import UIKit

class SwipeOnBoarding: UIView {
    
    lazy var promptLabel: Label = {
        let label = Label()
        label.textColor = UIColor.wmSilverColor()
        label.text = "Which of these emotions do you feel right now?"
        label.setFontSize(20.0)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var instructionLabel: Label = {
        let label = Label()
        label.textColor = UIColor.wmCoolBlueColor()
        label.text = "Swipe left and right on the cards"
        label.setFontSize(13.0)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(promptLabel)
        promptLabel.snp_makeConstraints(closure: { make in
            make.centerX.equalTo(self.snp_centerX)
            make.top.equalTo(self.snp_top).offset(5)
            make.width.equalTo(self.snp_width).offset(-20)
        })
        
        self.addSubview(instructionLabel)
        instructionLabel.snp_makeConstraints(closure: { make in
            make.top.equalTo(promptLabel.snp_bottom).offset(15)
            make.centerX.equalTo(self.snp_centerX)
            make.width.equalTo(self.snp_width).offset(-40)
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
