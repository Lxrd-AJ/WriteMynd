//
//  PostTableViewCell.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 10/12/2015.
//  Copyright © 2015 The Leaf. All rights reserved.
//

import UIKit
import SnapKit
import DOFavoriteButton

class PostTableViewCell: UITableViewCell {

    var emojiImageView: UIImageView = UIImageView()
    var dateLabel: Label = Label()
    var postLabel: Label = Label()
    var hashTagsLabel: Label = Label()
    var isPrivateLabel: Label = Label()
    var ellipsesButton: UIButton = UIButton()
    var empathiseButton: UIButton = UIButton() //DOFavoriteButton = DOFavoriteButton()
    var readMoreButton: Button = Button()
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func layoutSubviews() {
        setupTopSection(self.contentView)
        setupMiddleSection(self.contentView)
        setupBottomSection(self.contentView)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func setupBottomSection( superView:UIView ) {
        let bottomView = UIView(frame: CGRect(x: 0, y: superView.bounds.height * 0.8, width: superView.bounds.width, height: superView.bounds.height * 0.2))
        superView.addSubview(bottomView)
        //bottomView.backgroundColor = UIColor.greenColor()
        
        //Ellipsis Button
        bottomView.addSubview(ellipsesButton)
        ellipsesButton.setImage(UIImage(named:"group2"), forState: .Normal)
        ellipsesButton.snp_makeConstraints(closure: { make in
            make.right.equalTo(bottomView.snp_right).offset(-14.9)
            make.bottom.equalTo(bottomView.snp_bottom).offset(-21.5)
        })

        //Empathise Button
        bottomView.addSubview(empathiseButton)
        empathiseButton.setImage(UIImage(named: "fill1"), forState: .Normal)
//        empathiseButton.imageColorOff = UIColor.brownColor()
//        empathiseButton.imageColorOn = UIColor.redColor()
//        empathiseButton.circleColor = UIColor.greenColor()
//        empathiseButton.lineColor = UIColor.blueColor()
//        empathiseButton.duration = 3.0 // default: 1.0
        empathiseButton.snp_makeConstraints(closure: { make in
            make.height.equalTo(ellipsesButton.snp_height)
            make.right.equalTo(ellipsesButton.snp_left).offset(-10)
            make.bottom.equalTo(ellipsesButton.snp_bottom)
        })
        
        bottomView.addSubview(readMoreButton)
        readMoreButton.setTitleColor(UIColor.wmCoolBlueColor(), forState: .Normal)
        readMoreButton.snp_makeConstraints(closure: { make in
            make.bottom.equalTo(ellipsesButton.snp_bottom).offset(5)
            make.left.equalTo(bottomView.snp_left).offset(5)
        })
    }
    
    func setupMiddleSection( superview:UIView ){
        let view = UIView(frame: CGRect(x: 0, y: superview.bounds.height * 0.2, width: superview.bounds.width, height: superview.bounds.height * 0.6))
        superview.addSubview(view)
        
        //Posts Label
        superview.addSubview(postLabel)
        postLabel.numberOfLines = 0
        postLabel.textColor = UIColor.wmSilverColor()
        postLabel.snp_makeConstraints(closure: { make in
            make.width.equalTo(superview.snp_width).offset(-10)
            make.center.equalTo(superview.snp_center)
        })
    }
    
    func setupTopSection( superView:UIView )  {
        let topView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: (self.bounds.height * 0.2)))
        superView.addSubview(topView)
        
        //Emoji
        topView.addSubview(emojiImageView)
        emojiImageView.snp_makeConstraints(closure: { make in
            make.left.equalTo(topView).offset(5)
            make.top.equalTo(topView).offset(5)
            make.size.equalTo(CGSize(width: 28, height: 28))
        })
        
        //Family HashTag 
        topView.addSubview(hashTagsLabel)
        hashTagsLabel.textColor = UIColor.wmSlateGreyColor()
        hashTagsLabel.snp_makeConstraints(closure: { make in
            make.top.equalTo(emojiImageView.snp_top)
            make.left.equalTo(emojiImageView.snp_right).offset(3)
        })
        
        //Date 
        topView.addSubview(dateLabel)
        dateLabel.textColor = UIColor.wmSilverColor()
        dateLabel.snp_makeConstraints(closure: { make in
            make.top.equalTo(hashTagsLabel.snp_bottom)
            make.left.equalTo(emojiImageView.snp_right).offset(3)
        })
        
        //me or isPrivateLabel
        topView.addSubview(isPrivateLabel)
        isPrivateLabel.textColor = UIColor.wmCoolBlueColor()
        isPrivateLabel.snp_makeConstraints(closure: { make in
            make.right.equalTo(topView.snp_right).offset(-5)
            make.top.equalTo(topView.snp_top).offset(5)
        })
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
