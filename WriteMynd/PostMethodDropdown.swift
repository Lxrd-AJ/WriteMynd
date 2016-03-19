//
//  PostMethodDropdown.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 14/03/2016.
//  Copyright © 2016 The Leaf. All rights reserved.
//

import UIKit

/**
 - note DEPRECATED
Custom Override to add the dropdown options to the view on initialization.
The Dropdowns are
* Write It
* Swipe It
- note: These dropdowns are hardcoded and presently there is no need to make it dynamic
*/
class PostMethodDropdown: UIView {
    
    var writeItButton: UIButton
    var swipeItButton: UIButton

    override init(frame: CGRect) {
        let buttonHeight = frame.height
        let buttonWidth = frame.width/2
        
        //Add the buttons
        writeItButton = UIButton(frame: CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight))
        writeItButton.setTitle("Write It", forState: .Normal)
        writeItButton.addBorder(edges: [.Right,.Left])
        writeItButton.tag = 0
        swipeItButton = UIButton(frame: CGRect(x: buttonWidth, y: 0, width: buttonWidth, height: buttonHeight))
        swipeItButton.setTitle("Swipe It", forState: .Normal)
        swipeItButton.addBorder(edges: [.Right,.Left])
        swipeItButton.tag = 1
        
        super.init(frame: frame)
        
        self.addSubview(writeItButton)
        self.addSubview(swipeItButton)
        self.backgroundColor = UIColor.lightGrayColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
