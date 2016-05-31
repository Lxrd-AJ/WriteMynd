//
//  WrittenPostNotificationView.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 30/03/2016.
//  Copyright © 2016 The Leaf. All rights reserved.
//

import UIKit

class WrittenPostNotificationView: UIView {

//    lazy var loadingIndicator: UIImageView = {
//        let indictator = UIImageView()
//        indictator.animationImages = ["blueEllipses1","blueEllipses2"].map({ return UIImage(named: $0)! })
//        indictator.animationDuration = 1.5
//        indictator.contentMode = .Center
//        return indictator
//    }()
    
    lazy var imageView: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "cloudFinal")
        icon.animationDuration = 1.75
        icon.animationRepeatCount = 1
        icon.animationImages = ["cloud","cloud1","cloud2","cloud3","cloud"].map({ return UIImage(named: $0)! })
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
            make.size.equalTo(CGSize(width: 121, height: 98))
            make.centerX.equalTo(self.snp_centerX)
        })
        imageView.startAnimating()
//        imageView.addSubview(loadingIndicator)
//        loadingIndicator.snp_makeConstraints(closure: { make in
//            make.center.equalTo(imageView.snp_center)
//            make.size.equalTo(CGSize(width: 50, height: 15))
//        })
//        loadingIndicator.startAnimating()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
