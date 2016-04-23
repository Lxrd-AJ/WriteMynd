//
//  LoginViewController.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 04/12/2015.
//  Copyright © 2015 The Leaf. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class LoginViewController: PFLogInViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Customizations
        self.fields = [.UsernameAndPassword, .LogInButton, .SignUpButton, .PasswordForgotten] //, .Facebook, .Twitter
        self.facebookPermissions = ["friends_about_me"]
        self.logInView?.emailAsUsername = true
        
        //UI Customizations
        let logo = UILabel()
        logo.font = UIFont(name: "Avenir", size: 34.0)
        logo.text = "WriteMynd"
        logo.textColor = UIColor.whiteColor()
        
        self.logInView!.logo = logo
        self.logInView!.backgroundColor = UIColor(red: 133/255, green: 97/255, blue: 166/255, alpha: 1.0)
        //self.logInView!.logInButton!.setTitleColor(UIColor.redColor(), forState: .Normal)
        self.logInView!.passwordForgottenButton?.setTitleColor(UIColor(red: 58/255, green: 83/255, blue: 155/255, alpha: 1.0), forState: .Normal)
        self.logInView?.logInButton?.setBackgroundImage(nil , forState: .Normal)
        self.logInView?.logInButton?.backgroundColor = UIColor(red: 103/255, green: 65/255, blue: 114/255, alpha: 1.0)
        
        self.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        //UI Customizations
        if let _ = PFUser.currentUser() {
            self.dismissViewControllerAnimated(true, completion: nil)
        }else{
            PFUser.logOut() //HACK: Logging out the current user is 100% guaranteed to work
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension LoginViewController: PFLogInViewControllerDelegate {
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil )
    }
    
    func logInViewController(logInController: PFLogInViewController, shouldBeginLogInWithUsername username: String, password: String) -> Bool {
        return true
    }
    
    func logInViewController(logInController: PFLogInViewController, didFailToLogInWithError error: NSError?) {
        //TODO: Display an error message
        print(error)
    }
    
    func logInViewControllerDidCancelLogIn(logInController: PFLogInViewController) {
        print("The impossible happened, Login Cancelled") //Since the dismiss button is removed, this should never be called
    }
}