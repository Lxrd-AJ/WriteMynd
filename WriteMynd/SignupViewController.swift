//
//  SignupViewController.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 24/04/2016.
//  Copyright © 2016 The Leaf. All rights reserved.
//

import UIKit
import SwiftSpinner
import Parse
import Pages

class SignupViewController: SignupLoginViewController {
    
    let formStackView: UIStackView = UIStackView()
    
    lazy var onboardButton: Button = {
        let button: Button = self.createButton("Tell me more about Write Mynd")
        button.backgroundColor = UIColor.wmSilverColor()
        button.layer.cornerRadius = 0.0
        button.addTarget(self, action: .beginOnBoarding, forControlEvents: .TouchUpInside)
        return button
    }()
    lazy var emailTextField: UITextField = {
        let field: UITextField = self.createTextField("Email address")
        field.tag = 1
        field.returnKeyType = .Next
        return field
    }()
    lazy var password1Field: UITextField = {
        let field: UITextField = self.createTextField("Password")
        field.tag = 2;
        field.returnKeyType = .Next
        field.secureTextEntry = true
        return field
    }()
    lazy var password2Field: UITextField = {
        let field: UITextField = self.createTextField("Confirm password")
        field.tag = 3;
        field.returnKeyType = .Done
        field.secureTextEntry = true
        return field
    }()
    lazy var signupButton: Button = {
        let button = self.createButton("Create account")
        button.addTarget(self, action: .signup, forControlEvents: .TouchUpInside)
        return button
    }()
    lazy var mascot: UIImageView = {
        let imgView = UIImageView(image: UIImage(named: "noEmotion"))
        imgView.contentMode = .Center
        return imgView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        formStackView.axis = .Vertical
        formStackView.alignment = .Fill
        formStackView.distribution = .FillEqually //.FillProportionally
        formStackView.spacing = 10.0
        
        formStackView.addArrangedSubview(emailTextField)
        formStackView.addArrangedSubview(password1Field)
        formStackView.addArrangedSubview(password2Field)
        formStackView.addArrangedSubview(signupButton)
        
        self.view.addSubview(formStackView)
        self.view.addSubview(onboardButton)
        self.view.addSubview(mascot)
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: .dismissKeyboard))

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        formStackView.snp_makeConstraints(closure: { make in
            make.top.equalTo(self.snp_topLayoutGuideBottom).offset(45)
            make.left.equalTo(self.view.snp_left).offset(10)
            make.right.equalTo(self.view.snp_right).offset(-10)
            make.height.equalTo(225)
        })
        
        onboardButton.snp_makeConstraints(closure: { make in
            make.bottom.equalTo(self.view.snp_bottom)
            make.width.equalTo(self.view.snp_width)
            make.height.equalTo(50)
        })
        
        mascot.snp_makeConstraints(closure: { make in
            make.top.equalTo(formStackView.snp_bottom)
            make.bottom.equalTo(onboardButton.snp_top)
            make.right.equalTo(self.view.snp_right).offset(-10)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func createTextField(placeholder: String) -> UITextField {
        let field = super.createTextField(placeholder)
        field.delegate = self
        return field
    }

}

extension SignupViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if textField.tag == 1 {
            let p1 = self.view.viewWithTag(2) as! UITextField
            p1.becomeFirstResponder()
        }else if textField.tag == 2 {
            let p2 = self.view.viewWithTag(3) as! UITextField
            p2.becomeFirstResponder()
        }else if textField.tag == 3 {
            self.signup(self.signupButton)
        }
        
        return true
    }
}

extension SignupViewController {
    
    func showError( title:String ){
        SwiftSpinner.setTitleFont(Label.font())
        SwiftSpinner.show(title, animated: true).addTapHandler({ SwiftSpinner.hide() }, subtitle: "Tap to dismiss")
    }
    
