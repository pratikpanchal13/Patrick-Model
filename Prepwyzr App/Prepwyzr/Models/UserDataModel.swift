//
//  UserDataModel.swift
//  Prepwyzr
//
//  Created by Riddhi on 19/07/18.
//  Copyright © 2018 Riddhi. All rights reserved.
//

import UIKit

class UserDataModel: NSObject {

    var strEmailID = ""
    var strName = ""
    var strPhone = ""
    var strUserType = ""
    var strUsername = ""
    
    
    override init() {
      
        self.strEmailID = ""
        self.strName = ""
        self.strPhone = ""
        self.strUserType = ""
        self.strUsername = ""
        
    }
    
    convenience init(withDict:NSDictionary) {
        
        self.init()
        
        if let emailID = withDict.value(forKey: "emailID") {
            strEmailID = String(describing: emailID)
        }
        
        if let emailID = withDict.value(forKey: "name") {
            strName = String(describing: emailID)
        }
        
        if let emailID = withDict.value(forKey: "phone") {
            strPhone = String(describing: emailID)
        }
        
        if let emailID = withDict.value(forKey: "user_type") {
            strUserType = String(describing: emailID)
        }
        
        if let emailID = withDict.value(forKey: "username") {
            strUsername = String(describing: emailID)
        }
        strUsername = "bhargav"
        
    }
    
}
