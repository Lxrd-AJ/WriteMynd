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
        field.autocapitalizationType = .none
        field.returnKeyType = .next
        field.delegate = self
        return field;
    }()
    lazy var emailErrorMessage: Label = {
        let label = self.createLabel("! Email already in use")
        label.textColor = UIColor.clear
        return label
    }()
    lazy var passwordTextField: UITextField = {
        let field = self.createTextField("Password")
        field.isSecureTextEntry = true
        field.returnKeyType = .send
        field.tag = 10
        field.delegate = self
        return field
    }()
    lazy var passwordErrorMessage: Label = {
        let label = self.createLabel("! Wrong password")
        label.textColor = UIColor.clear
        return label
    }()
    lazy var loginButton: Button = {
        let button = self.createButton("Log in")
        button.addTarget(self, action: .signin, for: .touchUpInside)
        return button
    }()
    lazy var mascot: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "happyManStood"))
        imageView.contentMode = .center
        return imageView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.title = "Sign Up"
        
        emailStackView.axis = .vertical
        emailStackView.alignment = .fill
        emailStackView.distribution = .fillEqually//.FillProportionally
        
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
        
        emailStackView.snp.makeConstraints({ make in
            make.top.equalTo(self.snp.topLayoutGuideBottom).offset(100)
            make.width.equalTo(self.view.snp.width).offset(-40)
            make.centerX.equalTo(self.view.snp.centerX)
            make.height.equalTo(200)
        })
        
        mascot.snp.makeConstraints({ make in
            make.top.equalTo(emailStackView.snp.bottom).offset(10)
            make.bottom.equalTo(self.view.snp.bottom).offset(-10)
            make.right.equalTo(self.view.snp.right).offset(-10)
        })
        
    }
    
    func signInButton( _ sender: Button ){
        dismissKeyboard()
        guard self.emailTextField.text != "" else {
            showErrorFor(self.emailErrorMessage, message: "! Email can't be empty");
            return;
        }
        guard self.passwordTextField.text != "" else{ showErrorFor(self.passwordErrorMessage, message: "! Password Cannot be empty");
            return;
        }
        
        SwiftSpinner.setTitleFont(Label.font())
        SwiftSpinner.show("Signing in ...")
        
        
        PFUser.logInWithUsername(inBackground: self.emailTextField.text!, password: self.passwordTextField.text!, block: { (user:PFUser?,error:NSError?) in
            if user != nil {
                print("Log In successful")
                Endurance.checkIfUserBlocked(user!.objectId!).then({ blocked in
                    SwiftSpinner.hide()
                    if blocked { 
                        Endurance.showBlockedUserPage(self)
                        PFUser.logOut()
                    }else{
                        self.mm_drawerController.openDrawerGestureModeMask = [.BezelPanningCenterView]
                        self.mm_drawerController.centerViewController = UINavigationController(rootViewController: MyPostsViewController())
                    }
                })
            }else{
                print(error)
                var message = error!.userInfo["error"] as! String
                self.showErrorFor(self.passwordErrorMessage, message: error!.localizedDescription);
                if error!.code == 101 {
                    message = "Wrong Email or Password, Please retry!"
                }
                SwiftSpinner.show(message).addTapHandler({
                    SwiftSpinner.hide()
                    let alertController = UIAlertController(title: "Oops", message: "Looks like you’ve entered the wrong email address or password.", preferredStyle: .Alert)
                    alertController.addAction(UIAlertAction(title: "Give it another go", style: .Cancel, handler: nil))
                    alertController.addAction(UIAlertAction(title: "Reset password", style: .Destructive, handler: { action in
                        self.resetPassword( self.emailTextField.text! )
                    }))
                    alertController.addAction(UIAlertAction(title: "Create account", style: .Default, handler: { action in
                        let signupVC = SignupViewController()
                        signupVC.emailTextField.text = self.emailTextField.text
                       self.navigationController?.pushViewController(signupVC, animated: true)
                    }))
                    self.presentViewController(alertController, animated: true, completion: nil)
                }, subtitle: "Tap to hide!")
            }
        })
    }
    
    /**
     Recieves an email address to send a password reset link to
     
     - parameter email: the email address to use
     - note:
        the validity of the email address is never checked, the email is simply bounced back
     */
    func resetPassword( _ email:String ){
        PFUser.requestPasswordResetForEmail(inBackground: email, block: { (success:Bool,error:NSError?) in
            let alertController = UIAlertController(title: "Password Reset", message: "", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            if let error = error , !success {
                alertController.message = error.userInfo["error"] as? String
            }else{
                alertController.message = "A reset link has been emailed to you. Don’t forget to check your junk folder too!"
            }
            self.present(alertController, animated: true, completion: nil)
        })
    }
    
    func dismissKeyboard(){
        self.emailTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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
