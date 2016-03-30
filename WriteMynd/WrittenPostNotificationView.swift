//
//  WrittenPostNotificationView.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 30/03/2016.
//  Copyright © 2016 The Leaf. All rights reserved.
//

import UIKit

class WrittenPostNotificationView: UIView {

    lazy var imageView: UIImageView = {
        let icon = UIImageView()
        icon.backgroundColor = .lightGrayColor()
        return icon
    }()
    
    lazy var message: Label = {
        let label = Label()
        label.textColor = UIColor.wmCoolBlueColor()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(message)
        message.snp_makeConstraints(closure: { make in
            make.center.equalTo(self.snp_center)
        })
        
        self.addSubview(imageView)
        imageView.snp_makeConstraints(closure: { make in
            make.bottom.equalTo(message.snp_top).offset(-10)
            make.size.equalTo(CGSize(width: 127, height: 127))
            make.centerX.equalTo(self.snp_centerX)
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
