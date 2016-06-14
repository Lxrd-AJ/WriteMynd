//
//  UIButton.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 02/06/2016.
//  Copyright © 2016 The Leaf. All rights reserved.
//

import Foundation
import UIKit

class Button: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 15.0)!
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setFontSize( size:CGFloat ){
        self.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: size)!
    }
        
    class func buttonWithImage(title:String, imageName:String, fontSize:CGFloat = 16) -> Button{
        let button: Button = Button()
        button.setTitle(title, forState: .Normal)
        button.setImage(UIImage(named: imageName)!, forState: .Normal)
        button.setFontSize(fontSize)
        
        button.titleLabel?.snp_makeConstraints(closure: { make in
            make.left.equalTo(button.snp_left).offset(10)
            make.width.equalTo(button.snp_width).multipliedBy(0.7)
        })
        button.imageView?.contentMode = .Center;
        button.imageView?.snp_makeConstraints(closure: { make in
            make.right.equalTo(button.snp_right).offset(-10)
            make.width.equalTo(button.snp_width).multipliedBy(0.2)
        })
        return button;
    }
}
