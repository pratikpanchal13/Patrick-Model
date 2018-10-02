//
//  Webservice.swift
//  twoClosets
//
//  Created by Riddhi on 09/10/17.
//  Copyright © 2017 Xpro Developers. All rights reserved.
//

import Foundation
import Alamofire
import UIKit
import SystemConfiguration
import MBProgressHUD

class Webservice {
    
    //    let webservice = Webservice()
    
    //check internet utility
    class func isNetworkAvailable() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
    

}

extension Webservice {
    
    //MARK:- POST METHODS
    class func API(_ url: String,
                    param: [String: Any]?,
                    controller: UIViewController,
                    header : [String: String]?,
                    callSilently : Bool = false,
                    methodType:HTTPMethod,
                    isDisplayAlertWhenError:Bool = true,
                    successBlock: @escaping (_ response: NSDictionary) -> Void,
                    failureBlock: @escaping (_ error: Error? , _ isTimeOut: Bool) -> Void) {
        
        // Internet is connected
        if isNetworkAvailable() {
            
            if !callSilently {
                MBProgressHUD.showAdded(to: (UIApplication.shared.delegate?.window!)! , animated: true)
            }
            
            let urlWithUTF8 =  url.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
            if ISDebug {   print("URL : \(urlWithUTF8!)");   }
            
            Alamofire.request(urlWithUTF8!, method: methodType, parameters: param, encoding: URLEncoding.default, headers: header).responseJSON(completionHandler: { (response) in
                
                if !callSilently {
                    DispatchQueue.main.async {
                        MBProgressHUD.hide(for: ((UIApplication.shared.delegate?.window)!)!, animated: true)
                    }
                }
                
                print("---- POST REQUEST URL RESPONSE : \(urlWithUTF8!)\n\(response.result)")
                print(response.timeline)
                
                switch response.result {
                case .success:
                    
                    if let aJSON = response.result.value as? NSDictionary {
                        successBlock(aJSON)
                    }
                    
                case .failure(let error):
                    print(error)
                    if (error as NSError).code == -1001 {
                        // The request timed out error occured. // Code=-1001 "The request timed out."
                        
                        if isDisplayAlertWhenError {
                            UIAlertController.showAlertWithOkButton(controller, aStrMessage: "The request timed out. Pelase try after again.", completion: nil)
                        }
                        failureBlock(error, true)
                    } else {
                        if isDisplayAlertWhenError {
                            UIAlertController.showAlertWithOkButton(controller, aStrMessage: "Something went wrong", completion: nil)
                        }
                        failureBlock(error, false)
                    }
                    break
                }
                
            })
            
        }
        else{
            
            // Internet is not connected
            if isDisplayAlertWhenError {
                UIAlertController.showAlertWithOkButton(controller, aStrMessage: "Internet is not available", completion: nil)
            }
            let aErrorConnection = NSError(domain: "InternetNotAvailable", code: 0456, userInfo: nil)
            failureBlock(aErrorConnection as Error , false)
        }
    }
    
