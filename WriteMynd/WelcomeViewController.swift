//
//  SignUpViewController.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 04/12/2015.
//  Copyright © 2015 The Leaf. All rights reserved.
//

import UIKit
import Parse
import MMDrawerController
import SwiftSpinner
import Fabric
import Crashlytics

class WelcomeViewController: UIViewController {
    
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "wm-logo-signup"))
        imageView.contentMode = .Center
        return imageView
    }()
    
    lazy var signInButton: Button = {
        let button = self.createButton("Sign in", iconName: "")
        button.backgroundColor = UIColor.wmPaleGreyColor()
        button.setTitleColor(UIColor.wmSlateGreyColor(), forState: .Normal)
        button.addTarget(self, action: .signin, forControlEvents: .TouchUpInside)
        return button
    }()
    
    lazy var signupButton: Button = {
        let button: Button = self.createButton("Create an account", iconName: "")
        button.backgroundColor = UIColor.wmGreenishTealColor()
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.addTarget(self, action: .signup, forControlEvents: .TouchUpInside)
        return button;
    }()
    
    lazy var orLabel: Label = {
        let label = self.createLabel("or")
        label.setFontSize(12)
        return label
    }()
    
    lazy var warningLabel: Label = {
        let label: Label = self.createLabel("Don’t worry. You’ll always remain anonymous.")
        label.setFontSize(10)
        return label
    }()
    
    lazy var signupLaterButton: Button = {
        let button: Button = Button(type: .Custom)
        button.setTitle("I want to look around now", forState: .Normal)
        button.setTitleColor(.whiteColor(), forState: .Normal)
        button.addTarget(self, action: .anonymousSignin, forControlEvents: .TouchUpInside)
        return button;
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.wmCoolBlueColor()
        self.mm_drawerController.openDrawerGestureModeMask = []
        //self.mm_drawerController.setMaximumLeftDrawerWidth(0, animated: true, completion: nil)
        
        if PFUser.currentUser() != nil {
            // Register the user for crash logs
            if let email = PFUser.currentUser()?.email {
                self.logUser(email)
            }

            let launchCont = MyPostsViewController()
            //launchCont.shouldShowPostingSheet = true
            self.mm_drawerController.openDrawerGestureModeMask = [.BezelPanningCenterView]
            self.mm_drawerController.centerViewController = UINavigationController(rootViewController: launchCont)
        }
        
        self.view.addSubview(iconImageView)
        self.view.addSubview(signInButton)
        self.view.addSubview(orLabel)
        self.view.addSubview(signupButton)
        self.view.addSubview(warningLabel)
        self.view.addSubview(signupLaterButton)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        iconImageView.snp_makeConstraints(closure: { make in
            make.top.equalTo(self.snp_topLayoutGuideBottom).offset(100)
            make.centerX.equalTo(self.view.snp_centerX)
        })
        
        signInButton.snp_makeConstraints(closure: { make in
            make.top.equalTo(self.iconImageView.snp_bottom).offset(50)
            make.centerX.equalTo(self.view.snp_centerX)
        })
        
        orLabel.snp_makeConstraints(closure: { make in
            make.top.equalTo(self.signInButton.snp_bottom).offset(10)
            make.centerX.equalTo(self.view.snp_centerX)
        })
        
        signupButton.snp_makeConstraints(closure: { make in
            make.top.equalTo(self.orLabel.snp_bottom).offset(10)
            make.centerX.equalTo(self.view.snp_centerX)
        })
        
        warningLabel.snp_makeConstraints(closure: { make in
            make.top.equalTo(self.signupButton.snp_bottom).offset(15)
            make.centerX.equalTo(self.view.snp_centerX)
            make.width.lessThanOrEqualTo(self.signupButton.snp_width)
        })
        
        signupLaterButton.snp_makeConstraints(closure: { make in
            make.bottom.equalTo(self.view.snp_bottom).offset(-10)
            make.centerX.equalTo(self.view.snp_centerX)
        })
        
    }
    
    func logUser( email:String ) {
        Crashlytics.sharedInstance().setUserEmail(email)
        Crashlytics.sharedInstance().setUserIdentifier(email)
        Crashlytics.sharedInstance().setUserName(email)
    }

    
    func signInAnonymously(){
        SwiftSpinner.show("")
        PFAnonymousUtils.logInWithBlock{ (user:PFUser?, error:NSError?) -> Void in
            SwiftSpinner.hide()
            if error != nil || user == nil {
                print("Anonymous log in failed")
            }else{
                let myMyndVC = MyPostsViewController()
                self.mm_drawerController.openDrawerGestureModeMask = [.BezelPanningCenterView]
                self.mm_drawerController.centerViewController = UINavigationController(rootViewController: myMyndVC)
                SwiftSpinner.hide()
            }
        }
    }
    
    func signupAction( button:Button ){
        let signupVC = SignupViewController()
        self.navigationController?.pushViewController(signupVC, animated: true)
    }
    
    func signinAction( button: Button ){
        let loginVC = LoginViewController()
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    func createLabel( title:String ) -> Label {
        let label = Label()
        label.textColor = UIColor.whiteColor()
        label.text = title
        label.numberOfLines = 0;
        label.textAlignment = .Center
        return label
    }
    
    func createButton( title:String, iconName:String ) -> Button {
        let button = Button(type: .Custom)
        button.setTitle(title, forState: .Normal)
        button.setImage(UIImage(named: iconName), forState: .Normal)
        //button.layer.cornerRadius = 4.0
        button.snp_makeConstraints(closure: { make in
            make.size.equalTo(CGSize(width: 256, height: 45))
        })
        return button
    }
}

private extension Selector {
    static let signin = #selector(WelcomeViewController.signinAction(_:))
    static let signup = #selector(WelcomeViewController.signupAction(_:))
    static let anonymousSignin = #selector(WelcomeViewController.signInAnonymously)
}
