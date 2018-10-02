//
//  ModelTopicRank.swift
//  Demo
//
//  Created by pratik on 22/08/18.
//  Copyright © 2018 Mitul Mandanka. All rights reserved.
//

import Foundation

class ModelTopicRank:NSObject{
    var percentage : Double?
    var user : String?
    
    class func parseTopicRank(dict: [String: Any]) -> [ModelTopicRank]? {
        
        guard let instituteID = dict["posts"] as? [[String:Any]] else { return nil}
        
        var array: [ModelTopicRank] = [ModelTopicRank]()
        for (_, dict) in instituteID.enumerated() {
            let model = ModelTopicRank()
            
            if let Percentage = dict["percentage"] as? Double {
                model.percentage =  Double(Percentage)
            }
            if let User = dict["user"] as? String {
                model.user = User
            }

            array.append(model)
        }
        return array
    }
}
