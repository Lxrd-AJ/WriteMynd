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
        label.textColor = .white
        label.text = "Legals";
        return label;
    }()
    
    lazy var mascot: UIImageView = {
        let mascot:UIImageView = UIImageView(image: UIImage(named: "happyManStood"))
        mascot.contentMode = .center
        return mascot
    }()
    
    lazy var textView: Label = {
        let textView: Label = Label()
        //textView.setFontSize(15)
        textView.font = UIFont(name: "Baskerville", size: 16)
        textView.numberOfLines = 0
        textView.textColor = UIColor.black
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
        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {
//            let path = NSBundle.mainBundle().pathForResource("legal", ofType: "txt")
//            do {
//                let contents = try String(contentsOfFile: path!)
//                dispatch_async(dispatch_get_main_queue()) {
//                    self.textView.text = contents
//                    print("\(contents.characters.count) words")
//                    print(contents)
//                }
//            }catch{
//                print(error)
//            }
//        })
        
        let path = Bundle.main.path(forResource: "legal", ofType: "txt")
        do {
            let contents = try String(contentsOfFile: path!)
            self.textView.text = contents
            print("\(contents.characters.count) words")
            print(contents)
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
        
        scrollView.snp.makeConstraints( { make in
            make.top.equalTo(self.topLayoutGuide.snp.bottom)
            make.bottom.equalTo(self.view.snp.bottom)
            make.width.equalTo(self.view.snp.width)
        })

        headerView.snp.makeConstraints( { make in
            make.top.equalTo(self.scrollView.snp.top)
            make.width.equalTo(self.view.snp.width)
            make.height.equalTo(180)
        })
        titleLabel.snp.makeConstraints( { make in
            make.left.equalTo(headerView.snp.left).offset(5)
            make.top.equalTo(headerView.snp.top).offset(5)
        })
        mascot.snp.makeConstraints( { make in
            make.right.equalTo(headerView.snp.right).offset(-5)
            make.bottom.equalTo(headerView.snp.bottom).offset(-5)
        })
        textView.snp.makeConstraints( { make in
            make.top.equalTo(headerView.snp.bottom)
            make.width.equalTo(self.view.snp.width).offset(-10)
            make.centerX.equalTo(self.scrollView.snp.centerX)
            make.bottom.equalTo(scrollView.snp.bottom)
        })
        print(textView.frame)
    }
    

}
