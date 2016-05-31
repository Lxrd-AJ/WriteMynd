//
//  PostTableViewCell.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 10/12/2015.
//  Copyright © 2015 The Leaf. All rights reserved.
//

import UIKit
import SnapKit
//import DOFavoriteButton

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
        
        readMoreButton.setTitleColor(UIColor.wmCoolBlueColor(), forState: .Normal)
        hashTagsLabel.titleLabel?.lineBreakMode = .ByTruncatingTail
        hashTagsLabel.setTitleColor(UIColor.wmSlateGreyColor(), forState: .Normal)
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
    
    func setupBottomSection( superview:UIView ) {
        bottomView.snp_makeConstraints(closure: { make in
            //make.top.equalTo(self.middleView.snp_bottom)
            make.bottom.equalTo(superview.snp_bottom)
            make.width.equalTo(superview.snp_width)
            make.height.equalTo(superview.snp_height).multipliedBy(0.2)
        })
        
        //Ellipsis Button
        ellipsesButton.setImage(UIImage(named:"ellipses"), forState: .Normal)
        ellipsesButton.snp_makeConstraints(closure: { make in
            make.right.equalTo(bottomView.snp_right).offset(-14.9)
            make.bottom.equalTo(bottomView.snp_bottom).offset(-10)
        })

        //Empathise Button
        empathiseButton.snp_makeConstraints(closure: { make in
            //make.height.equalTo(ellipsesButton.snp_height)
            make.right.equalTo(ellipsesButton.snp_left).offset(-10)
            make.bottom.equalTo(ellipsesButton.snp_bottom)
            //make.size.equalTo(CGSize(width: 18, height: 16))
        })
        
        readMoreButton.snp_makeConstraints(closure: { make in
            make.bottom.equalTo(ellipsesButton.snp_bottom).offset(5)
            make.left.equalTo(bottomView.snp_left).offset(5)
        })
    }
    
    /**
     - note look into removing the middle view and use only the label.
     
     - parameter superview: <#superview description#>
     */
    func setupMiddleSection( superview:UIView ){
        self.middleView.snp_makeConstraints(closure: { make in
            make.top.equalTo(self.topView.snp_bottom)
            make.height.equalTo(superview.snp_height).multipliedBy(0.5)
            make.width.equalTo(superview.snp_width)
            make.centerX.equalTo(superview.snp_centerX)
        })
        //Posts Label
        postLabel.snp_makeConstraints(closure: { make in
            //make.top.equalTo(superview.snp_top).offset(5)
            //make.width.equalTo(superview.snp_width).offset(-10)
            //make.center.equalTo(superview.snp_center)
            make.center.equalTo(self.middleView.snp_center)
            make.edges.equalTo(self.middleView.snp_edges).inset(5)
        })
    }
    
    func setupTopSection( superview:UIView )  {
        self.topView.snp_makeConstraints(closure: { make in
            make.top.equalTo(superview.snp_top)
            make.width.equalTo(superview.snp_width)
            make.centerX.equalTo(superview.snp_centerX)
            make.height.equalTo(superview.snp_height).multipliedBy(0.3)
        })
        //Emoji
        if self.postLabel.text == "" {
            emojiImageView.contentMode = .ScaleToFill
            self.emojiImageView.snp_remakeConstraints(closure: { make in
                make.width.equalTo(self.snp_width).multipliedBy(0.5)
                make.height.equalTo(self.snp_height)
                make.left.equalTo(self.topView.snp_left)
                make.top.equalTo(self.topView.snp_top)
            })
        }else{
            emojiImageView.contentMode = .ScaleAspectFit //.Center
            emojiImageView.snp_remakeConstraints(closure: { make in
                make.left.equalTo(self.topView.snp_left).offset(5)
                make.top.equalTo(self.topView.snp_top)//.offset(5)
                make.height.equalTo(self.topView.snp_height)//.offset(-5)
                make.width.equalTo(28)
                //make.size.equalTo(CGSize(width: 28, height: 28))
            })
        }
        //Family HashTag
        hashTagsLabel.sizeToFit()
        hashTagsLabel.snp_makeConstraints(closure: { make in
            make.top.equalTo(self.topView.snp_top)//.offset(-3) //to accomodate for the padding in the label
            make.left.equalTo(emojiImageView.snp_right).offset(10)
            make.right.lessThanOrEqualTo(isPrivateLabel.snp_left).offset(-3)
        })
        //Date
        dateLabel.sizeToFit()
        dateLabel.snp_makeConstraints(closure: { make in
            make.top.equalTo(hashTagsLabel.snp_bottom)
            make.left.equalTo(hashTagsLabel.snp_left)
        })
        //me or isPrivateLabel
        isPrivateLabel.snp_makeConstraints(closure: { make in
            make.right.equalTo(topView.snp_right).offset(-5)
            make.top.equalTo(topView.snp_top).offset(5)
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
            emojiImageView.contentMode = .ScaleToFill
            self.emojiImageView.snp_remakeConstraints(closure: { make in
                make.width.equalTo(self.snp_width).multipliedBy(0.5)
                make.height.equalTo(self.snp_height)
                make.left.equalTo(self.topView.snp_left)
                make.top.equalTo(self.topView.snp_top)
            })
        }else{
            emojiImageView.contentMode = .ScaleAspectFit //.Center
            emojiImageView.snp_remakeConstraints(closure: { make in
                make.left.equalTo(self.topView.snp_left).offset(5)
                make.top.equalTo(self.topView.snp_top)//.offset(5)
                make.height.equalTo(self.topView.snp_height)//.offset(-5)
                make.width.equalTo(28)
                //make.size.equalTo(CGSize(width: 28, height: 28))
            })
        }
        
    }
}
