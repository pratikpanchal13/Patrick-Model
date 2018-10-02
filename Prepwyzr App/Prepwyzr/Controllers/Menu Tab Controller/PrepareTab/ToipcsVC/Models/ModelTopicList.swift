//
//  ModelTopicList.swift
//  Demo
//
//  Created by pratik on 23/08/18.
//  Copyright © 2018 Mitul Mandanka. All rights reserved.
//

import Foundation
import Foundation

class ModelTopicList:NSObject{
    
    var count : Int?
    var topicID : Int?
    var topicName : String?
    
    class func parseTopicList(dict: [String: Any]) -> [ModelTopicList]? {
        
        guard let postData = dict["posts"] as? [[String:Any]] else { return nil}
        
        var array: [ModelTopicList] = [ModelTopicList]()
        for (_, dict) in postData.enumerated() {
            let model = ModelTopicList()
            
            if let Count = dict["count"] as? Int {
                model.count =  Int(Count)
            }
            if let TopicID = dict["topicID"] as? Int {
                model.topicID = TopicID
            }
            if let TopicName = dict["topicName"] as? String {
                model.topicName = TopicName
            }
            
            array.append(model)
        }
        return array
    }
}
