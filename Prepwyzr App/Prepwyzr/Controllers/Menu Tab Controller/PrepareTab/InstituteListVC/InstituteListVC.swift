//
//  InstituteListVC.swift
//  Prepwyzr
//
//  Created by Riddhi on 22/07/18.
//  Copyright © 2018 Riddhi. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class InstituteListVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    //MARK:- IBOutlet
    @IBOutlet var constraintH_StatusBar: NSLayoutConstraint!
    
    @IBOutlet var txtSearch: UITextField!
    @IBOutlet var tbl_InstitutesList: UITableView!
    
    //PopUp For Package Information
    @IBOutlet var viewPopUpForPackageInfor: UIView!
    
    @IBOutlet var webViewForPackage: UIWebView!
    @IBOutlet var lblCostForPackage: UILabel!
    
    @IBOutlet var btnForPackage_Cancel: UIButton!
    
    
    //Model
    var vcModelPackageInfoSub : [ModelPackageInfoSub] = []
    var vcModelPackage = ModelPackage()
    
    var vcModelInstituteList : [ModelInstituteList] = []
    var vcModelInstituteListFilter: [ModelInstituteList] = []
    var selectedInstituteData : ModelInstituteList?


    //MARK:- UIView Related Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436 {
            self.constraintH_StatusBar.constant = 44
        }
        
        self.btnForPackage_Cancel.addBorder(radius: 0, color: Constants.kColor_Green.cgColor)
        self.webViewForPackage.addBorder(radius: 0, color: Constants.kColor_Green.cgColor)
        
        
        self.txtSearch.delegate = self
        
        if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436 {
            self.constraintH_StatusBar.constant = 44
        }
        
        self.viewPopUpForPackageInfor.frame = self.view.frame
        self.view.addSubview(self.viewPopUpForPackageInfor)
        self.viewPopUpForPackageInfor.isHidden = true
        
        self.api_getAllInstitutesList()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        self.viewPopUpForPackageInfor.frame = self.view.frame
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- UITextField Related Methods
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txtSearch {
            
            if let text = textField.text as NSString? {
                
                let strSearchText = text.replacingCharacters(in: range, with: string)

                vcModelInstituteListFilter = strSearchText.isEmpty ? vcModelInstituteList : vcModelInstituteList.filter({ (model) -> Bool in
                    guard let contentName = model.name else {
                        return false
                    }
                    return (contentName.range(of: strSearchText, options: .caseInsensitive) != nil)
                })
                print("vcModelInstituteListFilter",vcModelInstituteListFilter)
                print("vcModelInstituteListFilter Count",vcModelInstituteListFilter.count)
                self.tbl_InstitutesList.reloadData()

            }
        }
        
        return true
    }
    
    //MARK:- UIButton Actions
    @IBAction func btnAction_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //PopUp For Package Information
    @IBAction func btnAction_PackageTryForFree(_ sender: Any) {
        
        if let objCartVC = self.storyboard?.instantiateViewController(withIdentifier: "TopicsVC") as? TopicsVC {
            
            objCartVC.vcModel = selectedInstituteData
            objCartVC.isFromFree = true
            self.navigationController?.pushViewController(objCartVC, animated: true)
        }
    }
    
    @IBAction func btnAction_PackageBuyNow(_ sender: Any) {
        
        if let objCartVC = self.storyboard?.instantiateViewController(withIdentifier: "CartVC") as? CartVC {
            
            objCartVC.vcModel = selectedInstituteData
            self.navigationController?.pushViewController(objCartVC, animated: true)
        }
        
    }
    
    @IBAction func btnAction_PackageIHaveActivationKey(_ sender: Any) {
        
    }
    
    @IBAction func btnAction_PackageCancel(_ sender: Any) {
        self.viewPopUpForPackageInfor.isHidden = true

    }
    
    //MARK:- UITableView Related Methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 75
        }
        
        return 55
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vcModelInstituteListFilter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_InstituteList", for: indexPath) as! Cell_InstituteList
        
        let model = vcModelInstituteListFilter[indexPath.row]
        
        if let name = model.name{
            cell.lbl_Name.text = name
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let model = vcModelInstituteListFilter[indexPath.row]
        self.selectedInstituteData = model
        if let instituteID = model.instituteID{
            self.api_getPackageInfo(strInstituteID: "\(instituteID)")
        }
    }
    
    //MARK:- Webservices Related Methods
    func api_getAllInstitutesList() -> Void {
        
        let urlForLogin = Constants.URL_BASE + "getInstitutes.php?userID=*&apiSecurityKey=\(Constants.apiSecurityKey)"
        
        Webservice.API(urlForLogin, param: nil, controller: self, header: nil, callSilently: false, methodType: .get, successBlock: { (dictResponse) in
            
            Constants.printLog(strLog: "getInstitutes dictResponse : \(dictResponse)")
            
            if let error = dictResponse.value(forKey: "success") {
                let strSuccess = String(describing: error)
                
                if strSuccess == "1" {

                    if let dict =  dictResponse as? [String:Any]{
                        if let tempInstituteList = ModelInstituteList.parseModelInstituteList(dict: dict),tempInstituteList.count>0 {
                            self.vcModelInstituteList = tempInstituteList
                            self.vcModelInstituteListFilter = tempInstituteList
                            print("vcModelInstituteList",self.vcModelInstituteList)
                            print("vcModelInstituteList Count" ,self.vcModelInstituteList.count)
                        }
                    }
                    self.tbl_InstitutesList.reloadData()
                    
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
    
    func api_getPackageInfo(strInstituteID:String) -> Void {
        
        //https://prepwyzr.com/android_api/getPackageInfo.php?userID=bhargav&instituteID=abSanskrit&apiSecurityKey=!894$4v!B7b8REj&device_id=FF864A4C-86DB-4571-83B7-2F09169E1275

        
        let urlForLogin = Constants.URL_BASE + "getPackageInfo.php?"
        
        Webservice.API(urlForLogin, param: ["userID":appDel.objUserDataModel.strUsername,"instituteID":strInstituteID,"apiSecurityKey":Constants.apiSecurityKey,"device_id":Constants.deviceUUID!], controller: self, header: nil, methodType: .post, successBlock: { (dictResponse) in
            
            Constants.printLog(strLog: "getPackageInfo dictResponse : \(dictResponse)")
            
            if let success = dictResponse.value(forKey: "success") {
                let strSuccess = String(describing: success)
                
                if strSuccess == "1" {
                    if let dict =  dictResponse as? [String:Any]{
                        if let tempPackageInfoSub = ModelPackageInfoSub.parseModelInstituteList(dict: dict),tempPackageInfoSub.count>0 {
                            self.vcModelPackageInfoSub = tempPackageInfoSub
                            
                            if let tempModelPackage  = ModelPackage.parseModelPackage(dict: dict, childData: tempPackageInfoSub){
                                
                                self.vcModelPackage = tempModelPackage

                                guard let packageName = self.vcModelPackage.packageName else {
                                    return
                                }
                                
                                guard let packagePrice = self.vcModelPackage.price else {
                                    return
                                }
                                
                                //For WebView
                                var packageInfoForWebview = "Package Name: <b>" + packageName + "</b><br><br>"
                                packageInfoForWebview = packageInfoForWebview + "This package contains the following courses:<br><br>"
                                
                                for (_, dict) in tempPackageInfoSub.enumerated() {
                                    if let courseName = dict.courseName{
                                        packageInfoForWebview += "- \(courseName) <br>";
                                    }
                                }
                                
                                packageInfoForWebview = packageInfoForWebview + "<br>You will get access to all questions and will be able to attempt unlimited number of tests for a period of <b>1 year</b> from the day of activation."

                                self.webViewForPackage.loadHTMLString(packageInfoForWebview, baseURL: nil)

                                //For Price
                                self.lblCostForPackage.text = "  " + "₹ \(packagePrice) (Valid for 1 Year)" + "  "
                                self.viewPopUpForPackageInfor.isHidden = false
                            }
                        }
                    }

                }
                
            }
            
        }) { (error, isTimeOut) in
            Constants.printLog(strLog: String(describing: error?.localizedDescription))
        }
        
        
    }

}

class Cell_InstituteList: UITableViewCell {
    
    @IBOutlet var lbl_Name: UILabel!
    @IBOutlet var btn_Add: UIButton!
    
    
    
}
