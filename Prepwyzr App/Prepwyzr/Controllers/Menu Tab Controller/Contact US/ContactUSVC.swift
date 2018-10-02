//
//  ContactUSVC.swift
//  Prepwyzr
//
//  Created by Riddhi on 20/07/18.
//  Copyright © 2018 Riddhi. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class ContactUSVC: UIViewController {

    //MARK:- OutSide Variables
    //var isFromLoginOrRegistrationScreen = false
    
    //MARK:- IBOutlets
    @IBOutlet var constraintH_StatusBar: NSLayoutConstraint!
    @IBOutlet var btnBack: UIBarButtonItem!
    
    @IBOutlet var txtName: SkyFloatingLabelTextField!
    @IBOutlet var txtMobileNumber: SkyFloatingLabelTextField!
    
    @IBOutlet var txtYourMessage: UITextView!
    
    //MARK:- Vaariables
    
    //MARK:- UIView Related Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436 {
            self.constraintH_StatusBar.constant = 44
        }
        
//        if !self.isFromLoginOrRegistrationScreen {
//            //Remove
//            self.btnBack.image = nil
//        }
        
        
        self.txtYourMessage.addBorder(radius: 0, color: Constants.kColor_Green.cgColor)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK:- UIButton Actions
    @IBAction func btnAction_Send(_ sender: Any) {
        self.validateRegistrationThenMakeAPICall()
    }
    
    @IBAction func btnAction_Back(_ sender: Any) {
        
        //if self.isFromLoginOrRegistrationScreen {
            self.navigationController?.popViewController(animated: true)
        //}
    }
    
    //MARK:- Webservices Related Methods
    func validateRegistrationThenMakeAPICall() -> Void {
        
        var strName = ""
        if let name = self.txtName.text {
            strName = name
        }
        
        var strMobileNumber = ""
        if let mobileNumber = self.txtMobileNumber.text {
            strMobileNumber = mobileNumber
        }
        
        var strYourMessage = ""
        if let yourMessage = self.txtYourMessage.text {
            strYourMessage = yourMessage
        }
        
        if strName.count == 0 {
            
            UIAlertController.showAlertWithOkButton(self, aStrMessage: "Please enter name", completion: nil)
            return
        }
        
        if strMobileNumber.count != 10 {
            
            UIAlertController.showAlertWithOkButton(self, aStrMessage: "Mobile Number should be of 10 digits", completion: nil)
            return
        }
        
        if strYourMessage.count == 0 {
            
            UIAlertController.showAlertWithOkButton(self, aStrMessage: "Please Enere Message", completion: nil)
            return
        }
        
        
        self.api_ContactUS(strFullName: strName, strMessage: strYourMessage, strMobile: strMobileNumber)
    }
    
    func api_ContactUS(strFullName:String,strMessage:String,strMobile:String) -> Void {
        
        let urlForLogin = Constants.URL_BASE + "contactUs.php"
        
        Webservice.API(urlForLogin, param: ["name":strFullName,"message":strMessage,"phone":strMobile,"apiSecurityKey":Constants.apiSecurityKey,"device_id":Constants.deviceUUID!], controller: self, header: nil, methodType: .post, successBlock: { (dictResponse) in
            
            Constants.printLog(strLog: "Register response : \(dictResponse)")
            
            if let error = dictResponse.value(forKey: "success") {
                let strError = String(describing: error)
                
                if strError == "1" {
                    UIAlertController.showAlertWithOkButton(self, aStrMessage: "We will try contact you shortly", completion: { (index, Button) in
                        if index == 0{
                            self.txtName.text = ""
                            self.txtMobileNumber.text = ""
                            self.txtYourMessage.text = ""
                        }
                    })
                }
            }
            
        }) { (error, isTimeOut) in
            Constants.printLog(strLog: String(describing: error?.localizedDescription))
        }
        
        
    }
    
    
}
