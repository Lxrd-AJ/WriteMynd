//
//  DetailTableViewCell.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 27/05/2016.
//  Copyright © 2016 The Leaf. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    
    lazy var countLabel: Label = {
        let label = Label()
        label.textColor = UIColor.wmLightGoldColor()
        label.setFontSize(30)
        label.textAlignment = .center
        label.addBorder(edges: .right, colour: .wmPaleGreyTwoColor(), thickness: 0.9)
        return label;
    }()
    
    lazy var hashtagLabel: Label = {
        let label = Label()
        label.textColor = UIColor.wmSlateGreyColor()
        //label.setFontSize(30)
        return label;
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(countLabel)
        self.contentView.addSubview(hashtagLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        countLabel.snp_makeConstraints(closure: { make in
            make.left.equalTo(self.contentView.snp_left).offset(15)
            make.centerY.equalTo(self.contentView.snp_centerY)
            make.width.greaterThanOrEqualTo(50)
        })
        
        hashtagLabel.snp_makeConstraints(closure: { make in
            make.left.equalTo(countLabel.snp_right).offset(5)
            make.centerY.equalTo(self.contentView.snp_centerY)
        })
    }

}
