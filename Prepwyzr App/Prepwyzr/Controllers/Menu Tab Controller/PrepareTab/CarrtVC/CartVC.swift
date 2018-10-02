//
//  CartVC.swift
//  Prepwyzr
//
//  Created by Riddhi on 30/07/18.
//  Copyright © 2018 Riddhi. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class CartVC: UIViewController {

    //MARK:- OutSide Variables
    var dictData = NSDictionary()
    var dictPackageData = NSDictionary()
    
    //MARK:- IBOutlets
    @IBOutlet var constraintH_StatusBar: NSLayoutConstraint!
    
    @IBOutlet var viewForPrice: UIView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var lblGSTPrice: UILabel!
    @IBOutlet var lblTotalPrice: UILabel!
    
    @IBOutlet var txtCouponCode: SkyFloatingLabelTextField!
    
    @IBOutlet var lbl_CouponCodeError: UILabel!

    var vcModel: ModelInstituteList!

    
    //MARK:- InSide Variables
    var intPrice : Int = 0
    var intGSTPrice : Int = 0
    var intTotalPrice : Int = 0
    var intDiscountPrice : Int = 0 //Code is not apply
    
    //MARK:- UIView Related Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.lbl_CouponCodeError.text = ""
        
        if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436 {
            self.constraintH_StatusBar.constant = 44
        }
        
        self.viewForPrice.addBorder(radius: 0, color: Constants.kColor_Green.cgColor)
        
        
        //self.calculatePrice()
        
        if let instituteID = vcModel.instituteID{
            self.api_getPackageInfo(strInstituteID: instituteID)
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
    
    @IBAction func btnAction_Apply(_ sender: Any) {
        //FIXME: Work on it
        
        var strCode = ""
        if let code = self.txtCouponCode.text {
            strCode = code
        }
        
        var strPakageID = ""
        if let packageID = self.dictPackageData.value(forKey: "packageID") {
            strPakageID = String(describing: packageID)
        }
        
        if strCode.count > 0 && strPakageID.count > 0 {
            self.api_discountForPackage(strCode: strCode, strPackageID: strPakageID)
        }
        
    }

    @IBAction func btnAction_CheckOut(_ sender: Any) {
        
        //FIXME: Paytm SDK integration
        
        
    }
    
    //MARK:- WebServices Related Methods
    func api_getPackageInfo(strInstituteID:String) -> Void {
        
        let urlForLogin = Constants.URL_BASE + "getPackageInfo.php?"
        
        Webservice.API(urlForLogin, param: ["userID":appDel.objUserDataModel.strUsername,"instituteID":strInstituteID,"apiSecurityKey":Constants.apiSecurityKey,"device_id":Constants.deviceUUID!], controller: self, header: nil, methodType: .post, successBlock: { (dictResponse) in
            
            Constants.printLog(strLog: "getPackageInfo dictResponse : \(dictResponse)")
        
            self.dictPackageData = dictResponse
            
            if let success = dictResponse.value(forKey: "success") {
                let strSuccess = String(describing: success)
                
                if strSuccess == "1" {
                    //self.dictSelectedPackageInfo = dictResponse
                    
                    if let strPackageName = dictResponse.value(forKey: "packageName") as? String, let price = dictResponse.value(forKey: "price") {
                        
                        self.lblName.text = strPackageName
                        
                        self.intTotalPrice = Int(String(describing: price))!
                        self.lblTotalPrice.text = "₹ \(self.intTotalPrice)"
                        
                        self.intGSTPrice = (self.intTotalPrice * 18) / 100
                        self.lblGSTPrice.text = "₹ \(self.intGSTPrice)"
                        
                        self.intPrice = self.intTotalPrice - self.intGSTPrice
                        self.lblPrice.text = "₹ \(self.intPrice)"
                        
                    }
                }
                
            }
            
        }) { (error, isTimeOut) in
            Constants.printLog(strLog: String(describing: error?.localizedDescription))
        }
    }
    
    func api_discountForPackage(strCode:String,strPackageID:String) {
        
        let urlForLogin = Constants.URL_BASE + "validateCouponCode.php?"
        
        Webservice.API(urlForLogin, param: ["packageID":strPackageID,"code":strCode,"apiSecurityKey":Constants.apiSecurityKey], controller: self, header: nil, methodType: .post, successBlock: { (dictResponse) in
            
            Constants.printLog(strLog: "validateCouponCode dictResponse : \(dictResponse)")
            
            if let success = dictResponse.value(forKey: "success") {
                let strSuccess = String(describing: success)
                
                if strSuccess == "1" {
                    
                    self.lbl_CouponCodeError.text = ""
                    
                } else {
                    
                    if let error_msg = dictResponse.value(forKey: "error_msg") as? String {
                        self.lbl_CouponCodeError.text = error_msg
                    }
                    
                }
                
            }
            
        }) { (error, isTimeOut) in
            Constants.printLog(strLog: String(describing: error?.localizedDescription))
        }
    }
    
}
