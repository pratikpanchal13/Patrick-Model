//
//  SplashVC.swift
//  Prepwyzr
//
//  Created by Riddhi on 21/07/18.
//  Copyright © 2018 Riddhi. All rights reserved.
//


class SplashVC: UIViewController {
    
    //MARK:- UIView Related Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let strUserName = userDefault.value(forKey: "username") as? String,let strPassword = userDefault.value(forKey: "password") as? String {
            self.api_Login(strUserName: strUserName, strPassword: strPassword)
            
        } else {
            
            if let objLoginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC {
                self.navigationController?.pushViewController(objLoginVC, animated: true)
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- WebServices Related Methods
    func api_Login(strUserName:String,strPassword:String) -> Void {
        
        let urlForLogin = Constants.URL_BASE + "login.php"
        
        Webservice.API(urlForLogin, param: ["username":strUserName,"password":strPassword,"apiSecurityKey":Constants.apiSecurityKey,"device_id":Constants.deviceUUID!], controller: self, header: nil, methodType: .post, successBlock: { (dictResponse) in
            
            Constants.printLog(strLog: "Login dictResponse : \(dictResponse)")
            
            if let error = dictResponse.value(forKey: "error") {
                let strError = String(describing: error)
                
                if strError == "0" {
                    
                    if let userDetails = dictResponse.object(forKey: "user") as? NSDictionary {
                        appDel.objUserDataModel = UserDataModel(withDict: userDetails)
                        
                        if let redViewController = self.storyboard?.instantiateViewController(withIdentifier: "Navi_Tab") as? UINavigationController {
                            appDel.window?.rootViewController = redViewController
                            appDel.window?.makeKeyAndVisible()
                        }
                        
                    }
                    
                }
                
            }
            
        }) { (error, isTimeOut) in
            Constants.printLog(strLog: String(describing: error?.localizedDescription))
        }
    }
    
}
