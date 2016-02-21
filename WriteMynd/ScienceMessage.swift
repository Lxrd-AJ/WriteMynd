//
//  ScienceMessage.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 19/02/2016.
//  Copyright © 2016 The Leaf. All rights reserved.
//

import UIKit

class ScienceMessage: UIViewController {
    
    @IBOutlet weak var messageLabel: UILabel!
    var message:String!
    var index:Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        self.messageLabel.text = message
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
