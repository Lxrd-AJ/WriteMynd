//
//  SignupLoginViewController.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 25/04/2016.
//  Copyright © 2016 The Leaf. All rights reserved.
//

import UIKit

class SignupLoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.wmBackgroundColor()
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "stroke5"))
        self.navigationController?.navigationBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showErrorFor( label:Label, message:String ) {
        label.textColor = UIColor.wmFadedRedColor()
        label.text = message
        
        delay(3.0, closure:{
            label.textColor = UIColor.clearColor()
        })
        
    }
    
    func createButton( title:String ) -> Button {
        let button = Button(type: .Custom)
        button.setTitle(title, forState: .Normal)
        button.backgroundColor = UIColor.wmGreenishTealColor()
        button.layer.cornerRadius = 4.0
        return button
    }
    
    func createLabel( title:String ) -> Label {
        let label = Label()
        label.textColor = UIColor.wmFadedRedColor()
        label.text = title
        label.setFontSize(10)
        label.numberOfLines = 0;
        label.textAlignment = .Left
        return label
    }
    
    func createTextField( placeholder:String ) -> UITextField {
        let field = UITextField()
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 30))
        field.placeholder = placeholder
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.wmSilverColor().CGColor
        field.font = Label.font()
        field.layer.cornerRadius = 3.0
        field.backgroundColor = UIColor.whiteColor()
        field.textColor = UIColor.lightGrayColor()
        field.leftView = paddingView
        field.leftViewMode = .Always
        field.autocapitalizationType = .None
        return field
    }

}
