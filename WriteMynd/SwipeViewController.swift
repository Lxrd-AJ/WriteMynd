//
//  SwipeViewController.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 04/03/2016.
//  Copyright © 2016 The Leaf. All rights reserved.
//

import UIKit
import Koloda
import SnapKit

class TestSwipeViewController: UIViewController {

    let questions: [String] = swipeQuestions //`swipeQuestions` declared in utilities.swift
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = KolodaView(frame: CGRectZero)
        if let view = view as? KolodaView {
            view.dataSource = self
            view.delegate = self
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension TestSwipeViewController: KolodaViewDataSource {
 
    func koloda(kolodaNumberOfCards koloda: KolodaView) -> UInt {
        return UInt(questions.count)
    }
    
    func koloda(koloda: KolodaView, viewForCardAtIndex index: UInt) -> UIView {
        let label = UILabel(frame: UIEdgeInsetsInsetRect(self.view.bounds, UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)))
        label.text = questions[Int(index)]
        label.textAlignment = .Center
        label.backgroundColor = UIColor.lightGrayColor()
        return label
    }
}

extension TestSwipeViewController: KolodaViewDelegate {
    
}