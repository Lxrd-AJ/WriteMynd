//
//  Endurance.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 12/06/2016.
//  Copyright © 2016 The Leaf. All rights reserved.
//

import Foundation
import PromiseKit
import Alamofire
import SwiftyJSON

class Endurance {
    
    class func checkIfUserBlocked( _ userID:String ) -> Promise<Bool>{
        return Promise { fulfill, reject in
            let url = serverURL + "/is_user_blocked"
            Alamofire.request(url,parameters: ["userID":userID]).responseJSON(completionHandler: { response in
                print(response)
                if let data = response.result.value {
                    let json = JSON(data)
                    fulfill( json["result"].bool! )
                }else{
                    print(response.result.error!)
                    reject(response.result.error!)
                }
            })
        }
    }
    
    class func showBlockedUserPage( _ onController:UIViewController ){
        let page = OnboardViewController(title: "User Account Blocked", body: "You have been removed from the app due to a post that was reported by another user as offensive.\nPlease read our End User Licence Agreement here", animationImageNames: [], imageName: "mehManStood", backgroundColor: UIColor.wmFadedRedColor())
        page.bottomButton.setTitle("End User Agreement", for: .normal)
        page.bottomButton.isHidden = false
        page.buttonAction = {
            page.dismiss(animated: true, completion: nil)
        }
        page.bottomButtonAction = {
            page.dismiss(animated: true, completion: nil)
            onController.navigationController?.pushViewController(LegalViewController(), animated: true)
        }
        onController.present(page, animated: true, completion: nil)
    }
    
    class func showEndUserLicensePage( _ reciever:UIViewController, onAgreeAction:@escaping (() -> Void) ){
        let licensePage = LicensePageViewController(title: "End User Licence Agreement", body: "Please review and agree to our End User Licence Agreement before using the app", animationImageNames: [], imageName: "noEmotion", backgroundColor: UIColor.wmSilverTwoColor())
        licensePage.bottomButtonAction = {
            let legalVC = LegalViewController()
            licensePage.navigationController?.pushViewController(legalVC, animated: true)
            legalVC.navigationController?.isNavigationBarHidden = false
        }
        licensePage.onDeclineAction = {
            let _ = licensePage.navigationController?.popViewController(animated: true)
        }
        licensePage.onAgreeAction = {
            let _ = licensePage.navigationController?.popViewController(animated: true)
            onAgreeAction()
        }
        reciever.navigationController?.pushViewController(licensePage, animated: true)
        
    }

}
