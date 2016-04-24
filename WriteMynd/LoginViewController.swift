//
//  LoginViewController.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 04/12/2015.
//  Copyright © 2015 The Leaf. All rights reserved.
//

import UIKit
import Parse
import SwiftSpinner

class LoginViewController: UIViewController {
    
    let emailStackView = UIStackView()
    lazy var emailTextField: UITextField = {
        let field = self.createTextField("Email Address")
        field.tag = 5
        field.returnKeyType = .Next
        return field;
    }()
    lazy var emailErrorMessage: Label = {
        let label = self.createLabel("! Email already in use")
        label.textColor = UIColor.clearColor()
        return label
    }()
    lazy var passwordTextField: UITextField = {
        let field = self.createTextField("Password")
        field.secureTextEntry = true
        field.returnKeyType = .Send
        field.tag = 10
        return field
    }()
    lazy var passwordErrorMessage: Label = {
        let label = self.createLabel("! Wrong password")
        label.textColor = UIColor.clearColor()
        return label
    }()
    lazy var loginButton: Button = {
        let button = self.createButton("Log in")
        button.addTarget(self, action: .signin, forControlEvents: .TouchUpInside)
        return button
    }()
    lazy var mascot: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "happyManStood"))
        imageView.contentMode = .Center
        return imageView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = false
        self.view.backgroundColor = UIColor.wmBackgroundColor()
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "stroke5"))
        
        emailStackView.axis = .Vertical
        emailStackView.alignment = .Fill
        emailStackView.distribution = .FillEqually//.FillProportionally
        
        emailStackView.addArrangedSubview(emailTextField)
        emailStackView.addArrangedSubview(emailErrorMessage)
        emailStackView.addArrangedSubview(passwordTextField)
        emailStackView.addArrangedSubview(passwordErrorMessage)
        emailStackView.addArrangedSubview(loginButton)
        self.view.addSubview(emailStackView)
        self.view.addSubview(mascot)
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: .dismissKeyboard))
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        emailStackView.snp_makeConstraints(closure: { make in
            make.top.equalTo(self.snp_topLayoutGuideBottom).offset(100)
            make.width.equalTo(self.view.snp_width).offset(-40)
            make.centerX.equalTo(self.view.snp_centerX)
            make.height.equalTo(200)
        })
        
        mascot.snp_makeConstraints(closure: { make in
            make.top.equalTo(emailStackView.snp_bottom).offset(10)
            make.bottom.equalTo(self.view.snp_bottom).offset(-10)
            make.right.equalTo(self.view.snp_right).offset(-10)
        })
        
    }
    
    func signInButton( sender: Button ){
        dismissKeyboard()
        guard self.emailTextField.text != "" else {
            showErrorFor(self.emailErrorMessage, message: "! Email Cannot be empty");
            return;
        }
        guard self.passwordTextField.text != "" else{ showErrorFor(self.passwordErrorMessage, message: "! Password Cannot be empty");
            return;
        }
        
        SwiftSpinner.setTitleFont(Label.font())
        SwiftSpinner.show("Signing in ...")
        
        
        PFUser.logInWithUsernameInBackground(self.emailTextField.text!, password: self.passwordTextField.text!, block: { (user:PFUser?,error:NSError?) in
            if user != nil {
                print("Log In successful")
                SwiftSpinner.hide()
                self.mm_drawerController.centerViewController = UINavigationController(rootViewController: EveryMyndController())
            }else{
                var message = error!.localizedDescription
                self.showErrorFor(self.passwordErrorMessage, message: error!.localizedDescription);
                if error!.code == 101 {
                    message = "Wrong Email or Password, Please retry!"
                }
                SwiftSpinner.show(message).addTapHandler({
                        SwiftSpinner.hide()
                    }, subtitle: "Tap to hide!")
            }
        })
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
        field.delegate = self
        field.autocapitalizationType = .None
        return field
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
    
    func dismissKeyboard(){
        self.emailTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.tag == 10 {
            self.signInButton(self.loginButton)
        }else{
            let passwordField = self.view.viewWithTag(10) as! UITextField
            passwordField.becomeFirstResponder()
        }
        return true
    }
    
    
}

private extension Selector{
    static let signin = #selector(LoginViewController.signInButton(_:))
    static let dismissKeyboard = #selector(LoginViewController.dismissKeyboard)
}