    class func POSTWithMultiPart(_ url: String,
                             images:NSDictionary,
                             param: NSDictionary,
                             controller: UIViewController,
                             header : [String: String]?,
                             callSilently : Bool = false,
                             successBlock: @escaping (_ response: NSDictionary) -> Void,
                             failureBlock: @escaping (_ error: Error? , _ isTimeOut: Bool) -> Void) {
        
        
        if isNetworkAvailable() {
            
            if !callSilently {
                MBProgressHUD.showAdded(to: (UIApplication.shared.delegate?.window!)! , animated: true)
            }
            
            
            let urlWithUTF8 =  url.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
            if ISDebug {   print("URL : \(urlWithUTF8!)");   }
            
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                
                let arrParametersKey = NSMutableArray(array: param.allKeys)
                let arrParametersValues = NSMutableArray(array: param.allValues)
                
                //For normal Parameters
                for index in 0 ..< arrParametersKey.count {
                    
                    if let strKey = arrParametersKey.object(at: index) as? String , let strValue = arrParametersValues.object(at: index) as? String {
                        
                        multipartFormData.append(strValue.data(using: .utf8)!, withName: strKey)
                    }
                }
                
                //For Images
                for index in 0 ..< images.count {
                    
                    let arrParametersKey = NSMutableArray(array: images.allKeys)
                    let arrParametersValues = NSMutableArray(array: images.allValues)
                    
                    if let strKey = arrParametersKey.object(at: index) as? String , let strValue = arrParametersValues.object(at: index) as? UIImage {
                        
//                        if let data = UIImagePNGRepresentation(strValue) {
//
//                            multipartFormData.append(data, withName: strKey, fileName: strKey,mimeType: "image/png")
//                        }
                        
                        if let data = UIImageJPEGRepresentation(strValue, 0.6) {
                            multipartFormData.append(data, withName: strKey, fileName: strKey,mimeType: "image/jpg")
                        }
                        
                        
                    }
                }
                
            }, usingThreshold: UInt64.init(), to: urlWithUTF8!, method: .post, headers: header) { (encodingResult) in
                
                switch encodingResult {
                case .success(let upload, _, _):
                    
                    if !callSilently {
                        DispatchQueue.main.async {
                            MBProgressHUD.hide(for: ((UIApplication.shared.delegate?.window)!)!, animated: true)
                        }
                    }
                    
                    upload.responseJSON { response in
                        
                        print("Response : \(String(describing: response.response?.statusCode))")
                        
                        if let aJSON =  response.result.value as? NSDictionary {
                            print("---- POST SUCCESS RESPONSE : \(aJSON)")
                            successBlock(aJSON)
                        } else {
                            failureBlock(nil, true)
                        }
                    }
                    break
                case .failure(let encodingError):
                    
                    if !callSilently {
                        DispatchQueue.main.async {
                            MBProgressHUD.hide(for: ((UIApplication.shared.delegate?.window)!)!, animated: true)
                        }
                    }
                    
                    UIAlertController.showAlertWithOkButton(controller, aStrMessage: "Something went wrong", completion: nil)
                    failureBlock(encodingError, false)
                    break
                }
                
            }
            
        } else {
            // Internet is not connected
            UIAlertController.showAlertWithOkButton(controller, aStrMessage: "Internet is not available", completion: nil)
            let aErrorConnection = NSError(domain: "InternetNotAvailable", code: 0456, userInfo: nil)
            failureBlock(aErrorConnection as Error , false)
        }
        
    }
    
    //MARK:- DELETE & PUT
    
    class func DELETEWithOriginalResponse(_ url: String,
                                       param: [String: Any]?,
                                       controller: UIViewController,
                                       header : [String: String]?,
                                       callSilently : Bool = false,
                                       successBlock: @escaping (_ response: NSDictionary) -> Void,
                                       failureBlock: @escaping (_ error: Error? , _ isTimeOut: Bool) -> Void) {
        
        let urlWithUTF8 =  url.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        if ISDebug {   print("URL : \(urlWithUTF8!)");   }
        
        
        // Internet is connected
        if isNetworkAvailable() {
            
            if !callSilently {
                MBProgressHUD.showAdded(to: (UIApplication.shared.delegate?.window!)! , animated: true)
            }
            
            Alamofire.request(urlWithUTF8!, method: .delete, parameters: param, encoding: JSONEncoding(options: []), headers: header).responseJSON(completionHandler: { (response) in
                
                
                if !callSilently{
                    DispatchQueue.main.async {
                        MBProgressHUD.hide(for: ((UIApplication.shared.delegate?.window)!)!, animated: true)
                    }
                }
                
                print("---- GET REQUEST URL RESPONSE : \(urlWithUTF8!)\n\(response.result)")
                print(response.timeline)
                
                switch response.result {
                case .success:
                    
                    if !callSilently{
                        DispatchQueue.main.async {
                            MBProgressHUD.hide(for: ((UIApplication.shared.delegate?.window)!)!, animated: true)
                        }
                    }
                    
                    if let result = response.result.value as? NSDictionary {
                        successBlock(result)
                    }
                    
                case .failure(let error):
                    print(error)
                    
                    if !callSilently{
                        DispatchQueue.main.async {
                            MBProgressHUD.hide(for: ((UIApplication.shared.delegate?.window)!)!, animated: true)
                        }
                    }
                    
                    if (error as NSError).code == -1001 {
                        // The request timed out error occured. // Code=-1001 "The request timed out."
                        UIAlertController.showAlertWithOkButton(controller, aStrMessage: "The request timed out. Pelase try after again.", completion: nil)
                        failureBlock(error, true)
                    } else {
                        failureBlock(error, false)
                    }
                    break
                }
                
            })
            
        }
        else{
            // Internet is not connected
            UIAlertController.showAlertWithOkButton(controller, aStrMessage: "Internet is not available", completion: nil)
            let aErrorConnection = NSError(domain: "InternetNotAvailable", code: 0456, userInfo: nil)
            failureBlock(aErrorConnection as Error , false)
        }
    }
    
    class func PUTWithOriginalResponse(_ url: String,
                                          param: [String: Any]?,
                                          controller: UIViewController,
                                          header : [String: String]?,
                                          callSilently : Bool = false,
                                          successBlock: @escaping (_ response: NSDictionary) -> Void,
                                          failureBlock: @escaping (_ error: Error? , _ isTimeOut: Bool) -> Void) {
        
        let urlWithUTF8 =  url.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        if ISDebug {   print("URL : \(urlWithUTF8!)");   }
        
        
        // Internet is connected
        if isNetworkAvailable() {
            
            if !callSilently {
                MBProgressHUD.showAdded(to: (UIApplication.shared.delegate?.window!)! , animated: true)
            }
            
            Alamofire.request(urlWithUTF8!, method: .put, parameters: param, encoding: JSONEncoding(options: []), headers: header).responseJSON(completionHandler: { (response) in
                
                
                if !callSilently{
                    DispatchQueue.main.async {
                        MBProgressHUD.hide(for: ((UIApplication.shared.delegate?.window)!)!, animated: true)
                    }
                }
                
                print("---- GET REQUEST URL RESPONSE : \(urlWithUTF8!)\n\(response.result)")
                print(response.timeline)
                
                switch response.result {
                case .success:
                    
                    if !callSilently{
                        DispatchQueue.main.async {
                            MBProgressHUD.hide(for: ((UIApplication.shared.delegate?.window)!)!, animated: true)
                        }
                    }
                    
                    if let result = response.result.value as? NSDictionary {
                        successBlock(result)
                    }
                    
                case .failure(let error):
                    print(error)
                    
                    if !callSilently{
                        DispatchQueue.main.async {
                            MBProgressHUD.hide(for: ((UIApplication.shared.delegate?.window)!)!, animated: true)
                        }
                    }
                    
                    if (error as NSError).code == -1001 {
                        // The request timed out error occured. // Code=-1001 "The request timed out."
                        UIAlertController.showAlertWithOkButton(controller, aStrMessage: "The request timed out. Pelase try after again.", completion: nil)
                        failureBlock(error, true)
                    } else {
                        failureBlock(error, false)
                    }
                    break
                }
                
            })
            
        }
        else{
            // Internet is not connected
            UIAlertController.showAlertWithOkButton(controller, aStrMessage: "Internet is not available", completion: nil)
            let aErrorConnection = NSError(domain: "InternetNotAvailable", code: 0456, userInfo: nil)
            failureBlock(aErrorConnection as Error , false)
        }
    }
    
    
    
}
