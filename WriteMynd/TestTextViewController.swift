//
//  TestTextViewController.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 19/05/2016.
//  Copyright © 2016 The Leaf. All rights reserved.
//

import UIKit
import SZTextView

class TestTextViewController: UIViewController {

    var onFinishCallback: (() -> Void)?
    
    lazy var textView: SZTextView = {
        let textView = SZTextView()
        textView.font = Label.font()
        textView.textColor = UIColor.wmSlateGreyColor()
        textView.delegate = self
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.lightGrayColor().CGColor
        return textView
    }()
    
    lazy var promptMessage: Label = {
        var label = Label()
        label.text = "Write a Post"
        label.textColor = UIColor.wmCoolBlueColor()
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.titleView = UIImageView(image: UIImage(named: "stroke5"))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: .finishedEditingTextView)
        
        self.view.backgroundColor = .whiteColor()
        self.view.addSubview(promptMessage)
        self.view.addSubview(textView)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.promptMessage.snp_makeConstraints(closure: { make in
            make.top.equalTo(self.snp_topLayoutGuideBottom).offset(10)
            make.left.equalTo(self.view.snp_leftMargin)
        })
        self.textView.snp_makeConstraints(closure: { make in
            make.top.equalTo(self.promptMessage.snp_bottom)
            make.width.equalTo(self.view.snp_width).offset(-20)
            make.centerX.equalTo(self.view.snp_centerX)
            make.height.equalTo(175)
        })
    }
    
    func finishedEditingTextView(sender: UIBarButtonItem){
        print("Done Button called")
        onFinishCallback?()
        self.navigationController?.popViewControllerAnimated(true)
    }
}

extension TestTextViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        return true
    }
}

private extension Selector {
    static let finishedEditingTextView = #selector(TestTextViewController.finishedEditingTextView(_:))
}