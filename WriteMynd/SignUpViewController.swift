//
//  SignUpViewController.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 04/12/2015.
//  Copyright © 2015 The Leaf. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class SignUpViewController: PFSignUpViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //Customizations
        self.fields = [ .Email, .SignUpButton, .DismissButton ]
        self.signUpView?.emailAsUsername = true
        
        //UI Customizations
        let logo = UILabel()
        logo.font = UIFont(name: "Avenir", size: 34.0)
        logo.text = "WriteMynd"
        logo.textColor = UIColor.whiteColor()

        self.signUpView?.logo = logo
        self.signUpView!.backgroundColor = UIColor(red: 133/255, green: 97/255, blue: 166/255, alpha: 1.0)
        self.signUpView?.signUpButton?.setBackgroundImage(nil, forState: .Normal)
        self.signUpView?.signUpButton?.backgroundColor = UIColor(red: 103/255, green: 65/255, blue: 114/255, alpha: 1.0)
        self.signUpView?.dismissButton?.setBackgroundImage(nil, forState: .Normal)
        
        self.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension SignUpViewController: PFSignUpViewControllerDelegate {
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didFailToSignUpWithError error: NSError?) {
        //TODO:Error message
        print(error)
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, shouldBeginSignUp info: [NSObject : AnyObject]) -> Bool {
        return true
    }
    
    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
