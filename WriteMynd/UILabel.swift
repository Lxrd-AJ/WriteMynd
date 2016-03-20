//
//  UILabel.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 19/03/2016.
//  Copyright © 2016 The Leaf. All rights reserved.
//

import Foundation

class Label: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.font = UIFont(name: "Montserrat-Regular", size: 15.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeBold(){
        self.font = UIFont(name: "Montserrat-Bold", size: 15.0)
    }
    
    static func font() -> UIFont{
        return UIFont(name: "Montserrat-Regular", size: 15.0)!
    }
    
}


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
}






