//
//  LegalViewController.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 29/04/2016.
//  Copyright © 2016 The Leaf. All rights reserved.
//

import UIKit

class LegalViewController: UIViewController {
    
    lazy var titleLabel: Label = {
        let label: Label = Label()
        label.setFontSize(20)
        label.textColor = .whiteColor()
        label.text = "Privacy Policy";
        return label;
    }()
    
    lazy var mascot: UIImageView = {
        let mascot:UIImageView = UIImageView(image: UIImage(named: "happyManStood"))
        mascot.contentMode = .Center
        return mascot
    }()
    
    lazy var textView: Label = {
        let textView: Label = Label()
        //textView.setFontSize(15)
        textView.font = UIFont(name: "Baskerville", size: 16)
        textView.numberOfLines = 0
        textView.textColor = UIColor.blackColor()
        return textView
    }()
    
    let headerView: UIView = UIView()
    let scrollView = UIScrollView()
    let contentView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = self.view.bounds.size
        
        self.view.backgroundColor = UIColor.wmBackgroundColor()
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.view.addSubview(scrollView)
        self.contentView.addSubview(headerView)
        self.contentView.addSubview(textView)
        self.scrollView.addSubview(contentView)
        
        headerView.backgroundColor = UIColor.wmDarkSkyBlueColor()
        headerView.addSubview(titleLabel)
        headerView.addSubview(mascot)
        
        let path = NSBundle.mainBundle().pathForResource("legal", ofType: "txt")
        do {
            let contents = try String(contentsOfFile: path!)
            self.textView.text = contents
            print("\(contents.characters.count) words")
        }catch{
            print(error)
        }
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

        headerView.snp_makeConstraints(closure: { make in
            make.top.equalTo(self.scrollView.snp_top)
            make.width.equalTo(self.view.snp_width)
            make.height.equalTo(180)
        })
        titleLabel.snp_makeConstraints(closure: { make in
            make.left.equalTo(headerView.snp_left).offset(5)
            make.top.equalTo(headerView.snp_top).offset(5)
        })
        mascot.snp_makeConstraints(closure: { make in
            make.right.equalTo(headerView.snp_right).offset(-5)
            make.bottom.equalTo(headerView.snp_bottom).offset(-5)
        })
        textView.snp_makeConstraints(closure: { make in
            make.top.equalTo(headerView.snp_bottom)
            make.width.equalTo(self.view.snp_width).offset(-10)
            make.centerX.equalTo(self.scrollView.snp_centerX)
            make.bottom.equalTo(scrollView.snp_bottom)
        })
        
    }
    

}
