//
//  ModelTopics.swift
//  Demo
//
//  Created by pratik on 22/08/18.
//  Copyright © 2018 Mitul Mandanka. All rights reserved.
//

import Foundation

class ModelTopicSub:NSObject{
    var topicID : Int?
    var percentage : Double?
    var topicName : String?
    
    class func parseModelTopic(dict: [String: Any]) -> [ModelTopicSub]? {
        
        guard let posts = dict["posts"] as? [[String:Any]] else { return nil}
        
        var array: [ModelTopicSub] = [ModelTopicSub]()
        for (_, dict) in posts.enumerated() {
            let model = ModelTopicSub()
            
            if let TopicID = dict["topicID"] as? Int {
                model.topicID = TopicID
            }
            if let Percentage = dict["percentage"] as? Double {
                model.percentage =  Double(Percentage)
            }
            if let TopicName = dict["topicName"] as? String {
                model.topicName = TopicName
            }
            array.append(model)
        }
        return array
    }
}
