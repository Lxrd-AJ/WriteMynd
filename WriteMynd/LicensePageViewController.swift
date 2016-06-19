//
//  LicensePageViewController.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 15/06/2016.
//  Copyright © 2016 The Leaf. All rights reserved.
//

import UIKit

class LicensePageViewController: OnboardViewController {

    let buttonStackView: UIStackView = UIStackView()
    var onDeclineAction:(() -> Void)?
    var onAgreeAction:(() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.closeButton.hidden = true
        self.bottomButton.hidden = false
        self.bottomButton.setTitle("Read Licence Agreement", forState: .Normal)
        
        let disagreeButton = self.createButton("Disagree")
        let agreeButton = self.createButton("Agree")
        disagreeButton.backgroundColor = UIColor.wmCoolBlueColor()
        disagreeButton.addTarget(self, action: .disagree, forControlEvents: .TouchUpInside)
        agreeButton.backgroundColor = UIColor.wmFadedRedColor()
        agreeButton.addTarget(self, action: .agree, forControlEvents: .TouchUpInside)
        
        buttonStackView.axis = .Horizontal
        buttonStackView.alignment = .Fill
        buttonStackView.distribution = .FillEqually
        buttonStackView.spacing = 5.0
        buttonStackView.addArrangedSubview(disagreeButton)
        buttonStackView.addArrangedSubview(agreeButton)
        
        self.view.addSubview(buttonStackView)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        bottomButton.snp_remakeConstraints(closure: { make in
            make.top.equalTo(body.snp_bottom).offset(6)
            make.centerX.equalTo(self.view.snp_centerX)
        })
        
        buttonStackView.snp_makeConstraints(closure: { make in
            make.bottom.equalTo(self.view.snp_bottom).offset(-20)
            make.width.equalTo(self.view.snp_width).offset(-10)
            make.centerX.equalTo(self.view.snp_centerX)
            make.height.equalTo(45)
        })
    }
    
    func createButton( titleText:String ) -> Button {
        let button = Button(type: .Custom)
        button.setTitle(titleText, forState: .Normal)
        button.layer.cornerRadius = 5.0
        button.layer.borderColor = UIColor.blackColor().CGColor
        return button;
    }
    
    func onAgree( sender:UIButton ){ onAgreeAction?() }
    func onDisagree( sender:UIButton ){ onDeclineAction?() }

}

private extension Selector {
    static let agree = #selector(LicensePageViewController.onAgree(_:))
    static let disagree = #selector(LicensePageViewController.onDisagree(_:))
}
