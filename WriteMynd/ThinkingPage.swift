//
//  ThinkingPage.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 30/04/2016.
//  Copyright © 2016 The Leaf. All rights reserved.
//

import UIKit

/**
 - todo:
    [ ] Images in the attributed strings http://stackoverflow.com/questions/19318421/how-to-embed-small-icon-in-uilabel
 */
class ThinkingPage: UIView {
    
    lazy var header: UIView = UIView()
    
    lazy var page1TitleLabel: Label = {
        let label: Label = Label()
        label.textColor = .whiteColor()
        let attributedString = NSMutableAttributedString(string: "Write Mynd \nThe thinking", attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.wmFrenchBlueColor(), range: NSRange(location: 10, length: 14))
        label.attributedText = attributedString
        label.setFontSize(21)
        label.numberOfLines = 0
        return label
    }()
    lazy var page1SubTitle: Label = {
        let label:Label = Label()
        label.text = "An app for recording,\nreflecting and sharing for\na clearer mind"
        label.setFontSize(17)
        label.numberOfLines = 0;
        label.textColor = UIColor.whiteColor()
        return label
    }()
    lazy var page1Mascot: UIImageView = {
        return self.createImageView("happyJumpingGuy")
    }()
    lazy var page1Message: Label = {
        let label:Label = Label()
        label.numberOfLines = 0
        label.font = UIFont(name: "Baskerville", size: 17)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(header)
        self.addSubview(page1Message)
        
        header.addSubview(page1TitleLabel)
        header.addSubview(page1SubTitle)
        header.addSubview(page1Mascot)
        
        header.backgroundColor = UIColor.wmDarkSkyBlueColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        header.snp_makeConstraints(closure: { make in
            make.top.equalTo(self.snp_top)
            make.width.equalTo(self.snp_width)
            make.height.equalTo(180)
        })
        
        page1TitleLabel.snp_makeConstraints(closure: { make in
            make.top.equalTo(header.snp_top).offset(5)
            make.left.equalTo(header.snp_left).offset(5)
        })
        
        page1SubTitle.snp_makeConstraints(closure: { make in
            make.bottom.equalTo(header.snp_bottom).offset(-5)
            make.left.equalTo(header.snp_left).offset(5)
            make.right.equalTo(self.page1Mascot.snp_left).offset(-5)
        })
        
        page1Mascot.snp_makeConstraints(closure: { make in
            make.right.equalTo(header.snp_right).offset(-5)
            make.bottom.equalTo(header.snp_bottom).offset(-5)
            make.height.equalTo(header.snp_height).offset(-10)
            make.centerY.equalTo(header.snp_centerY)
        })
        
        page1Message.snp_makeConstraints(closure: { make in
            make.top.equalTo(header.snp_bottom).offset(5)
            make.width.equalTo(self.snp_width).offset(-20)
            make.centerX.equalTo(self.snp_centerX)
        })
        
        self.snp_makeConstraints(closure: { make in
            make.bottom.equalTo(page1Message.snp_bottom)
        })
    }
    
    func createImageView( imageName:String ) -> UIImageView {
        let imageView: UIImageView = UIImageView(image: UIImage(named: imageName))
        imageView.contentMode = .ScaleAspectFit
        return imageView
    }
}
