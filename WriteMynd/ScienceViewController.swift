//
//  ScienceViewController.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 19/02/2016.
//  Copyright © 2016 The Leaf. All rights reserved.
//

import UIKit
/**
 Explains the Science behind WriteMynd
 */
class ScienceViewController: UIPageViewController {
    
    let scienceMessages: [String] = [
        "Recording your honest thoughts + feelings is proven to have a positive impact on mental wellbeing",
        "It helps clarify your emotions + enables you to better understand them",
        "Seeing the honest thoughts + feelings of people in our network alleviates pressure + helps us to understand we're not alone"
    ]
    lazy var controllers: [ScienceMessage] = {
        var idx = 0;
        return self.scienceMessages.map({ message in
            let controller: ScienceMessage = self.storyboard!.instantiateViewControllerWithIdentifier("ScienceMessage") as! ScienceMessage
            controller.message = message
            controller.index = idx
            idx += 1
            return controller
        })
    }()
    var index:Int = 0{
        didSet{
            if( index < 0 ){ index = controllers.count - 1 }
            else{ index = index % controllers.count; }
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.dataSource = self
        self.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.grayColor()
        self.setViewControllers( [controllers.first!], direction: .Forward, animated: true, completion: nil)
        self.view.setNeedsLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func toggleMenuNavigation(sender: AnyObject) {
        self.mm_drawerController.toggleDrawerSide(.Left, animated: true, completion: nil)
    }

}

extension ScienceViewController: UIPageViewControllerDataSource {
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let currentIndex = (viewController as! ScienceMessage).index
        if currentIndex <= 0 { return nil }
        else{ return self.controllers[ currentIndex - 1 ] }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let currentIndex = (viewController as! ScienceMessage).index
        if currentIndex >= self.controllers.count - 1 { return nil }
        else{ return self.controllers[ currentIndex + 1 ] }
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return controllers.count
    }
}

extension ScienceViewController: UIPageViewControllerDelegate {}