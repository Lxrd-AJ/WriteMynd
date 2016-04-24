//
//  LoginViewController.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 04/12/2015.
//  Copyright © 2015 The Leaf. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = false
        self.view.backgroundColor = UIColor.wmBackgroundColor()
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "stroke5"))
    }
}