//
//  SignupViewController.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 24/04/2016.
//  Copyright © 2016 The Leaf. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.wmBackgroundColor()
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "stroke5"))
        self.navigationController?.navigationBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
