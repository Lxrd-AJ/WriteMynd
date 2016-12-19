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
        imageView.contentMode = .center
        return imageView
    }()
    
    lazy var signInButton: Button = {
        let button = self.createButton("Sign in", iconName: "")
        button.backgroundColor = UIColor.wmPaleGreyColor()
        button.setTitleColor(UIColor.wmSlateGreyColor(), for: UIControlState())
        button.addTarget(self, action: .signin, for: .touchUpInside)
        return button
    }()
    
    lazy var signupButton: Button = {
        let button: Button = self.createButton("Create an account", iconName: "")
        button.backgroundColor = UIColor.wmGreenishTealColor()
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.addTarget(self, action: .signup, for: .touchUpInside)
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
        let button: Button = Button(type: .custom)
        button.setTitle("I want to look around now", for: UIControlState())
        button.setTitleColor(.white, for: UIControlState())
        button.addTarget(self, action: .anonymousSignin, for: .touchUpInside)
        return button;
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.wmCoolBlueColor()
        self.mm_drawerController.openDrawerGestureModeMask = []
        //self.mm_drawerController.setMaximumLeftDrawerWidth(0, animated: true, completion: nil)
        
        if PFUser.current() != nil {
            // Register the user for crash logs
            if let email = PFUser.current()?.email {
                self.logUser(email)
            }
            
            SwiftSpinner.show("")
            Endurance.checkIfUserBlocked(PFUser.current()!.objectId!).then{ blocked -> Void in
                SwiftSpinner.hide()
                if blocked {
                    Endurance.showBlockedUserPage(self)
                    PFUser.logOut()
                }else{
                    let launchCont = MyPostsViewController()
                    self.mm_drawerController.openDrawerGestureModeMask = [.bezelPanningCenterView]
                    self.mm_drawerController.centerViewController = UINavigationController(rootViewController: launchCont)
                }
            }
        }
        
        self.view.addSubview(iconImageView)
        self.view.addSubview(signInButton)
        self.view.addSubview(orLabel)
        self.view.addSubview(signupButton)
        self.view.addSubview(warningLabel)
        self.view.addSubview(signupLaterButton)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        iconImageView.snp.makeConstraints( { make in
            make.top.equalTo(self.view.snp.topMargin).offset(100)
            make.centerX.equalTo(self.view.snp.centerX)
        })
        
        signInButton.snp.makeConstraints( { make in
            make.top.equalTo(self.iconImageView.snp.bottom).offset(50)
            make.centerX.equalTo(self.view.snp.centerX)
        })
        
        orLabel.snp.makeConstraints( { make in
            make.top.equalTo(self.signInButton.snp.bottom).offset(10)
            make.centerX.equalTo(self.view.snp.centerX)
        })
        
        signupButton.snp.makeConstraints( { make in
            make.top.equalTo(self.orLabel.snp.bottom).offset(10)
            make.centerX.equalTo(self.view.snp.centerX)
        })
        
        warningLabel.snp.makeConstraints( { make in
            make.top.equalTo(self.signupButton.snp.bottom).offset(15)
            make.centerX.equalTo(self.view.snp.centerX)
            make.width.lessThanOrEqualTo(self.signupButton.snp.width)
        })
        
        signupLaterButton.snp.makeConstraints( { make in
            make.bottom.equalTo(self.view.snp.bottom).offset(-10)
            make.centerX.equalTo(self.view.snp.centerX)
        })
        
    }
    
    func logUser( _ email:String ) {
        Crashlytics.sharedInstance().setUserEmail(email)
        Crashlytics.sharedInstance().setUserIdentifier(email)
        Crashlytics.sharedInstance().setUserName(email)
    }

    
    func signInAnonymously(){
        Endurance.showEndUserLicensePage(self, onAgreeAction: {
            SwiftSpinner.show("")
            PFAnonymousUtils.logIn{ (user, error) -> Void in
                SwiftSpinner.hide()
                if error != nil || user == nil {
                    print("Anonymous log in failed")
                }else{
                    let myMyndVC = MyPostsViewController()
                    self.mm_drawerController.openDrawerGestureModeMask = [.bezelPanningCenterView]
                    self.mm_drawerController.centerViewController = UINavigationController(rootViewController: myMyndVC)
                    SwiftSpinner.hide()
                }
            }
        })
    }
    
    func signupAction( _ button:Button ){
        let signupVC = SignupViewController()
        self.navigationController?.pushViewController(signupVC, animated: true)
    }
    
    func signinAction( _ button: Button ){
        let loginVC = LoginViewController()
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    func createLabel( _ title:String ) -> Label {
        let label = Label()
        label.textColor = UIColor.white
        label.text = title
        label.numberOfLines = 0;
        label.textAlignment = .center
        return label
    }
    
    func createButton( _ title:String, iconName:String ) -> Button {
        let button = Button(type: .custom)
        button.setTitle(title, for: UIControlState())
        button.setImage(UIImage(named: iconName), for: UIControlState())
        //button.layer.cornerRadius = 4.0
        button.snp.makeConstraints( { make in
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
