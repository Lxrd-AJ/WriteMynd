//
//  ScienceViewController.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 19/02/2016.
//  Copyright © 2016 The Leaf. All rights reserved.
//

import UIKit

class ScienceViewController: UIPageViewController {
    
    let scienceMessages: [String] = [
        "Recording your honest thoughts + feelings is proven to have a positive impact on mental wellbeing",
        "It helps clarify your emotions + enables you to better understand them",
        "Seeing the honest thoughts + feelings of people in our network alleviates pressure + helps us to understand we're not alone"
    ]
    lazy var controllers: [ScienceMessage] = {
        return self.scienceMessages.map({ message in
            let controller: ScienceMessage = self.storyboard!.instantiateViewControllerWithIdentifier("ScienceMessage") as! ScienceMessage
            controller.message = message
            return controller
        })
    }()
    var index: Int = 0
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.dataSource = self
        self.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.grayColor()
        self.setViewControllers( [controllers.first!], direction: .Forward, animated: true, completion: nil)
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
        guard index != 0 else{ return nil }
        index -= 1
        print(index)
        return controllers[index]
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        index += 1
        guard index != controllers.count else { return nil }
        print(index)
        return controllers[index]
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return controllers.count
    }
}

extension ScienceViewController: UIPageViewControllerDelegate {}