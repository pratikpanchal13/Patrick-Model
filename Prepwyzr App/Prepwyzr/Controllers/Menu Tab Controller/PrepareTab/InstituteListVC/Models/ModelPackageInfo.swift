//
//  ModelPackageInfo.swift
//  Demo
//
//  Created by pratik on 22/08/18.
//  Copyright © 2018 Mitul Mandanka. All rights reserved.
//
import Foundation

class ModelPackage{
    
    var packageID : Int?
    var packageName : String?
    var price :  Int?
    var subscribed : Int?
    var success : Int?
    
    var childData: [ModelPackageInfoSub]?

    class func parseModelPackage(dict: [String: Any] , childData:[ModelPackageInfoSub]?) -> ModelPackage? {
        
        let model = ModelPackage()
        if let PackageID = dict["packageID"] as? Int {
            model.packageID = PackageID
        }
        if let PackageName = dict["packageName"] as? String {
            model.packageName =  PackageName
        }
        if let Price = dict["price"] as? Int {
            model.price =  Price
        }
        if let Subscribed = dict["subscribed"] as? Int {
            model.subscribed =  Subscribed
        }
        if let Success = dict["success"] as? Int {
            model.success =  Success
        }
        model.childData = childData
        
        return model
    }
        
}

class ModelPackageInfoSub:NSObject{
    var courseID : String?
    var courseName : String?
    
    var packageID : Int?
    var packageName : String?
    var price :  Int?
    var subscribed : Int?
    var success : Int?
    
    class func parseModelInstituteList(dict: [String: Any]) -> [ModelPackageInfoSub]? {
        
        guard let posts = dict["courses"] as? [[String:Any]] else { return nil}
        
        
        
        var array: [ModelPackageInfoSub] = [ModelPackageInfoSub]()
        for (_, dict) in posts.enumerated() {
            let model = ModelPackageInfoSub()
            
            if let CourseID = dict["course_id"] as? String {
                model.courseID = CourseID
            }
            if let CourseName = dict["course_name"] as? String {
                model.courseName =  CourseName
            }
            
            array.append(model)
        }
        
        return array
    }
}
