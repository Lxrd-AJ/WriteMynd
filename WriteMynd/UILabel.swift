//
//  UILabel.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 19/03/2016.
//  Copyright © 2016 The Leaf. All rights reserved.
//

import Foundation
import JTSActionSheet

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "stroke5"))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "search"), style: .plain, target: self, action: .search)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "hamburger"), style: .plain, target: self, action: .toggleMenu)
        self.navigationItem.rightBarButtonItem?.tintColor = .wmCoolBlueColor()
        self.navigationItem.leftBarButtonItem?.tintColor = .wmCoolBlueColor()
    }
    
    func toggleMenu( _ sender:UIBarButtonItem ){
        self.mm_drawerController.toggle(.left, animated: true, completion: nil)
    }
    
    func presentSearchView( _ sender:UIBarButtonItem ){
        self.navigationController?.pushViewController(SearchViewController(), animated: true)
    }
}

private extension Selector {
    static let toggleMenu = #selector(ViewController.toggleMenu(_:))
    static let search = #selector(ViewController.presentSearchView(_:))
}

func global_getActionSheetTheme() -> JTSActionSheetTheme {
    let theme = JTSActionSheetTheme.default()
    theme?.normalButtonFont = UIFont(name: "Montserrat-Regular", size: 15.0)!
    theme?.normalButtonColor = UIColor.white
    theme?.destructiveButtonColor = UIColor.wmSilverColor()
    theme?.backgroundColor = UIColor.wmGreenishTealColor()
    return theme!
}

class Label: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.font = UIFont(name: "Montserrat-Regular", size: 15.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeBold(){
        self.font = UIFont(name: "Montserrat-Bold", size: 15.0)
    }
    
    func setFontSize( _ size:CGFloat ){
        self.font = UIFont(name: "Montserrat-Regular", size: size)!
    }
    
    static func font() -> UIFont{
        return UIFont(name: "Montserrat-Regular", size: 15.0)!
    }
    
}








