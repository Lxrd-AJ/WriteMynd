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
 Sublcass KolodaView to implement custom swiping feature or copy and paste and match
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
        self.view.addSubview(topMessage)
        let viewCounts = NSUserDefaults.standardUserDefaults().integerForKey(ON_BOARDING_MESSAGE_VIEWS)
        if viewCounts > 5 {
            topMessage.instructionLabel.hidden = true
        }else{
            print(viewCounts)
            NSUserDefaults.standardUserDefaults().setInteger((viewCounts+1), forKey: ON_BOARDING_MESSAGE_VIEWS)
        }
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
        let emojiView = UIImageView(image: UIImage(named: "noEmotion")!)
        //self.view.addSubview(emojiView)
        self.view.insertSubview(emojiView, belowSubview: kolodaView)
        emojiView.snp_makeConstraints(closure: { make in
            make.centerX.equalTo(self.view.snp_centerX)
            make.top.equalTo(kolodaView.snp_bottom).offset(-5)
        })
        //END MARK
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        label.layer.shadowOffset = CGSize(width: 5, height: 10)
        label.layer.shadowRadius = 5
        label.layer.shadowOpacity = 0.1
        label.setFontSize(20.0)
        label.textColor = .wmCoolBlueColor()
        return label
    }
}

extension SwipeViewController: SwipeViewDelegate {
    func koloda(koloda: SwipeView, didSwipedCardAtIndex index: UInt, inDirection direction: SwipeDirection) {
        var swipe = Swipe(value: -1, feeling: questions[Int(index)])
        swipe.value = direction.rawValue
        swipe.save()
        print(direction)
    }
    
    func koloda(kolodaDidRunOutOfCards koloda: SwipeView) {
        print("Cards Finished")
    }
    
    func koloda(koloda: SwipeView, draggedCardWithFinishPercent finishPercent: CGFloat, inDirection direction: SwipeDirection) {
        print("\(finishPercent)% in direction \(direction)")
    }
    
    func koloda(kolodaSwipeThresholdMargin koloda: SwipeView) -> CGFloat? {
        return nil
    }
}