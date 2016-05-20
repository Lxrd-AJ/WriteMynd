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

class LoginViewController: SignupLoginViewController {
    
    let emailStackView = UIStackView()
    lazy var emailTextField: UITextField = {
        let field: UITextField = self.createTextField("Email Address")
        field.tag = 5
        field.autocapitalizationType = .None
        field.returnKeyType = .Next
        field.delegate = self
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
        field.delegate = self
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
        self.navigationController?.title = "Sign Up"
        
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
                self.mm_drawerController.openDrawerGestureModeMask = [.BezelPanningCenterView]
                self.mm_drawerController.centerViewController = UINavigationController(rootViewController: MyMyndViewController())
            }else{
                print(error)
                var message = error!.userInfo["error"] as! String
                self.showErrorFor(self.passwordErrorMessage, message: error!.localizedDescription);
                if error!.code == 101 {
                    message = "Wrong Email or Password, Please retry!"
                }
                SwiftSpinner.show(message).addTapHandler({
                    SwiftSpinner.hide()
                    let alertController = UIAlertController(title: "Reset Password?", message: "Using the right email address and would like to reset your password", preferredStyle: .Alert)
                    alertController.addAction(UIAlertAction(title: "Reset", style: .Destructive, handler: { action in
                        self.resetPassword( self.emailTextField.text! )
                    }))
                    alertController.addAction(UIAlertAction(title: "Signup instead", style: .Default, handler: { action in
                        let signupVC = SignupViewController()
                        signupVC.emailTextField.text = self.emailTextField.text
                       self.navigationController?.pushViewController(signupVC, animated: true)
                    }))
                    alertController.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { action in }))
                    self.presentViewController(alertController, animated: true, completion: nil)
                }, subtitle: "Tap to hide!")
            }
        })
    }
    
    func resetPassword( email:String ){
        PFUser.requestPasswordResetForEmailInBackground(email, block: { (success:Bool,error:NSError?) in
            let alertController = UIAlertController(title: "Password Reset", message: "", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            if let error = error where !success {
                alertController.message = error.userInfo["error"] as? String
            }else{
                alertController.message = "A Password reset link has been sent to your email address"
            }
            self.presentViewController(alertController, animated: true, completion: nil)
        })
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