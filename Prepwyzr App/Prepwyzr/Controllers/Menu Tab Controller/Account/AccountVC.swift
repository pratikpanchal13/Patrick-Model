//
//  AccountVC.swift
//  Prepwyzr
//
//  Created by Riddhi on 21/07/18.
//  Copyright © 2018 Riddhi. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class AccountVC: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet var constraintH_StatusBar: NSLayoutConstraint!
    
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var lblName: UILabel!
    
    @IBOutlet var txtEmail: SkyFloatingLabelTextField!
    @IBOutlet var txtMobileNumber: SkyFloatingLabelTextField!
    
    
    //MARK:- Variables
    
    
    //MARK:- UIView Related Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.lblUserName.text = appDel.objUserDataModel.strUsername
        self.lblName.text = appDel.objUserDataModel.strName
        
        self.txtEmail.text = appDel.objUserDataModel.strEmailID
        self.txtMobileNumber.text = appDel.objUserDataModel.strPhone
        
        
        if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436 {
            self.constraintH_StatusBar.constant = 44
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- UIButton Actions
    @IBAction func btnAction_Back(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAction_Update(_ sender: Any) {
        
        self.validateRegistrationThenMakeAPICall()
    }
    
    @IBAction func btnAction_Logout(_ sender: Any) {
        
        userDefault.set(nil, forKey: "username")
        userDefault.set(nil, forKey: "password")
        userDefault.synchronize()
        
        if let redViewController = self.storyboard?.instantiateViewController(withIdentifier: "Navi_Home") as? UINavigationController {
            appDel.window?.rootViewController = redViewController
            appDel.window?.makeKeyAndVisible()
        }
        
    }
    
    //MARK:- Webservices Related Methods
    func validateRegistrationThenMakeAPICall() -> Void {
        
        var strEmail = "", strMobile = ""
        
        if let email = self.txtEmail.text {
            strEmail = email
        }
        
        if let mobile = self.txtMobileNumber.text {
            strMobile = mobile
        }
        
        if strMobile.count < 10 {
            UIAlertController.showAlertWithOkButton(self, aStrMessage: Constants.kLogin_Mobile, completion: nil)
            return
        }
        
        self.api_UpdateAccountInformation(strEmail: strEmail, strMobile: strMobile)
    }
    
    func api_UpdateAccountInformation(strEmail:String,strMobile:String) -> Void {
        
        let urlForLogin = Constants.URL_BASE + "updateAccount.php"
        
        Webservice.API(urlForLogin, param: ["email":strEmail,"apiSecurityKey":Constants.apiSecurityKey,"phone":strMobile], controller: self, header: nil, callSilently: false, methodType: .post, successBlock: { (dictResponse) in
            
            Constants.printLog(strLog: "updateAccount dictResponse : \(dictResponse)")
            
            if let error = dictResponse.value(forKey: "error") {
                let strError = String(describing: error)
                
                if strError == "0" {
                    
                    
                    
                    
                } else {
                    
                    if let error_msg = dictResponse.value(forKey: "message") as? String {
                        
                        UIAlertController.showAlertWithOkButton(self, aStrMessage: error_msg, completion: { (intIndex, strTitle) in
                            
                        })
                    }
                }
                
            }
            
        }, failureBlock: { (error, isTimeOut) in
            Constants.printLog(strLog: String(describing: error?.localizedDescription))
        })
        
    }
    
    
    
}
