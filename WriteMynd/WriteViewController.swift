//
//  WriteViewController.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 19/03/2016.
//  Copyright © 2016 The Leaf. All rights reserved.
//

import UIKit

/**
 - todo: 
    [ ] Add Constraints to the emojiContainerView
 */
class WriteViewController: UIViewController {
    
    lazy var bigEmojiImage: UIImageView = {
        let image = UIImageView(frame: CGRect(x: screenWidth * 0.35, y: screenHeight * 0.15, width: 100, height: 80))
        image.backgroundColor = UIColor.redColor()
        return image
    }()
    
    lazy var descriptionLabel: Label = {
        let label = Label()
        label.text = "Which emotion best describes you now?"
        label.font = label.font.fontWithSize(17)
        return label
    }()
    
    lazy var emojisContainerView: UIView = {
        let view = UIView()//UIView(frame: CGRect(x: 0, y: screenHeight * 0.35, width: screenWidth, height: 100))
        view.backgroundColor = UIColor.greenColor()
        return view
    }()
    
    lazy var hashTagField: UITextField = {
        let field = UITextField()
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 30))
        field.placeholder = "Create a #hashtag"
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.lightGrayColor().CGColor
        field.font = Label.font()
        field.leftView = paddingView
        field.leftViewMode = .Always
        return field
    }()
    
    lazy var feelingField: UITextField = {
        let field = UITextField()
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 30))
        field.placeholder = "How are you feeling today?"
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.lightGrayColor().CGColor
        field.font = Label.font()
        field.leftView = paddingView
        field.leftViewMode = .Always
        return field
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        //Add the UI elements 
        self.view.addSubview(bigEmojiImage)
        
        self.view.addSubview(descriptionLabel)
        descriptionLabel.snp_makeConstraints(closure: { make in
            make.top.equalTo(bigEmojiImage.snp_bottom).offset(10)
            make.centerX.equalTo(self.view.snp_centerX)
        })
        
        self.view.addSubview(emojisContainerView)
        emojisContainerView.snp_makeConstraints(closure: { make in
            make.top.equalTo(descriptionLabel.snp_bottom).offset(10)
            make.width.equalTo(screenWidth)
            make.height.equalTo(125.0)
        })
        
        self.view.addSubview(hashTagField)
        hashTagField.snp_makeConstraints(closure: { make in
            make.top.equalTo(emojisContainerView.snp_bottom).offset(10)
            make.width.equalTo(screenWidth - 20)
            make.centerX.equalTo(self.view.snp_centerX)
            make.height.equalTo(60)
        })
        
        self.view.addSubview(feelingField)
        feelingField.snp_makeConstraints(closure: { make in
            make.top.equalTo( hashTagField.snp_bottom ).offset(10)
            make.size.equalTo( hashTagField )
            make.centerX.equalTo(self.view.snp_centerX)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
