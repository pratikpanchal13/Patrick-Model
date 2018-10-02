//
//  ModelPracticTestList.swift
//  Demo
//
//  Created by pratik on 24/08/18.
//  Copyright © 2018 Mitul Mandanka. All rights reserved.
//

import Foundation


class ModelPracticTestList:NSObject{
    
    var ans : String?
    var expImg : String?
    var explanation : String?
    var marks : Int?
    var optA : String?
    var optAImg : String?
    var optB : String?
    var optBImg : String?
    var optC : String?
    var optCImg : String?
    var optD : String?
    var optDImg : String?
    var optE : String?
    var optEImg : String?
    var optF : String?
    var optFImg : String?
    var optG : String?
    var optGImg : String?
    var optH : String?
    var optHImg : String?
    var quesImg : String?
    var question : String?
    var questionID : Int?
    var type : String?

    var flag : String?
    var UnFlag : String?
    var UserAnswer : String?

    
    class func parseModelPracticTestList(dict : [String:Any]) -> [ModelPracticTestList]? {
        
        guard let posts = dict["posts"] as? [[String:Any]] else { return nil }
        var array: [ModelPracticTestList] = [ModelPracticTestList]()

        
        for (_ , dict) in posts.enumerated(){
            let model = ModelPracticTestList()
        
            model.flag = "0"
            model.UnFlag = "0"
            model.UserAnswer = ""
            
            if let Ans = dict["ans"] as? String {
                model.ans = Ans
            }
            
            if let ExpImg = dict["expImg"] as? String {
                model.expImg = ExpImg
            }
            if let Explanation = dict["explanation"] as? String {
                model.explanation = Explanation
            }
            if let Marks = dict["marks"] as? Int {
                model.marks = Marks
            }
            if let OptA = dict["optA"] as? String {
                model.optA = OptA
            }
            if let OptAImg = dict["optAImg"] as? String {
                model.optAImg = OptAImg
            }
            if let OptB = dict["optB"] as? String {
                model.optB = OptB
            }
            if let OptBImg = dict["optBImg"] as? String {
                model.optBImg = OptBImg
            }
            if let OptC = dict["optC"] as? String {
                model.optC = OptC
            }
            if let OptCImg = dict["optCImg"] as? String {
                model.optCImg = OptCImg
            }
            if let OptD = dict["optD"] as? String {
                model.optD = OptD
            }
            if let OptDImg = dict["optDImg"] as? String {
                model.optDImg = OptDImg
            }
            if let OptE = dict["optE"] as? String {
                model.optE = OptE
            }
            if let OptEImg = dict["optEImg"] as? String {
                model.optEImg = OptEImg
            }
            if let OptF = dict["optF"] as? String {
                model.optF = OptF
            }
            if let OptFImg = dict["optFImg"] as? String {
                model.optFImg = OptFImg
            }
            if let OptG = dict["optG"] as? String {
                model.optG = OptG
            }
            if let OptGImg = dict["optGImg"] as? String {
                model.optGImg = OptGImg
            }
            if let OptH = dict["optH"] as? String {
                model.optH = OptH
            }
            if let OptHImg = dict["optHImg"] as? String {
                model.optHImg = OptHImg
            }
            if let QuesImg = dict["quesImg"] as? String {
                model.quesImg = QuesImg
            }
            if let Question = dict["question"] as? String {
                model.question = Question
            }
            if let QuestionID = dict["questionID"] as? Int {
                model.questionID = QuestionID
            }
            if let Type = dict["type"] as? String {
                model.type = Type
            }
          
            
            
            array.append(model)
        }
        return array
    }
    
    
}
