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
        label.textColor = .whiteColor()
        label.setFontSize(20)
        return label
    }()
    let body: Label! = {
        let label = Label()
        label.textColor = .whiteColor()
        label.numberOfLines = 0
        label.textAlignment = .Center
        label.setFontSize(16)
        return label
    }()
    lazy var closeButton: UIButton = {
        let button = UIButton(type: .Custom)
        button.setImage(UIImage(named: "cross-menu"), forState: .Normal)
        button.addTarget(self, action: .close, forControlEvents: .TouchUpInside)
        return button;
    }()
    var buttonAction:(() -> Void)?

    init( title:String, body:String, imageName:String, backgroundColor: UIColor ){
        self.iconView = UIImageView(image: UIImage(named: imageName))
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        closeButton.snp_makeConstraints(closure: { make in
            make.top.equalTo(self.view.snp_top).offset(20)
            make.left.equalTo(self.view.snp_left).offset(15)
            make.size.equalTo(CGSize(width: 12, height: 12))
        })
        
        iconView.snp_makeConstraints(closure: { make in
            make.top.equalTo(self.closeButton.snp_bottom).offset(5)
            make.centerX.equalTo(self.view.snp_centerX)
        })
        
        pageTitle.snp_makeConstraints(closure: { make in
            make.top.equalTo(iconView.snp_bottom).offset(40)
            make.centerX.equalTo(self.view.snp_centerX)
        })
        
        body.snp_makeConstraints(closure: { make in
            make.top.equalTo(pageTitle.snp_bottom).offset(30)
            make.centerX.equalTo(self.view.snp_centerX)
            make.width.equalTo(self.view.snp_width).offset(-10)
        })
    }
    
    func closeButtonTapped( sender: UIButton ){ buttonAction?() }

}

private extension Selector{
    static let close = #selector(OnboardViewController.closeButtonTapped(_:))
}
