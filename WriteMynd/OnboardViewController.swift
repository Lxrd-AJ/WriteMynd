//
//  OnboardViewController.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 24/05/2016.
//  Copyright © 2016 The Leaf. All rights reserved.
//

import UIKit

class OnboardViewController: UIViewController {

    let iconView: UIImageView!
    let pageTitle: Label! = {
        let label = Label()
        label.textColor = UIColor.white
        label.setFontSize(20)
        return label
    }()
    let body: Label! = {
        let label = Label()
        label.textColor = UIColor.white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.setFontSize(16)
        return label
    }()
    lazy var closeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "cross-menu"), for: UIControlState())
        button.addTarget(self, action: .close, for: .touchUpInside)
        return button;
    }()
    lazy var bottomButton: UIButton = {
        let button = Button(type: .custom)
        button.addTarget(self, action: .bottomButton, for: .touchUpInside)
        button.setTitleColor(UIColor.wmCoolBlueColor(), for: UIControlState())
        button.isHidden = true;
        return button;
    }()
    var buttonAction:(() -> Void)?
    var bottomButtonAction: (() -> Void)?

    init( title:String, body:String, animationImageNames:[String], imageName:String, backgroundColor: UIColor ){
        self.iconView = UIImageView(image: UIImage(named: imageName))
        self.iconView.animationImages = animationImageNames.map({ return UIImage(named: $0)! })
        self.iconView.animationDuration = 1.5
        self.iconView.animationRepeatCount = 1;
        self.iconView.contentMode = .center
        self.pageTitle.text = title
        self.body.text = body;
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = backgroundColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(closeButton)
        self.view.addSubview(iconView)
        self.view.addSubview(pageTitle)
        self.view.addSubview(body)
        self.view.addSubview(bottomButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //self.iconView.startAnimating()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        closeButton.snp.makeConstraints({ make in
            make.top.equalTo(self.view.snp.top).offset(25)
            make.left.equalTo(self.view.snp.left).offset(20)
            make.size.equalTo(CGSize(width: 15, height: 15))
        })
        
        iconView.snp.makeConstraints({ make in
            make.top.equalTo(self.closeButton.snp.bottom).offset(20)
            //make.left.equalTo(self.view.snp.left).multipliedBy(0.4)
            make.centerX.equalTo(self.view.snp.centerX)
            //make.centerY.equalTo(100)
            //make.size.equalTo(CGSize(width: 150, height: 190)) //130,170
            make.width.equalTo(self.view.snp.width)
            make.height.equalTo(180)
        })
        
        pageTitle.snp.makeConstraints({ make in
            make.top.equalTo(iconView.snp.bottom).offset(40)
            make.centerX.equalTo(self.view.snp.centerX)
        })
        
        body.snp.makeConstraints({ make in
            make.top.equalTo(pageTitle.snp.bottom).offset(30)
            make.centerX.equalTo(self.view.snp.centerX)
            make.width.equalTo(self.view.snp.width).offset(-10)
        })
        
        bottomButton.snp.makeConstraints({ make in
            make.bottom.equalTo(self.view.snp.bottom).offset(-10)
            make.centerX.equalTo(self.view.snp.centerX)
        })
    }
    
    func closeButtonTapped( _ sender: UIButton ){ buttonAction?() }
    func bottonButtonTapped( _ sender:UIButton){ bottomButtonAction?() }

}

private extension Selector{
    static let close = #selector(OnboardViewController.closeButtonTapped(_:))
    static let bottomButton = #selector(OnboardViewController.bottonButtonTapped(_:))
}
