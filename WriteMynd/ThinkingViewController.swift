//
//  ThinkingViewController.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 30/04/2016.
//  Copyright © 2016 The Leaf. All rights reserved.
//

import UIKit

class ThinkingViewController: ViewController {

    let scrollView = UIScrollView()
    let contentView = UIView()
    let page1 = ThinkingPage()
    let page2 = ThinkingPage()
    let page3 = ThinkingPage()
    let page4 = ThinkingPage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.wmBackgroundColor()
        self.automaticallyAdjustsScrollViewInsets = false
        
        
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(contentView)
        self.contentView.addSubview(page1)
        self.contentView.addSubview(page2)
        self.contentView.addSubview(page3)
        self.contentView.addSubview(page4)

        let page1Path = NSBundle.mainBundle().pathForResource("thinking1", ofType: "txt")
        let page2Path = NSBundle.mainBundle().pathForResource("thinking2", ofType: "txt")
        let page3Path = NSBundle.mainBundle().pathForResource("thinking3", ofType: "txt")
        let page4Path = NSBundle.mainBundle().pathForResource("thinking4", ofType: "txt")
        do {
            let contents = try String(contentsOfFile: page1Path!)
            self.page1.page1Message.text = contents
            self.page2.page1Message.text = try String(contentsOfFile: page2Path!)
            self.page3.page1Message.text = try String(contentsOfFile: page3Path!)
            self.page4.page1Message.text = try String(contentsOfFile: page4Path!)
        }catch{
            print(error)
        }

        page2.page1TitleLabel.attributedText = nil
        page2.page1TitleLabel.text = "record"
        page2.page1SubTitle.text = ""
        page2.header.backgroundColor = UIColor.wmSlateGreyColor()
        page2.page1Mascot.image = UIImage(named: "photoGuy")
        
        page3.page1TitleLabel.attributedText = nil
        page3.page1TitleLabel.text = "reflect"
        page3.page1SubTitle.text = ""
        page3.page1Mascot.image = UIImage(named: "manInTheMirror")
        page3.header.backgroundColor = UIColor.wmBoogerColor()
        
        page4.page1TitleLabel.attributedText = nil
        page4.page1TitleLabel.text = "share"
        page4.page1SubTitle.text = ""
        page4.page1Mascot.image = UIImage(named: "shareMan")
        page4.header.backgroundColor = UIColor.wmLightGoldColor()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.contentSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.height + 150.0)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        scrollView.snp_makeConstraints(closure: { make in
            make.top.equalTo(self.snp_topLayoutGuideBottom)
            make.bottom.equalTo(self.view.snp_bottom)
            make.width.equalTo(self.view.snp_width)
        })
        
        page1.snp_makeConstraints(closure: { make in
            make.top.equalTo(self.scrollView.snp_top)
            make.width.equalTo(self.view.snp_width)
        })
        
        page2.snp_makeConstraints(closure: { make in
            make.top.equalTo(page1.snp_bottom).offset(20)
            make.width.equalTo(self.view.snp_width)
        })
        
        page3.snp_makeConstraints(closure: { make in
            make.top.equalTo(page2.snp_bottom).offset(20)
            make.width.equalTo(self.view.snp_width)
        })
        
        page4.snp_makeConstraints(closure: { make in
            make.top.equalTo(page3.snp_bottom).offset(20)
            make.width.equalTo(self.view.snp_width)
            make.bottom.equalTo(self.scrollView.snp_bottom)
        })
        
    }

}

extension ThinkingViewController {
    
    
}

