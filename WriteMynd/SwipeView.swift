//
//  SwipeView.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 01/02/2016.
//  Copyright © 2016 The Leaf. All rights reserved.
//

import UIKit

class SwipeView: UIView {

    @IBOutlet weak var feelingButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    var originalPoint: CGPoint?
    
    func setupView(){
        //self.feelingButton.layer.cornerRadius = self.frame.width / 2
        self.layer.cornerRadius = 9.0
        self.layer.shadowOffset = CGSize(width: 7, height: 7)
        self.layer.shadowRadius = 6
        self.layer.shadowOpacity = 0.9
        
        setUpGestureRecognizers()
    }

    func setUpGestureRecognizers(){
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "dragged:")
        self.addGestureRecognizer(panGestureRecognizer)
    }
    
    func dragged( gestureRecognizer:UIPanGestureRecognizer ){
        let xDistance = gestureRecognizer.translationInView(self).x
        let yDistance = gestureRecognizer.translationInView(self).y
        print("Distances x \(xDistance) and y \(yDistance)")
        
        switch gestureRecognizer.state {
        case .Began:
            self.originalPoint = self.center
        case .Changed:
            let rotationStrength = min(xDistance/320, 1)
            let rotationAngle = (CGFloat(2 * M_PI) * rotationStrength / 16)
            let scaleStrength = 1 - fabs(rotationStrength) / 4
            let scale = max(scaleStrength,0.93)
            let transform = CGAffineTransformMakeRotation(rotationAngle)
            let scaleTransform = CGAffineTransformScale(transform, scale, scale)
            
            self.center = CGPoint(x: self.originalPoint!.x + xDistance, y: self.originalPoint!.y + yDistance)
            self.transform = scaleTransform
            
            //Check for feelings
            checkSwipeView( xDistance, yDist: yDistance )
        case .Ended:
            swipeEnded()
        default:
            break;
        }
    }
    
    /*
        The coordinate system is like this, just like the CALayer Rotation system
            270
        180  +  0
            90
    */
    func checkSwipeView( xDist:CGFloat, yDist:CGFloat ){
        let _radians = atan2(yDist, xDist)
        let _degrees = _radians * CGFloat(180 / M_PI)
        let degrees = (_degrees > 0.0 ? _degrees : (360 + _degrees))
        print("Other degree \(degrees)")
    }
    
    func swipeEnded(){
        UIView.animateWithDuration(0.2, animations: {
            self.center = self.originalPoint!
            self.transform = CGAffineTransformMakeRotation(0)
            self.alpha = 1.0
            }, completion: { bool in
                //Reset the view postion and transformations
                self.setNeedsUpdateConstraints()
                self.setNeedsLayout()
        })
    }
    

    
    //TODO: Write a function that recieves a function b that gets called once the swiping is complete
    //TODO: Use the rotation angle to determine how the user is feeling xDist/yDist
    //CGFloat radians = atan2f(yourView.transform.b, yourView.transform.a);
    //CGFloat degrees = radians * (180 / M_PI);
}
