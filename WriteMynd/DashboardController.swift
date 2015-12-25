//
//  DashboardController.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 23/12/2015.
//  Copyright © 2015 The Leaf. All rights reserved.
//

import UIKit
import MMDrawerController
import Charts

class DashboardController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showMenu( sender: UIBarButtonItem ){
        self.mm_drawerController.toggleDrawerSide(.Left, animated: true, completion: nil)
    }
    
}
