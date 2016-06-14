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
    
    class func checkIfUserBlocked( userID:String ) -> Promise<Bool>{
        return Promise { fulfill, reject in
            let url = serverURL + "/is_user_blocked"
            Alamofire.request(.GET,url,parameters: ["userID":userID]).responseJSON(completionHandler: { response in
                print(response)
                switch response.result {
                case .Success(let data):
                    let json = JSON(data)
                    fulfill( json["result"].bool! )
                case .Failure(let error):
                    print(error)
                    reject(error)
                }
            })
        }
    }
    
    class func showBlockedUserPage( onController:UIViewController ){
        let page = OnboardViewController(title: "User Account Blocked", body: "You have been removed from the app due to a post that was reported by another user as offensive.\nPlease read our End User Licence Agreement here", animationImageNames: [], imageName: "mehManStood", backgroundColor: UIColor.wmFadedRedColor())
        page.bottomButton.setTitle("End User Agreement", forState: .Normal)
        page.bottomButton.hidden = false
        page.buttonAction = {
            page.dismissViewControllerAnimated(true, completion: nil)
        }
        page.bottomButtonAction = {
            page.dismissViewControllerAnimated(true, completion: nil)
            onController.navigationController?.pushViewController(LegalViewController(), animated: true)
        }
        onController.presentViewController(page, animated: true, completion: nil)
    }

}