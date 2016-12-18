//
//  EmojiDetailHeaderView.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 27/05/2016.
//  Copyright © 2016 The Leaf. All rights reserved.
//

import UIKit

class EmojiDetailHeaderView: UIView {
    
    lazy var header: Label = {
        let label = Label()
        label.text = ""
        label.textColor = UIColor.white
        label.layer.cornerRadius = 16.0
        label.layer.masksToBounds = true
        label.textAlignment = .center
        return label;
    }()
    lazy var promptLabel: Label = {
        let label = Label()
        label.text = "Stuff that made me"
        label.textColor = UIColor.wmCoolBlueColor()
        return label;
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.wmBackgroundColor()
        self.addSubview(promptLabel)
        self.addSubview(header)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        promptLabel.snp.makeConstraints({ make in
            //make.top.equalTo(self.snp.top).offset(15)
            make.centerY.equalTo(self.snp.centerY)
            make.left.equalTo(self.snp.left).offset(15)
        })
        
        header.snp.makeConstraints({ make in
            //make.top.equalTo(promptLabel.snp.top)
            make.left.equalTo(promptLabel.snp.right).offset(6)
            make.width.greaterThanOrEqualTo(100)
            make.height.greaterThanOrEqualTo(30)
            make.centerY.equalTo(self.snp.centerY)
        })
    }

}
