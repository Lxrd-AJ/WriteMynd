//
//  WriteViewController.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 19/03/2016.
//  Copyright © 2016 The Leaf. All rights reserved.
//

import UIKit
import SnapKit

/**
 - todo: 
    [x] Add Constraints to the emojiContainerView
    [ ] Make the Buttons bouncy ~ https://github.com/StyleShare/SSBouncyButton
 */
class WriteViewController: ViewController {
    
    var currentTextField: UITextField? //The Current textfield the user is editing
    
    lazy var bigEmojiImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "noEmotion")!
        image.contentMode = .ScaleAspectFit
        return image
    }()
    
    lazy var descriptionLabel: Label = {
        let label = Label()
        label.text = "Which emotion best describes you now?"
        label.font = label.font.fontWithSize(17)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var emojisContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var happyEmoji: UIButton = {
        let button = UIButton()
        //button.setImage(UIImage(named: "happy"), forState: .Normal)
        button.setBackgroundImage(UIImage(named: "happy"), forState: .Normal)
        button.imageView?.contentMode = .ScaleAspectFit
        return button
    }()
    
    lazy var hashTagField: UITextField = { //this has the tag of 5
        let field = UITextField()
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 30))
        field.placeholder = "Create a #hashtag"
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.lightGrayColor().CGColor
        field.font = Label.font()
        field.backgroundColor = UIColor.whiteColor()
        field.leftView = paddingView
        field.leftViewMode = .Always
        field.delegate = self
        field.tag = 5
        return field
    }()
    
    lazy var feelingField: UITextField = {  //this has the tag of 10
        let field = UITextField()
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 30))
        field.placeholder = dailyQuestion[Int( arc4random_uniform(UInt32(dailyQuestion.count)))]
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.lightGrayColor().CGColor
        field.font = Label.font()
        field.backgroundColor = UIColor.whiteColor()
        field.adjustsFontSizeToFitWidth = true
        field.leftView = paddingView
        field.leftViewMode = .Always
        field.delegate = self
        field.tag = 10
        return field
    }()
    
    lazy var postToMeButton: UIButton = {
        let button = Button()
        button.setTitle("Post to me", forState: .Normal)
        button.backgroundColor = UIColor.wmGreenishTealColor()
        return button
    }()
    
    lazy var postToAllButton: UIButton = {
        let button = Button()
        button.setTitle("Post to all", forState: .Normal)
        button.backgroundColor = UIColor.wmCoolBlueColor()
        return button
    }()
    
    lazy var focusView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        view.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.9)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.wmBackgroundColor()
        //Add the UI elements 
        self.view.addSubview(bigEmojiImage)
        bigEmojiImage.snp_makeConstraints(closure: { make in
            var topOffset:Float = 35;
            if let navHeight = self.navigationController?.navigationBar.bounds.height{
                topOffset += Float(navHeight);
            }
            make.top.equalTo(self.view.snp_top).offset(topOffset)
            make.centerX.equalTo(self.view.snp_centerX)
        })
        
        self.view.addSubview(descriptionLabel)
        descriptionLabel.snp_makeConstraints(closure: { make in
            make.top.equalTo(bigEmojiImage.snp_bottom).offset(10)
            make.centerX.equalTo(self.view.snp_centerX)
            make.width.lessThanOrEqualTo(self.view.snp_width)
        })
        
        self.view.addSubview(emojisContainerView)
        emojisContainerView.snp_makeConstraints(closure: { make in
            make.top.equalTo(descriptionLabel.snp_bottom).offset(10)
            make.width.equalTo(self.view.snp_width).offset(-20)
            make.centerX.equalTo(self.view.snp_centerX)
            make.height.equalTo(50.0)
        })
        //Add the Happy Emoji
        emojisContainerView.addSubview(happyEmoji)
        happyEmoji.snp_makeConstraints(closure: { make in
            make.width.equalTo(50)
            make.height.equalTo(50)
            make.left.equalTo(emojisContainerView.snp_left)
            make.top.equalTo(emojisContainerView.snp_top)
        })
        
        self.view.addSubview(hashTagField)
        hashTagField.snp_makeConstraints(closure: { make in
            make.top.equalTo(emojisContainerView.snp_bottom).offset(10)
            make.width.equalTo(screenWidth - 20)
            make.centerX.equalTo(self.view.snp_centerX)
            make.height.equalTo(45)
        })
        
        self.view.addSubview(feelingField)
        feelingField.snp_makeConstraints(closure: { make in
            make.top.equalTo( hashTagField.snp_bottom ).offset(10)
            make.size.equalTo( hashTagField )
            make.centerX.equalTo(self.view.snp_centerX)
        })
        
        self.view.addSubview(postToMeButton)
        postToMeButton.snp_makeConstraints(closure: { make in
            make.left.equalTo(self.view.snp_left).offset(10)
            make.top.equalTo(self.feelingField.snp_bottom).offset(11)
            make.width.equalTo(162)
            make.height.equalTo(45)
        })
        
        self.view.addSubview(postToAllButton)
        postToAllButton.snp_makeConstraints(closure: { make in
            make.right.equalTo(self.view.snp_right).offset(-10)
            make.top.equalTo(self.feelingField.snp_bottom).offset(11)
            make.width.equalTo(162)
            make.height.equalTo(45)
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        //Register for the keyboard will show notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil) //UIKeyboardDidShowNotification
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension WriteViewController {
    func keyboardWillShow(notification:NSNotification){
        let keyboardFrame:CGRect = notification.userInfo![UIKeyboardFrameEndUserInfoKey]!.CGRectValue
        print("Keyboard Did appear \(keyboardFrame)")
        
        if let textField = self.currentTextField {
            //self.view.addSubview(focusView)
//            self.view.insertSubview(textField, aboveSubview: focusView)
//            if textField.tag == 5 { //hashtag Textfield
//                textField.snp_updateConstraints(closure: { make in
//                    make.bottom.equalTo(self.view.snp_top).offset(keyboardFrame.origin.y - 50);
//                })
//            }
        }//end if
    }
    
}

extension WriteViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(textField: UITextField) {
        print("Editing began")
        self.currentTextField = textField
        if textField.tag == 5 { //hashtag TextField
            print("HAshTag TextField")
        }else if textField.tag == 10 { //feeling textfield
            print("Feeling Textfield")
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        //self.focusView.removeFromSuperview()
        
        if textField.tag == 5 { //hashtag Textfield
//            textField.snp_remakeConstraints(closure: { make in
//            })
        }
        
        return true
    }
}
