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
        self.closeButton.isHidden = true
        self.bottomButton.isHidden = false
        self.bottomButton.setTitle("Read Licence Agreement", for: UIControlState())
        
        let disagreeButton = self.createButton("Disagree")
        let agreeButton = self.createButton("Agree")
        disagreeButton.backgroundColor = UIColor.wmCoolBlueColor()
        disagreeButton.addTarget(self, action: .disagree, for: .touchUpInside)
        agreeButton.backgroundColor = UIColor.wmFadedRedColor()
        agreeButton.addTarget(self, action: .agree, for: .touchUpInside)
        
        buttonStackView.axis = .horizontal
        buttonStackView.alignment = .fill
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 5.0
        buttonStackView.addArrangedSubview(disagreeButton)
        buttonStackView.addArrangedSubview(agreeButton)
        
        self.view.addSubview(buttonStackView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        bottomButton.snp.remakeConstraints({ make in
            make.top.equalTo(body.snp.bottom).offset(6)
            make.centerX.equalTo(self.view.snp.centerX)
        })
        
        buttonStackView.snp.makeConstraints({ make in
            make.bottom.equalTo(self.view.snp.bottom).offset(-20)
            make.width.equalTo(self.view.snp.width).offset(-10)
            make.centerX.equalTo(self.view.snp.centerX)
            make.height.equalTo(45)
        })
    }
    
    func createButton( _ titleText:String ) -> Button {
        let button = Button(type: .custom)
        button.setTitle(titleText, for: UIControlState())
        button.layer.cornerRadius = 5.0
        button.layer.borderColor = UIColor.black.cgColor
        return button;
    }
    
    func onAgree( _ sender:UIButton ){ onAgreeAction?() }
    func onDisagree( _ sender:UIButton ){ onDeclineAction?() }

}

private extension Selector {
    static let agree = #selector(LicensePageViewController.onAgree(_:))
    static let disagree = #selector(LicensePageViewController.onDisagree(_:))
}
