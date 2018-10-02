//
//  SignUpVC.swift
//  Prepwyzr
//
//  Created by Riddhi on 16/07/18.
//  Copyright © 2018 Riddhi. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class SignUpVC: UIViewController,UITextFieldDelegate {

    //MARK:- IBOutlets
    @IBOutlet var constraintH_StatusBar: NSLayoutConstraint!
    
    @IBOutlet var txtUsername: SkyFloatingLabelTextField!
    @IBOutlet var txtFullName: SkyFloatingLabelTextField!
    @IBOutlet var txtEmail: SkyFloatingLabelTextField!
    @IBOutlet var txtMobileNumber: SkyFloatingLabelTextField!
    @IBOutlet var txtPassword: SkyFloatingLabelTextField!
    @IBOutlet var txt_ConfirmPassword: SkyFloatingLabelTextField!
    
    @IBOutlet var btnLogin: UIButton!
    
    @IBOutlet var imgForgorPwdUserCheck: UIImageView!
    @IBOutlet var activityIndicatorForgorPwdUserCheck: UIActivityIndicatorView!
    
    @IBOutlet var imgEmailCheck: UIImageView!
    @IBOutlet var activityIndicatorEmailCheck: UIActivityIndicatorView!
    
    //PopUp
    @IBOutlet var viewWarningPopUp: UIView!
    
    
    //MARK:- OutSide Variables
    
    //MARK:- InSide Variables
    var timerForCheckUser = Timer()
    var timerForCheckEmail = Timer()
    
    var isUserAvailable = true
    var isEMailAvailable = true
    
    //MARK:- UIView Related Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436 {
            self.constraintH_StatusBar.constant = 44
        }
        
        self.btnLogin.addBorder(radius: 0, color: Constants.kColor_Green.cgColor)
        self.activityIndicatorForgorPwdUserCheck.stopAnimating()
        self.activityIndicatorEmailCheck.stopAnimating()
        
        
        self.viewWarningPopUp.frame = self.view.frame
        self.view.addSubview(self.viewWarningPopUp)
        //self.viewWarningPopUp.isHidden = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        self.viewWarningPopUp.frame = self.view.frame
    }
    
    //MARK:- UITextField Related Methods
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txtUsername {
            
            timerForCheckUser = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { (timer) in
                
                self.api_CheckUsernameAvailability()
            })
        }else if textField == txtMobileNumber {
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 10
        }
        else if textField == txtEmail {
            
            timerForCheckEmail = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { (timer) in
                
                self.api_CheckEmailAvailability()
            })
        }
        
        return true
    }
    
    //MARK:- UIButton Actions
    @IBAction func btnAction_Login(_ sender: Any) {
        
        UIAlertController.showAlertWithOkCancelButton(self, strTitle: "Are you Sure?", aStrMessage: "This will cancel Registration Process.") { (index, title) in
            
            if index == 0 {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func btnAction_register(_ sender: Any) {
        
        self.view.endEditing(true)
        self.validateRegistrationThenMakeAPICall()
    }
    
    @IBAction func btnAction_MoreActions(_ sender: Any) {
        
        Constants.openActionsFromViewController(objView: self, objNavi: self.navigationController!)
    }
    
    //PopUp
    @IBAction func btnAction_PopUp(_ sender: Any) {
        
        self.viewWarningPopUp.isHidden = true
    }
    
    //MARK:- Webservices Related Methods
    func validateRegistrationThenMakeAPICall() -> Void {
        
        var strUserName = "", strPassword = "", strFullName = "", strEmail = "", strConfirmPaswword = "", strMobile = ""
        
        if let username = self.txtUsername.text {
            strUserName = username
        }
        
        if strUserName.count == 0 {
            UIAlertController.showAlertWithOkButton(self, aStrMessage: Constants.kLogin_UserName, completion: nil)
            return
        }
        
        if self.isUserAvailable {
            UIAlertController.showAlertWithOkButton(self, aStrMessage: Constants.kLogin_ValidUserName, completion: nil)
            return
        }
        
        if let fullName = self.txtFullName.text {
            strFullName = fullName
        }
        
        if strFullName.count == 0 {
            UIAlertController.showAlertWithOkButton(self, aStrMessage: Constants.kLogin_FullName, completion: nil)
            return
        }
        
        
        if let email = self.txtEmail.text {
            strEmail = email
        }
        
        if strEmail.count == 0 {
            UIAlertController.showAlertWithOkButton(self, aStrMessage: Constants.kLogin_Email, completion: nil)
            return
        }
        
        if !strEmail.isValidEmail {
            UIAlertController.showAlertWithOkButton(self, aStrMessage: Constants.kLogin_ValidEmail, completion: nil)
            return
        }
        
        if self.isEMailAvailable {
            UIAlertController.showAlertWithOkButton(self, aStrMessage: "Email already in used", completion: nil)
            return
        }
        
        if let mobile = self.txtMobileNumber.text {
            strMobile = mobile
        }
        
        if strMobile.count == 0 {
            UIAlertController.showAlertWithOkButton(self, aStrMessage: Constants.kLogin_Mobile, completion: nil)
            return
        }
        
        if strMobile.count < 10 {
            UIAlertController.showAlertWithOkButton(self, aStrMessage: Constants.kLogin_Mobile_Digit, completion: nil)
            return
        }
        
        if let password = self.txtPassword.text {
            strPassword = password
        }
        
        if strPassword.count == 0 {
            UIAlertController.showAlertWithOkButton(self, aStrMessage: Constants.kLogin_Password, completion: nil)
            return
        }
        
        if strPassword.count < 6 {
            UIAlertController.showAlertWithOkButton(self, aStrMessage: Constants.kLogin_PasswordCountMsg, completion: nil)
            return
        }
        if let confirmPassword = self.txt_ConfirmPassword.text {
            strConfirmPaswword = confirmPassword
            
        }
        
        if !strPassword.isValidPass {
            UIAlertController.showAlertWithOkButton(self, aStrMessage: Constants.kLogin_PasswordStrong, completion: nil)
            return
        }
        if strConfirmPaswword.count == 0 {
            UIAlertController.showAlertWithOkButton(self, aStrMessage: Constants.kLogin_ConfirmPassword, completion: nil)
            return
        }
        
        if strPassword != strConfirmPaswword {
            UIAlertController.showAlertWithOkButton(self, aStrMessage: Constants.kLogin_PwdAndConfirmPwdMatch, completion: nil)
            return
        }
        
        
        self.api_Registration(strUserName: strUserName, strPassword: strPassword, strFullName: strFullName, strEmail: strEmail, strMobile: strMobile)
    }
    
    
    func api_Registration(strUserName:String,strPassword:String,strFullName:String,strEmail:String,strMobile:String) -> Void {
        
        let urlForLogin = Constants.URL_BASE + "register.php"
        
        Webservice.API(urlForLogin, param: ["username":strUserName,"password":strPassword,"name":strFullName,"emailId":strEmail,"phone":strMobile,"apiSecurityKey":Constants.apiSecurityKey,"device_id":Constants.deviceUUID!], controller: self, header: nil, methodType: .post, successBlock: { (dictResponse) in
            
            Constants.printLog(strLog: "Register response : \(dictResponse)")
            
            if let error = dictResponse.value(forKey: "error") {
                let strError = String(describing: error)
                
                if strError == "0" {
                    
                    //Send Varification Mail
                    self.api_SendVarificationMail(strUserName: strUserName, strFullName: strFullName, strEmail: strEmail)
                    
                    UIAlertController.showAlertWithOkButton(self, aStrMessage: "Verification mail has been sent to your Email Id. Please verify it to login!", completion: { (intIndex, strTitle) in
                        self.navigationController?.popViewController(animated: true)
                    })
                }
                
            }
            
        }) { (error, isTimeOut) in
            Constants.printLog(strLog: String(describing: error?.localizedDescription))
        }
    }

    func api_SendVarificationMail(strUserName:String,strFullName:String,strEmail:String) -> Void {
        
        let urlForLogin = Constants.URL_BASE + "sendVerificationMail.php"
        
        Webservice.API(urlForLogin, param: ["username":strUserName,"name":strFullName,"emailId":strEmail,"apiSecurityKey":Constants.apiSecurityKey,"device_id":Constants.deviceUUID!], controller: self, header: nil, callSilently: true, methodType: .post, successBlock: { (dictResponse) in
            
            Constants.printLog(strLog: "sendVerificationMail dictResponse : \(dictResponse)")
            
        }, failureBlock: { (error, isTimeOut) in
            Constants.printLog(strLog: String(describing: error?.localizedDescription))
        })
        
    }
    
    func api_CheckUsernameAvailability() -> Void {
        
        var strUserName = ""
        if let username = self.txtUsername.text {
            strUserName =  username
        }
        
        if strUserName.count > 0 {
            
            let urlForLogin = Constants.URL_BASE + "checkUN.php"
            
            
            self.activityIndicatorForgorPwdUserCheck.startAnimating()
            Webservice.API(urlForLogin, param: ["username":strUserName,"apiSecurityKey":Constants.apiSecurityKey,"device_id":Constants.deviceUUID!], controller: self, header: nil, callSilently: true, methodType: .post, successBlock: { (dictResponse) in
                
                self.activityIndicatorForgorPwdUserCheck.stopAnimating()
                Constants.printLog(strLog: "Login dictResponse : \(dictResponse)")
                
                self.imgForgorPwdUserCheck.image = nil
                self.isUserAvailable = true
                
                if let error = dictResponse.value(forKey: "error") {
                    let strError = String(describing: error)
                    
                    if strError == "1" {
                        
                        self.isUserAvailable = true
                        self.imgForgorPwdUserCheck.image = UIImage(named: "UserCheck_flase")
                        
                    } else {
                        
                        self.imgForgorPwdUserCheck.image = UIImage(named: "UserCheck_true")
                        self.isUserAvailable = false
                    }
                }
                
                
            }, failureBlock: { (error, isTimeOut) in
                Constants.printLog(strLog: String(describing: error?.localizedDescription))
            })
            
        }
        
    }
    
    func api_CheckEmailAvailability() -> Void {
        
        var strEmail = ""
        if let email = self.txtEmail.text {
            strEmail =  email
        }
        
        if strEmail.count > 0 && strEmail.isValidEmail  {
            
            let urlForLogin = Constants.URL_BASE + "checkEmail.php"
            
            self.activityIndicatorEmailCheck.startAnimating()
            Webservice.API(urlForLogin, param: ["email":strEmail,"apiSecurityKey":Constants.apiSecurityKey,"device_id":Constants.deviceUUID!], controller: self, header: nil, callSilently: true, methodType: .post, successBlock: { (dictResponse) in
                
                self.activityIndicatorEmailCheck.stopAnimating()
                Constants.printLog(strLog: "checkEmail.php dictResponse : \(dictResponse)")
                
                self.imgEmailCheck.image = nil
                self.isEMailAvailable = true
                
                if let error = dictResponse.value(forKey: "error") {
                    let strError = String(describing: error)
                    
                    if strError == "1" {
                        
                        self.isEMailAvailable = true
                        self.imgEmailCheck.image = UIImage(named: "UserCheck_flase")
                        
                    } else {
                        
                        self.imgEmailCheck.image = UIImage(named: "UserCheck_true")
                        self.isEMailAvailable = false
                    }
                }
                
                
            }, failureBlock: { (error, isTimeOut) in
                Constants.printLog(strLog: String(describing: error?.localizedDescription))
            })
            
        } else {
            
            self.isEMailAvailable = true
            self.imgEmailCheck.image = UIImage(named: "UserCheck_flase")
            
        }
    }
    
}

