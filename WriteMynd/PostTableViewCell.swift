//
//  PostTableViewCell.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 10/12/2015.
//  Copyright © 2015 The Leaf. All rights reserved.
//

import UIKit
import SnapKit

class PostTableViewCell: UITableViewCell {

    var emojiLabel: UILabel = UILabel()
    var dateLabel: UILabel = UILabel()
    var postLabel: UILabel = UILabel()
    var hashTagsLabel: UILabel = UILabel()
    var isPrivateLabel: UILabel = UILabel()
    var ellipsesButton: UIButton = UIButton()
    var empathiseButton: UIButton = UIButton()
        
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
        self.empathiseButton = UIButton()
    }
    
    func setupBottomSection( superView:UIView ) {
        let _view = UIView(frame: CGRect(x: 0, y: superView.bounds.height * 0.8, width: superView.bounds.width, height: superView.bounds.height * 0.2))
        superView.addSubview(_view)
        //_view.backgroundColor = UIColor.greenColor()
        
        //Ellipsis Button
//        _view.addSubview(ellipsesButton)
//        ellipsesButton.frame = CGRect(x: (_view.frame.origin.x), y: _view.frame.origin.y, width: 50, height: 50)
//        //ellipsesButton.frame.origin.x = _view.bounds.width - 100
//        //ellipsesButton.frame.origin.y = (superView.bounds.height * 0.8) + 5
//        
//        //Empathise Button
//        _view.addSubview(empathiseButton)
//        empathiseButton.snp_makeConstraints(closure: { make in
//            make.size.equalTo(CGSize(width: 45, height: 45))
//            make.right.equalTo(ellipsesButton.snp_right)
//        })
    }
    
    func setupMiddleSection( superview:UIView ){
        let view = UIView(frame: CGRect(x: 0, y: superview.bounds.height * 0.2, width: superview.bounds.width, height: superview.bounds.height * 0.6))
        superview.addSubview(view)
        
        //Posts Label
        superview.addSubview(postLabel)
        postLabel.numberOfLines = 0
        postLabel.snp_makeConstraints(closure: { make in
            make.width.equalTo(superview.snp_width)
            make.center.equalTo(superview.snp_center)
        })
    }
    
    func setupTopSection( superView:UIView )  {
        let topView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: (self.bounds.height * 0.2)))
        superView.addSubview(topView)
        
        //Emoji
        topView.addSubview(emojiLabel)
        emojiLabel.snp_makeConstraints(closure: { make in
            make.left.equalTo(topView).offset(5)
            make.top.equalTo(topView).offset(5)
        })
        
        //Family HashTag 
        topView.addSubview(hashTagsLabel)
        hashTagsLabel.snp_makeConstraints(closure: { make in
            make.top.equalTo(emojiLabel.snp_top)
            make.left.equalTo(emojiLabel.snp_right)
        })
        
        //Date 
        topView.addSubview(dateLabel)
        dateLabel.snp_makeConstraints(closure: { make in
            make.top.equalTo(hashTagsLabel.snp_bottom)
            make.left.equalTo(emojiLabel.snp_right)
        })
        
        //me or isPrivateLabel
        topView.addSubview(isPrivateLabel)
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
