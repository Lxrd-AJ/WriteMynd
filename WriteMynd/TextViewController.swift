//
//  TextViewController.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 19/05/2016.
//  Copyright © 2016 The Leaf. All rights reserved.
//

import UIKit
import SZTextView

class TextViewController: UIViewController {

    var onFinishCallback: (() -> Void)?
    
    lazy var textView: SZTextView = {
        let textView = SZTextView()
        textView.font = Label.font()
        textView.textColor = UIColor.wmSlateGreyColor()
        textView.delegate = self
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.lightGray.cgColor
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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: .finishedEditingTextView)
        
        self.view.backgroundColor = .white
        self.view.addSubview(promptMessage)
        self.view.addSubview(textView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.promptMessage.snp.makeConstraints({ make in
            make.top.equalTo(self.topLayoutGuide.snp.bottom).offset(10)
            make.left.equalTo(self.view.snp.leftMargin)
        })
        self.textView.snp.makeConstraints({ make in
            make.top.equalTo(self.promptMessage.snp.bottom)
            make.width.equalTo(self.view.snp.width).offset(-20)
            make.centerX.equalTo(self.view.snp.centerX)
            make.height.equalTo(175)
        })
    }
    
    func finishedEditingTextView(_ sender: UIBarButtonItem){
        print("Done Button called")
        onFinishCallback?()
        let _ = self.navigationController?.popViewController(animated: true)
    }
}

extension TextViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
}

private extension Selector {
    static let finishedEditingTextView = #selector(TextViewController.finishedEditingTextView(_:))
}
