//
//  ReportedPost.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 06/06/2016.
//  Copyright © 2016 The Leaf. All rights reserved.
//

import Foundation
import Parse

class ReportedPost {
    var objectID: String?
    var reporter: PFUser
    var postID: String
    var reportDate: NSDate
    
    init( postID:String, reporter:PFUser ){
        self.postID = postID;
        self.reporter = reporter
        self.reportDate = NSDate()
    }
    
    func save(){
        let object = PFObject(className: "ReportedPost")
        object["reporterID"] = self.reporter.objectId
        object["postID"] = self.postID
        self.objectID = object.objectId
        object.saveInBackground()
    }
    
    class func convertPFObjectToReportedPost( object:PFObject ) -> ReportedPost {
        let reporter = PFUser(withoutDataWithObjectId: object["reporterID"] as? String )
        let reportedPost = ReportedPost(postID: object["postID"] as! String, reporter: reporter)
        reportedPost.reportDate = object.createdAt!
        return reportedPost
    }
}
