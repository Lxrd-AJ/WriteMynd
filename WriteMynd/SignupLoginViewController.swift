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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showErrorFor( _ label:Label, message:String ) {
        label.textColor = UIColor.wmFadedRedColor()
        label.text = message
        
        delay(3.0, closure:{
            label.textColor = UIColor.clear
        })
        
    }
    
    func createButton( _ title:String ) -> Button {
        let button = Button(type: .custom)
        button.setTitle(title, for: UIControlState())
        button.backgroundColor = UIColor.wmGreenishTealColor()
        return button
    }
    
    func createLabel( _ title:String ) -> Label {
        let label = Label()
        label.textColor = UIColor.wmFadedRedColor()
        label.text = title
        label.setFontSize(10)
        label.numberOfLines = 0;
        label.textAlignment = .left
        return label
    }
    
    func createTextField( _ placeholder:String ) -> UITextField {
        let field = UITextField()
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 30))
        field.placeholder = placeholder
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.wmSilverColor().cgColor
        field.font = Label.font()        
        field.backgroundColor = UIColor.white
        field.textColor = UIColor.lightGray
        field.leftView = paddingView
        field.leftViewMode = .always
        field.autocapitalizationType = .none
        return field
    }

}
