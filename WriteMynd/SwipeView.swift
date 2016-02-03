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
    var dismissalCallback: (() -> ())?
    var swipeSave: ((swipe:Swipe) -> ())?
    
    //TODO: Shuffle the questions array and point left or right , modulos
    @IBAction func rightButtonTapped(sender: UIButton) {
        feelingButton.setTitle(randomEmotion(), forState: .Normal)
    }
    @IBAction func leftButtonTapped(sender: UIButton) {
        feelingButton.setTitle(randomEmotion(), forState: .Normal)
    }
    
    func setupView(){
        feelingButton.setTitle(randomEmotion(), forState: .Normal)
        
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
        //print("Distances x \(xDistance) and y \(yDistance)")
        
        switch gestureRecognizer.state {
        case .Began:
            self.originalPoint = self.center
        case .Changed:
            let rotationStrength = min(xDistance/screenWidth, 1)
            let rotationAngle = (CGFloat(2 * M_PI) * rotationStrength / 16)
            let scaleStrength = 1 - fabs(rotationStrength) / 4
            let scale = max(scaleStrength,0.93)
            let transform = CGAffineTransformMakeRotation(rotationAngle)
            let scaleTransform = CGAffineTransformScale(transform, scale, scale)
            
            self.center = CGPoint(x: self.originalPoint!.x + xDistance, y: self.originalPoint!.y + yDistance)
            self.transform = scaleTransform
        case .Ended:
            swipeEnded(xDistance, y: yDistance)
        default:
            break;
        }
    }
    
    /*
        The coordinate system is like this, just like the CALayer Rotation system
            270
        180  +  0
            90
        Checks if the minimum swipe distance/threshold has been exceeded and returns the degree if exceeded
    */
    func checkThreshold( xDistance:CGFloat, yDistance:CGFloat ) -> CGFloat?{
        let _radians = atan2(yDistance, xDistance)
        let _degrees = _radians * CGFloat(180 / M_PI)
        let degrees = (_degrees > 0.0 ? _degrees : (360 + _degrees))
        let yStrength = min(yDistance/screenHeight, 1)
        let xStrength = min(xDistance/screenWidth, 1)
        //print("\nRotation strength (x): \(abs(xStrength)) and y: \(abs(yStrength))")
        //print("degree \(degrees)")
        
        //Check if halfway threshold reached
        if( abs(xStrength) >= 0.5 || abs(yStrength) >= 0.5){
            return degrees
        }else{ return nil }
    }
    
    func swipeEnded( x:CGFloat, y:CGFloat ){
        //Check for feelings
        if let degree = checkThreshold( x, yDistance: y ){
            //Animate the card ofscreen and call the view dismissal callback
            UIView.animateWithDuration(0.1, animations: {
                self.transform = CGAffineTransformMakeTranslation(x * 100, y * 100)
                }, completion: { bool in
                    self.dismissalCallback?()
            })
            
            //1st convert the degree to a value (Business logic)
            var swipe = Swipe(value: 0, feeling: feelingButton.titleLabel!.text!)
            switch Int(degree) {
            case 270..<315: //higher top right
                swipe.value = 10
            case 315..<360: //lower top right
                swipe.value = 7
            case 0..<45: //higher bottom right
                swipe.value = 5
            case 45..<90: //lower bottom right
                swipe.value = 3
            case 91..<270: //left side
                swipe.value = 0
            default:
                swipe.value = -1 //An unaccounted situation occurred
            }
            
            //Save the Swipe Feeling by calling the save callback
            self.swipeSave?(swipe: swipe)
        }else{
            //Reset to original position, min swipe distance not reached yet
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
    }
    
    func randomEmotion() -> String {
        let index = Int( arc4random_uniform(UInt32(swipeQuestions.count)) )
        return swipeQuestions[index]
    }
    

    
    //TODO: Write a function that recieves a function b that gets called once the swiping is complete
    //http://guti.in/articles/creating-tinder-like-animations/
}
