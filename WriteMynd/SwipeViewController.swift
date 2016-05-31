//
//  SwipeViewController.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 04/03/2016.
//  Copyright © 2016 The Leaf. All rights reserved.
//

import UIKit
import SnapKit

let ON_BOARDING_MESSAGE_VIEWS = "ON_BOARDING_MESSAGE_VIEWS"

/**
 Sublcass KolodaView to implement custom swiping feature or copy and paste and match or use https://github.com/zhxnlai/ZLSwipeableViewSwift
 */
class SwipeViewController: UIViewController {

    let questions: [String] = swipeQuestions.shuffle() //`swipeQuestions` declared in utilities.swift
    lazy var topMessage: SwipeOnBoarding = {
        return SwipeOnBoarding()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "stroke5"))
        self.view.backgroundColor = UIColor.wmBackgroundColor()
        
        //MARK: - Onboarding checks
        self.view.addSubview(topMessage);
        let viewCounts = NSUserDefaults.standardUserDefaults().integerForKey(ON_BOARDING_MESSAGE_VIEWS)
        if viewCounts >= 5 {
            topMessage.instructionLabel.hidden = true
        }else{
            NSUserDefaults.standardUserDefaults().setInteger((viewCounts+1), forKey: ON_BOARDING_MESSAGE_VIEWS)
        }
        print(viewCounts)        
        topMessage.snp_makeConstraints(closure: { make in
            make.width.equalTo(self.view.snp_width)
            make.top.equalTo(self.snp_topLayoutGuideBottom).offset(10)
            make.height.equalTo(150)
            make.centerX.equalTo(self.view.snp_centerX)
        })
        //END MARK
        
        //MARK - Swiping
        let kolodaView = SwipeView()
        kolodaView.dataSource = self
        kolodaView.delegate = self
        self.view.addSubview( kolodaView )
        kolodaView.snp_makeConstraints(closure: { make in
            make.top.equalTo(topMessage.snp_bottom).offset(10)
            make.centerX.equalTo(topMessage.snp_centerX)
            make.width.equalTo(250)
            make.height.equalTo(150)
        })
        //END MARK - Swiping
        
        //MARK: - Emoji
        let emojiView = UIImageView(image: UIImage(named: "standingManHandsUp")!)
        emojiView.contentMode = .Center
        self.view.insertSubview(emojiView, belowSubview: kolodaView)
        emojiView.snp_makeConstraints(closure: { make in
            make.centerX.equalTo(self.view.snp_centerX)
            make.top.equalTo(kolodaView.snp_bottom).offset(-20)
            make.bottom.equalTo(self.view.snp_bottom).offset(-5)
        })
        //END MARK
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension SwipeViewController {
    func animateToColor( color: UIColor ){
        UIView.animateWithDuration(0.4, delay: 0.0, options: .CurveEaseInOut, animations: {
            self.view.backgroundColor = color
            }, completion: nil)
    }
    
    func resetView(){
        self.animateToColor(.wmBackgroundColor())
        self.topMessage.promptLabel.text = "Which of these emotions do you feel right now?"
        self.topMessage.promptLabel.textColor = UIColor.wmSilverColor()
    }
}

extension SwipeViewController: SwipeViewDataSource {
 
    func koloda(kolodaNumberOfCards koloda: SwipeView) -> UInt {
        return UInt(questions.count)
    }
    
    func koloda(koloda: SwipeView, viewForCardAtIndex index: UInt) -> UIView {
        let label = Label()
        label.text = questions[Int(index)]
        label.textAlignment = .Center
        label.backgroundColor = UIColor.whiteColor()
        label.layer.masksToBounds = false
        label.layer.shadowOffset = CGSize(width: 0, height: 2)
        label.layer.shadowRadius = 1
        label.layer.shadowOpacity = 0.1
        label.setFontSize(20.0)
        label.textColor = .wmCoolBlueColor()
        return label
    }
}

extension SwipeViewController: SwipeViewDelegate {
    func koloda(kolodaDidResetCard koloda: SwipeView) {
        self.resetView()
    }
    
    func koloda(koloda: SwipeView, didSwipedCardAtIndex index: UInt, inDirection direction: SwipeDirection) {
        let feeling = questions[Int(index)]
        var swipe = Swipe(value: -1, feeling: feeling)
        
        if negativeSwipeQuestions.contains(feeling) {
            swipe.value = -direction.rawValue
        }else{
            swipe.value = direction.rawValue
        }
        
        //TRACKING
        Analytics.trackUserMade(swipe)  
        //END TRACKING
        
        swipe.save()
        self.resetView()
        //print(direction)
    }
    
    func koloda(kolodaDidRunOutOfCards koloda: SwipeView) {
        print("Cards Finished")
        self.topMessage.promptLabel.text = "You're all done for now! \nTake a look at the My Mood graph in the Dashboard to see your score";
    }
    
    /**
     The delegate method called on user move swipe card.
     Animates the background color and changes the `topMessage` view text.
     
     - parameter koloda:        the current swipe view
     - parameter finishPercent: The percent of the screen covered in the swipe
     - parameter direction:     The direction of the swipe
     
     - todo
        *   Change the default color in the switch statement
     */
    func koloda(koloda: SwipeView, draggedCardWithFinishPercent finishPercent: CGFloat, inDirection direction: SwipeDirection) {
        //print("\(finishPercent)% in direction \(direction)")
        self.topMessage.instructionLabel.hidden = true
        self.topMessage.promptLabel.textColor = .whiteColor()
        
        var alpha = finishPercent/100.0
        if alpha <= 50 { alpha = 0.7 }
        
        switch direction {
        case .Left, .Ragnarok:
            self.animateToColor(UIColor.redColor().colorWithAlphaComponent(alpha))
            self.topMessage.promptLabel.text = "I don't feel like this"
        case ._15Degrees, ._30Degrees, ._45Degrees, ._60Degrees, ._75Degrees, ._90Degrees:
            self.animateToColor(UIColor.wmGreenishTealColor().colorWithAlphaComponent(alpha))
            self.topMessage.promptLabel.text = "Strongly feel like this"
        default:        
            self.animateToColor(UIColor.lightGrayColor().colorWithAlphaComponent(alpha))
            self.topMessage.promptLabel.text = "Feel a bit like this"
        }
    }
    
    func koloda(kolodaSwipeThresholdMargin koloda: SwipeView) -> CGFloat? {
        return nil
    }
}