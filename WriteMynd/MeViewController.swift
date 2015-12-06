//
//  MeViewController.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 04/12/2015.
//  Copyright © 2015 The Leaf. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class MeViewController: UIViewController {
    
    var showPostController:Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        showPostController = true
    }
    
    override func viewDidAppear(animated: Bool) {
        //Check if User exists
        if let _ = PFUser.currentUser() {
            if showPostController {
                self.performSegueWithIdentifier("showPostController", sender: self)
                showPostController = false
            }
        }else{
            //Present Signup/Login Page
            let loginVC:LoginViewController = LoginViewController()
            loginVC.signUpController = SignUpViewController()
            self.presentViewController(loginVC, animated: true, completion: nil)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated. 
    }
    
    @IBAction func unwindToSegue( segue:UIStoryboardSegue ) {}
    
}



