//
//  PostTableViewCell.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 10/12/2015.
//  Copyright © 2015 The Leaf. All rights reserved.
//

import UIKit
import SnapKit

/**
 - todo:
    [ ] Replace the ellipses button with https://github.com/Ramotion/circle-menu
 */
class PostTableViewCell: UITableViewCell {

    var emojiImageView: UIImageView = UIImageView()
    var dateLabel: Label = Label()
    var postLabel: Label = Label()
    var hashTagsLabel: Button = Button()
    var isPrivateLabel: Label = Label()
    var ellipsesButton: UIButton = UIButton()
    var empathiseButton: UIButton = UIButton() //DOFavoriteButton = DOFavoriteButton()
    var readMoreButton: Button = Button()
    
    let bottomView: UIView = UIView()
    let middleView: UIView = UIView()
    let topView: UIView = UIView()
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(topView)
        self.contentView.addSubview(middleView)
        self.contentView.addSubview(postLabel)
        self.contentView.addSubview(bottomView)
        
        topView.addSubview(emojiImageView)
        topView.addSubview(hashTagsLabel)
        topView.addSubview(dateLabel)
        topView.addSubview(isPrivateLabel)
        
        bottomView.addSubview(ellipsesButton)
        bottomView.addSubview(empathiseButton)
        bottomView.addSubview(readMoreButton)
        
        readMoreButton.setTitleColor(UIColor.wmCoolBlueColor(), for: UIControlState())
        hashTagsLabel.titleLabel?.lineBreakMode = .byTruncatingTail
        hashTagsLabel.setTitleColor(UIColor.wmSlateGreyColor(), for: UIControlState())
        hashTagsLabel.setFontSize(14.5)
        dateLabel.textColor = UIColor.wmSilverColor()
        dateLabel.setFontSize(11)
        isPrivateLabel.textColor = UIColor.wmCoolBlueColor()
        isPrivateLabel.setFontSize(8);
        postLabel.numberOfLines = 0
        postLabel.textColor = UIColor.wmSilverColor()
        //emojiImageView.contentMode = .ScaleAspectFill
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupTopSection(self.contentView)
        setupMiddleSection(self.contentView)
        setupBottomSection(self.contentView)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.setNeedsLayout()
    }
    
    func setupBottomSection( _ superview:UIView ) {
        bottomView.snp.makeConstraints({ make in
            //make.top.equalTo(self.middleView.snp.bottom)
            make.bottom.equalTo(superview.snp.bottom)
            make.width.equalTo(superview.snp.width)
            make.height.equalTo(superview.snp.height).multipliedBy(0.2)
        })
        
        //Ellipsis Button
        ellipsesButton.setImage(UIImage(named:"ellipses"), for: UIControlState())
        ellipsesButton.snp.makeConstraints({ make in
            make.right.equalTo(bottomView.snp.right).offset(-14.9)
            make.bottom.equalTo(bottomView.snp.bottom).offset(-10)
        })

        //Empathise Button
        empathiseButton.snp.makeConstraints({ make in
            //make.height.equalTo(ellipsesButton.snp.height)
            make.right.equalTo(ellipsesButton.snp.left).offset(-10)
            make.bottom.equalTo(ellipsesButton.snp.bottom)
            //make.size.equalTo(CGSize(width: 18, height: 16))
        })
        
        readMoreButton.snp.makeConstraints({ make in
            make.bottom.equalTo(ellipsesButton.snp.bottom).offset(5)
            make.left.equalTo(bottomView.snp.left).offset(5)
        })
    }
    
    /**
     - note look into removing the middle view and use only the label.
     
     - parameter superview: <#superview description#>
     */
    func setupMiddleSection( _ superview:UIView ){
        self.middleView.snp.makeConstraints({ make in
            make.top.equalTo(self.topView.snp.bottom)
            make.height.equalTo(superview.snp.height).multipliedBy(0.5)
            make.width.equalTo(superview.snp.width)
            make.centerX.equalTo(superview.snp.centerX)
        })
        //Posts Label
        postLabel.snp.makeConstraints({ make in
            //make.top.equalTo(superview.snp.top).offset(5)
            //make.width.equalTo(superview.snp.width).offset(-10)
            //make.center.equalTo(superview.snp.center)
            make.center.equalTo(self.middleView.snp.center)
            make.edges.equalTo(self.middleView.snp.edges).inset(5)
        })
    }
    
    func setupTopSection( _ superview:UIView )  {
        self.topView.snp.makeConstraints({ make in
            make.top.equalTo(superview.snp.top)
            make.width.equalTo(superview.snp.width)
            make.centerX.equalTo(superview.snp.centerX)
            make.height.equalTo(superview.snp.height).multipliedBy(0.3)
        })
        //Emoji
        if self.postLabel.text == "" {
            emojiImageView.contentMode = .scaleToFill
            self.emojiImageView.snp.remakeConstraints({ make in
                make.width.equalTo(self.snp.width).multipliedBy(0.5)
                make.height.equalTo(self.snp.height)
                make.left.equalTo(self.topView.snp.left)
                make.top.equalTo(self.topView.snp.top)
            })
        }else{
            emojiImageView.contentMode = .scaleAspectFit //.Center
            emojiImageView.snp.remakeConstraints({ make in
                make.left.equalTo(self.topView.snp.left).offset(5)
                make.top.equalTo(self.topView.snp.top).offset(5)
                make.height.equalTo(28)//self.topView.snp.height//.offset(-5)
                make.width.equalTo(28)
                //make.size.equalTo(CGSize(width: 28, height: 28))
            })
        }
        //Family HashTag
        hashTagsLabel.sizeToFit()
        hashTagsLabel.snp.makeConstraints({ make in
            make.top.equalTo(self.topView.snp.top)//.offset(-3) //to accomodate for the padding in the label
            make.left.equalTo(emojiImageView.snp.right).offset(10)
            make.right.lessThanOrEqualTo(isPrivateLabel.snp.left).offset(-3)
        })
        //Date
        dateLabel.sizeToFit()
        dateLabel.snp.makeConstraints({ make in
            make.top.equalTo(hashTagsLabel.snp.bottom)
            make.left.equalTo(hashTagsLabel.snp.left)
            //make.bottom.equalTo(
        })
        //me or isPrivateLabel
        isPrivateLabel.snp.makeConstraints({ make in
            make.right.equalTo(topView.snp.right).offset(-5)
            make.top.equalTo(topView.snp.top).offset(5)
        })
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PostTableViewCell {
    
    func updateEmojiConstraints(){
        self.setNeedsLayout()
        if self.postLabel.text == "" {
            emojiImageView.contentMode = .scaleToFill
            self.emojiImageView.snp.remakeConstraints({ make in
                make.width.equalTo(self.snp.width).multipliedBy(0.5)
                make.height.equalTo(self.snp.height)
                make.left.equalTo(self.topView.snp.left)
                make.top.equalTo(self.topView.snp.top)
            })
        }else{
            emojiImageView.contentMode = .scaleAspectFit //.Center
            emojiImageView.snp.remakeConstraints({ make in
                make.left.equalTo(self.topView.snp.left).offset(5)
                make.top.equalTo(self.topView.snp.top)//.offset(5)
                make.height.equalTo(self.topView.snp.height)//.offset(-5)
                make.width.equalTo(28)
                //make.size.equalTo(CGSize(width: 28, height: 28))
            })
        }
        
    }
}
