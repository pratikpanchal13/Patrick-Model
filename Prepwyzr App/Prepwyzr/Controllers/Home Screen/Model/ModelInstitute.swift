//
//  ModelInstitute.swift
//  Demo
//
//  Created by pratik on 21/08/18.
//  Copyright © 2018 Mitul Mandanka. All rights reserved.
//

import Foundation

class ModelInstitute:NSObject{
    var instituteID : String?
    var name : String?
    var type : String?
    
    class func parseInstituteSub(dict: [String: Any]) -> [ModelInstitute]? {
        
        guard let instituteID = dict["posts"] as? [[String:Any]] else { return nil}
        
        var array: [ModelInstitute] = [ModelInstitute]()
        for (_, dict) in instituteID.enumerated() {
            let model = ModelInstitute()
            
            if let InstituteID = dict["instituteID"] as? String {
                model.instituteID = InstituteID
            }
            if let Name = dict["name"] as? String {
                model.name = Name
            }
            if let Type = dict["type"] as? String {
                model.type = Type
            }
            array.append(model)
        }
        return array
    }
}


