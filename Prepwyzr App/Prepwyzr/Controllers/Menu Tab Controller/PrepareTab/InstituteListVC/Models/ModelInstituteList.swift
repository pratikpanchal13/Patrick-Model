//
//  ModelInstituteList.swift
//  Demo
//
//  Created by pratik on 22/08/18.
//  Copyright © 2018 Mitul Mandanka. All rights reserved.
//

import Foundation

class ModelInstituteList:NSObject{
    var instituteID : String?
    var name : String?
    var type : String?
  
    
    class func parseModelInstituteList(dict: [String: Any]) -> [ModelInstituteList]? {
        
        guard let posts = dict["posts"] as? [[String:Any]] else { return nil}
        
        var array: [ModelInstituteList] = [ModelInstituteList]()
        for (_, dict) in posts.enumerated() {
            let model = ModelInstituteList()
            
            if let instituteID = dict["instituteID"] as? String {
                model.instituteID = instituteID
            }
            if let Name = dict["name"] as? String {
                model.name =  Name
            }
            if let Type = dict["type"] as? String {
                model.type = Type
            }
            array.append(model)
        }
        return array
    }
}
