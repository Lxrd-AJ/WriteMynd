//
//  SwipeViewController.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 04/03/2016.
//  Copyright © 2016 The Leaf. All rights reserved.
//

import UIKit
import SnapKit

protocol SwipeViewControllerDelegate {
    func removeMe()
}

/**
 Sublcass KolodaView to implement custom swiping feature or copy and paste and match
 */
class SwipeViewController: UIViewController {

    let questions: [String] = swipeQuestions.shuffle() //`swipeQuestions` declared in utilities.swift
    var delegate: SwipeViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let kolodaView = SwipeView(frame: UIEdgeInsetsInsetRect(self.view.bounds, UIEdgeInsetsMake(100, 50, 100, 50)))
        kolodaView.dataSource = self
        kolodaView.delegate = self
        self.view.addSubview( kolodaView )
        
        //MARK - Customisations
        let cancelButton = UIButton()
        cancelButton.setImage(UIImage(named: "Cancel"), forState: .Normal)
        cancelButton.sizeToFit()    
        cancelButton.addTarget(self, action: "removeMe", forControlEvents: .TouchUpInside)
        self.view.addSubview(cancelButton)
        cancelButton.snp_makeConstraints(closure: { (make:ConstraintMaker) -> Void in
            make.left.equalTo(self.view.snp_left).offset(10)
            make.top.equalTo(self.view.snp_top).offset(20)
        })
        //END MARK
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func removeMe(){
        if let delegate = delegate{
            delegate.removeMe()
        }else{ print("Delegate Not assigned") }
    }
}

extension SwipeViewController: SwipeViewDataSource {
 
    func koloda(kolodaNumberOfCards koloda: SwipeView) -> UInt {
        return UInt(questions.count)
    }
    
    func koloda(koloda: SwipeView, viewForCardAtIndex index: UInt) -> UIView {
        let label = UILabel()
        label.text = questions[Int(index)]
        label.textAlignment = .Center
        label.backgroundColor = UIColor.lightGrayColor()
        return label
    }
}

extension SwipeViewController: SwipeViewDelegate {
    func koloda(koloda: SwipeView, didSwipedCardAtIndex index: UInt, inDirection direction: SwipeDirection) {
        var swipe = Swipe(value: -1, feeling: questions[Int(index)])
        swipe.value = direction.rawValue
        print(direction)
        swipe.save()
    }
    
    func koloda(kolodaDidRunOutOfCards koloda: SwipeView) {
        print("Cards Finished")
    }
    
    func koloda(kolodaShouldTransparentizeNextCard koloda: SwipeView) -> Bool {
        return false
    }
    
    func koloda(kolodaSwipeThresholdMargin koloda: SwipeView) -> CGFloat? {
        return nil
    }
}