    /**
     Signs up the current user based on the UITextField values
     
     - parameter sender: The `Signup and continue button`
     - note 
        Error Codes
        * 125 = Invalid Email address
        * 202 = Email Address/Username already in use
     */
    func signup( sender:Button ){
        dismissKeyboard()
        
        guard self.emailTextField.text != "" else{ self.showError("Woah there. Enter your email address if you want to create an account."); return; }
        guard self.password1Field.text != "" else{ self.showError("Aren’t you forgetting something? Enter a password to create an account."); return; }
        guard self.password1Field.text == self.password2Field.text else{ self.showError("Oops. Both passwords must match in order to create an account"); return; }
        
        let user:PFUser = PFUser()
        user.username = self.emailTextField.text
        user.password = self.password2Field.text
        user.email = self.emailTextField.text
        
        //Get the user to agree to the end user license first 
//        Endurance.showEndUserLicensePage(self, onAgreeAction:)
        Endurance.showEndUserLicensePage(self, onAgreeAction: {
            SwiftSpinner.show("Creating WriteMynd account ...", animated: true)
            user.signUpInBackgroundWithBlock({ (succeeded:Bool, error:NSError?) -> Void in
                if let error = error where !succeeded {
                    print(error)
                    print(error.code)
                    var errorString = error.userInfo["error"] as? NSString
                    if error.code == 202 {
                        errorString = "\(user.email!) is already registered to an account"
                    }else if error.code == 125 {
                        errorString = "Email address doesn’t seem to be valid."
                    }
                    self.showError(errorString as! String)
                }else{
                    SwiftSpinner.hide()
                    self.mm_drawerController.openDrawerGestureModeMask = [.BezelPanningCenterView]
                    self.mm_drawerController.centerViewController = UINavigationController(rootViewController: EveryMyndController())
                }
            })
        })//end
        
    }
    

    
    /**
     - todo: Replace with pages https://github.com/hyperoslo/Pages 
     
     - parameter sender: button to begin onboarding
     */
    func beginOnBoarding( sender:Button ){
        let firstPageAnimationImages = ["happyJumpingGuy1","happyJumpingGuy2","happyJumpingGuy3","happyJumpingGuy2","happyJumpingGuy1"]
        let secondPageAnimationImages = ["photoGuy1","photoGuy2","photoGuy3","photoGuy4","photoGuy5"]
        let thirdAnimationImages = ["reflectSlide1","reflectSlide2","reflectSlide3","reflectSlide2","reflectSlide1"]
        let lastAnimationImages = ["shareSlide1","shareSlide2","shareSlide3","shareSlide4","shareSlide5","shareSlide6","shareSlide7","shareSlide8","shareSlide1"]
        
        let firstPage = OnboardViewController(title: "", body: "To put it simply: Write Mynd is a place where you can anonymously record, reflect and share your honest thoughts and feelings for a clearer mind.", animationImageNames: firstPageAnimationImages, imageName: "happyJumpingGuy1",backgroundColor: UIColor.wmSoftBlueColor()) //happyJumpingGuy
        let secondPage = OnboardViewController(title: "Record", body: "Get things off your chest. With Write Mynd, you can easily express how you feel by simply swiping or writing.", animationImageNames: secondPageAnimationImages, imageName: "photoGuy", backgroundColor: UIColor.wmSlateGreyColor())
        let thirdPage = OnboardViewController(title: "Reflect", body: "Check in on your emotions. Write Mynd helps you spot thought patterns and uncover what makes you feel the way you do.", animationImageNames: thirdAnimationImages, imageName: "reflectSlide1", backgroundColor: UIColor.wmGreenishTealTwoColor())
        let lastPage = OnboardViewController(title: "Share", body: "See that you’re not alone. Write Mynd lets you see how other people are feeling as well as anonymously share your own thoughts.", animationImageNames: lastAnimationImages, imageName:"shareSlide1", backgroundColor: UIColor.wmLightGoldColor())
        
        let pages = [firstPage,secondPage,thirdPage,lastPage]
        let onboardingVC = PagesController(pages)
        _ = pages.map({ page in page.buttonAction = { onboardingVC.dismissViewControllerAnimated(true, completion: nil) } })
        onboardingVC.view.backgroundColor = UIColor.wmSilverColor()
        
        self.presentViewController(onboardingVC, animated: true, completion: {
            //firstPage.iconView.startAnimating()
        })

    }
    
    func dismissKeyboard(){
        self.emailTextField.resignFirstResponder()
        self.password1Field.resignFirstResponder()
        self.password2Field.resignFirstResponder()
    }

}

private extension Selector{
    static let signup = #selector(SignupViewController.signup(_:))
    static let beginOnBoarding = #selector(SignupViewController.beginOnBoarding(_:))
    static let dismissKeyboard = #selector(SignupViewController.dismissKeyboard)
}