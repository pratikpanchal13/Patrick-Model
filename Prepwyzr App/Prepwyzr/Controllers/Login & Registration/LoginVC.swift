//
//  LoginVC.swift
//  Prepwyzr
//
//  Created by Riddhi on 16/07/18.
//  Copyright © 2018 Riddhi. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class LoginVC: UIViewController,UITextFieldDelegate {

    //MARK:- IBOutlets
    
    @IBOutlet var constraintH_StatusBar: NSLayoutConstraint!
    
    @IBOutlet var txtUserName: SkyFloatingLabelTextField!
    @IBOutlet var txtPassword: SkyFloatingLabelTextField!
    
    //Forgot Password View
    
    @IBOutlet var viewForForgotPassword: UIView!
    @IBOutlet var txtForgotPwd_UserId: SkyFloatingLabelTextField!
    
    @IBOutlet var imgForgorPwdUserCheck: UIImageView!
    @IBOutlet var activityIndicatorForgorPwdUserCheck: UIActivityIndicatorView!
    
    @IBOutlet var btnForgotSubmit: UIButton!
    @IBOutlet var btnForgotCancel: UIButton!
    
    
    //For Re-Send Veryfication
    
    @IBOutlet var viewForReSendVerificationLabel: UIView!
    
    @IBOutlet var viewForReSendVarification: UIView!
    @IBOutlet var txtReSendVarification_Email: SkyFloatingLabelTextField!
    
    @IBOutlet var imgReSendVarificationUserCheck: UIImageView!
    @IBOutlet var activityIndicatorReSendVarificationUserCheck: UIActivityIndicatorView!
    
    @IBOutlet var btnReSendVarificationSubmit: UIButton!
    @IBOutlet var btnReSendVarificationCancel: UIButton!
    
    //MARK:- OutSide Variables
    
    //MARK:- InSide Variables
    var timerForCheckUser = Timer()
    var isUserAvailableForUser = false
    
    var timerForCheckEmail = Timer()
    var isEMailAvailable = true
    
    //MARK:- UIView Related Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436 {
            self.constraintH_StatusBar.constant = 44
        }
        
        self.viewForForgotPassword.frame = self.view.frame
        self.view.addSubview(self.viewForForgotPassword)
        self.viewForForgotPassword.isHidden = true
        
        self.viewForReSendVarification.frame = self.view.frame
        self.view.addSubview(self.viewForReSendVarification)
        self.viewForReSendVarification.isHidden = true
        
        
        self.viewForReSendVerificationLabel.addBorder(radius: 0, color: Constants.kColor_Green.cgColor)
        self.btnReSendVarificationCancel.addBorder(radius: 0, color: Constants.kColor_Green.cgColor)
        self.btnForgotCancel.addBorder(radius: 0, color: Constants.kColor_Green.cgColor)
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        self.viewForForgotPassword.frame = self.view.frame
        self.viewForReSendVarification.frame = self.view.frame
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK:- UITextField Related Methods
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txtForgotPwd_UserId {
            
            timerForCheckUser = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { (timer) in
                
                self.api_CheckUsernameAvailability()
            })
        } else if textField == txtReSendVarification_Email {
            
            timerForCheckEmail = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { (timer) in
                
                self.api_CheckEmailAvailability()
            })
        }
        
        return true
    }
    
    //MARK:- UIButton Actions Related Methods
    
    @IBAction func btnAction_Login(_ sender: Any) {
        
        self.view.endEditing(true)
        
        var strUserName = "", strpassword = ""
        
        if let userName = self.txtUserName.text {
            strUserName = userName
        }
        
        if let password = self.txtPassword.text {
            strpassword = password
        }
        
        if strUserName.count > 0 && strpassword.count > 0 {
            self.api_Login(strUserName: strUserName, strPassword: strpassword)
        } else {
            
            UIAlertController.showAlertWithOkButton(self, aStrMessage: Constants.kLogin_UserNameAndPwd, completion: nil)
        }
        
    }
    
    @IBAction func btnAction_ForgotPassword(_ sender: Any) {
        
        self.imgForgorPwdUserCheck.image = nil
        self.activityIndicatorForgorPwdUserCheck.stopAnimating()
        
        self.viewForForgotPassword.isHidden = false
        self.txtForgotPwd_UserId.becomeFirstResponder()
        
    }
    
    @IBAction func btnAction_SignUp(_ sender: Any) {
        
        if let objSignUp = self.storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as? SignUpVC {
            
            self.navigationController?.pushViewController(objSignUp, animated: true)
        }
        
    }
    
    @IBAction func btnAction_MoreActions(_ sender: Any) {
        
        Constants.openActionsFromViewController(objView: self, objNavi: self.navigationController!)
    }
    
    @IBAction func btnAction_ForgotPwdCancel(_ sender: Any) {
        
        self.viewForForgotPassword.isHidden = true
        self.txtForgotPwd_UserId.text = ""
    }
    
    @IBAction func btnAction_ForgotPwdSubmit(_ sender: Any) {
        
        if isUserAvailableForUser  {
            self.api_ForGotPassword()
        } else {
            UIAlertController.showAlertWithOkButton(self, aStrMessage: "Please enter valid user id.", completion: nil)
        }
    }
    
    @IBAction func btnAction_ReSendVarificationSubmit(_ sender: Any) {
        
        if !self.isEMailAvailable {
            
            //FIXME: Call API Here
            self.viewForReSendVarification.isHidden = true
            
            self.api_SendVarificationMail(strUserName: self.txtUserName.text!, strFullName: "", strEmail: self.txtReSendVarification_Email.text!)
            
        } else {
            
            UIAlertController.showAlertWithOkButton(self, aStrMessage: "Email ID already in used!", completion: nil)
        }
        
    }
    
    @IBAction func btnAction_ReSendVarificationCancel(_ sender: Any) {
        
        self.viewForReSendVarification.isHidden = true
    }
    
    //
    
    
    
    //MARK:- Webservices Related Methods
    func api_Login(strUserName:String,strPassword:String) -> Void {
        
        let urlForLogin = Constants.URL_BASE + "login.php"
        
        Webservice.API(urlForLogin, param: ["username":strUserName,"password":strPassword,"apiSecurityKey":Constants.apiSecurityKey,"device_id":Constants.deviceUUID!], controller: self, header: nil, methodType: .post, successBlock: { (dictResponse) in
            
            Constants.printLog(strLog: "Login dictResponse : \(dictResponse)")
            
            if let error = dictResponse.value(forKey: "error") {
                let strError = String(describing: error)
                
                if strError == "0" {
                    
                    if let userDetails = dictResponse.object(forKey: "user") as? NSDictionary {
                        
                        userDefault.set(strUserName, forKey: "username")
                        userDefault.set(strPassword, forKey: "password")
                        userDefault.synchronize()
                        
                        appDel.objUserDataModel = UserDataModel(withDict: userDetails)
                        
                        if let redViewController = self.storyboard?.instantiateViewController(withIdentifier: "Navi_Tab") as? UINavigationController {
                            appDel.window?.rootViewController = redViewController
                            appDel.window?.makeKeyAndVisible()
                        }
                        
                    }
                    
                } else {
                    
                    if let error_msg = dictResponse.value(forKey: "error_msg") as? String {
                        
                        if error_msg == "email_error" {
                            /*
                            UIAlertController.showAlertWithOkButton(self, aStrMessage: "Please check your Email", completion: { (intIndex, strTitle) in
                                
                            }) */
                            
                            self.activityIndicatorReSendVarificationUserCheck.stopAnimating()
                            self.viewForReSendVarification.isHidden = false
                            
                        } else {
                            
                            UIAlertController.showAlertWithOkButton(self, aStrMessage: error_msg, completion: { (intIndex, strTitle) in
                                
                            })
                            
                        }
                    }
                }
                
            }
            
        }) { (error, isTimeOut) in
            Constants.printLog(strLog: String(describing: error?.localizedDescription))
        }
    }
    
    func api_CheckUsernameAvailability() -> Void {
        
        var strUserName = ""
        if let username = self.txtForgotPwd_UserId.text {
            strUserName =  username
        }
        
        if strUserName.count > 0 {
            
            let urlForLogin = Constants.URL_BASE + "checkUN.php"
            
            
            self.activityIndicatorForgorPwdUserCheck.startAnimating()
            Webservice.API(urlForLogin, param: ["username":strUserName,"apiSecurityKey":Constants.apiSecurityKey,"device_id":Constants.deviceUUID!], controller: self, header: nil, callSilently: true, methodType: .post, successBlock: { (dictResponse) in
                
                self.activityIndicatorForgorPwdUserCheck.stopAnimating()
                Constants.printLog(strLog: "Login dictResponse : \(dictResponse)")
                
                self.imgForgorPwdUserCheck.image = nil
                self.isUserAvailableForUser = false
                
                if let error = dictResponse.value(forKey: "error") {
                    let strError = String(describing: error)
                    
                    if strError == "1" {
                        
                        self.isUserAvailableForUser = true
                        self.imgForgorPwdUserCheck.image = UIImage(named: "UserCheck_true")
                        
                    } else {
                    
                        self.isUserAvailableForUser = false
                        self.imgForgorPwdUserCheck.image = UIImage(named: "UserCheck_flase")
                    }
                }
                
                
            }, failureBlock: { (error, isTimeOut) in
                Constants.printLog(strLog: String(describing: error?.localizedDescription))
            })
            
        }
        
    }
    
    func api_CheckEmailAvailability() -> Void {
        
        var strEmail = ""
        if let email = self.txtReSendVarification_Email.text {
            strEmail =  email
        }
        
        if strEmail.count > 0 && strEmail.isValidEmail  {
            
            let urlForLogin = Constants.URL_BASE + "checkEmail.php"
            
            self.activityIndicatorReSendVarificationUserCheck.startAnimating()
            Webservice.API(urlForLogin, param: ["email":strEmail,"apiSecurityKey":Constants.apiSecurityKey,"device_id":Constants.deviceUUID!], controller: self, header: nil, callSilently: true, methodType: .post, successBlock: { (dictResponse) in
                
                self.activityIndicatorReSendVarificationUserCheck.stopAnimating()
                Constants.printLog(strLog: "checkEmail.php dictResponse : \(dictResponse)")
                
                self.imgReSendVarificationUserCheck.image = nil
                self.isEMailAvailable = true
                
                if let error = dictResponse.value(forKey: "error") {
                    let strError = String(describing: error)
                    
                    if strError == "1" {
                        
                        self.isEMailAvailable = true
                        self.imgReSendVarificationUserCheck.image = UIImage(named: "UserCheck_flase")
                        
                    } else {
                        
                        self.imgReSendVarificationUserCheck.image = UIImage(named: "UserCheck_true")
                        self.isEMailAvailable = false
                    }
                }
                
                
            }, failureBlock: { (error, isTimeOut) in
                Constants.printLog(strLog: String(describing: error?.localizedDescription))
            })
            
        } else {
            
            self.isEMailAvailable = true
            self.imgReSendVarificationUserCheck.image = UIImage(named: "UserCheck_flase")
            
        }
    }
    
    func api_ForGotPassword() -> Void {
        
        var strUserName = ""
        if let username = self.txtForgotPwd_UserId.text {
            strUserName =  username
        }
        
        if strUserName.count > 0 {
            
            let urlForLogin = Constants.URL_BASE + "forgotPassword.php"

            Webservice.API(urlForLogin, param: ["userID":strUserName,"apiSecurityKey":Constants.apiSecurityKey,"device_id":Constants.deviceUUID!], controller: self, header: nil, callSilently: false, methodType: .post, successBlock: { (dictResponse) in
                
                Constants.printLog(strLog: "forgotPassword dictResponse : \(dictResponse)")
                
                if let error = dictResponse.value(forKey: "error") {
                    let strError = String(describing: error)
                    
                    if strError == "0" {
                        
                        UIAlertController.showAlertWithOkButton(self, aStrMessage: "An Email has been sent your registered Email ID with password reset instructions.", completion: { (index, title) in
                            
                            self.viewForForgotPassword.isHidden = true
                            self.txtForgotPwd_UserId.text = ""
                            
                        })
                        
                        
                    } else {
                        
                        if let error_msg = dictResponse.value(forKey: "error_msg") as? String {
                            
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
    
    func api_SendVarificationMail(strUserName:String,strFullName:String,strEmail:String) -> Void {
        
        let urlForLogin = Constants.URL_BASE + "sendVerificationMail.php"
        
        
        Webservice.API(urlForLogin, param: ["username":strUserName,"name":strFullName,"emailId":strEmail,"apiSecurityKey":Constants.apiSecurityKey,"device_id":Constants.deviceUUID!], controller: self, header: nil, callSilently: true, methodType: .post, isDisplayAlertWhenError: false, successBlock: { (dictResponse) in
            
            Constants.printLog(strLog: "sendVerificationMail dictResponse : \(dictResponse)")
            
        }) { (error, isTimeOut) in
            Constants.printLog(strLog: String(describing: error?.localizedDescription))
        }
        
    }
    
    
}

