//
//  PostViewController.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 04/12/2015.
//  Copyright © 2015 The Leaf. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {

    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var timer: UIBarButtonItem!
    @IBOutlet weak var canvasView: UIView!
    @IBOutlet weak var postToMe: UIButton!
    @IBOutlet weak var postToNetwork: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        customiseUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func customiseUI(){
        //Draw the right border
        UIView.animateWithDuration(0.01, animations: {
            let rightBorder:UIView = UIView(frame: CGRect(x: self.postToMe.frame.size.width - 1, y: 5, width: 1, height: self.postToMe.frame.size.height-10))
            rightBorder.backgroundColor = UIColor.grayColor()
            self.postToMe.addSubview(rightBorder)
        })
        
    }

}
