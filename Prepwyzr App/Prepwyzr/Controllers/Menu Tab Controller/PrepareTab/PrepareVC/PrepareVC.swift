//
//  PrepareVC.swift
//  Prepwyzr
//
//  Created by Riddhi on 21/07/18.
//  Copyright © 2018 Riddhi. All rights reserved.
//

import UIKit

class PrepareVC: UIViewController {

    //MARK:- IBOutlet
    @IBOutlet var constraintH_StatusBar: NSLayoutConstraint!
    
    @IBOutlet var tbl_InstitutesList: UITableView!
    
    //PopUp View for Add Courses
    @IBOutlet var viewForAddNewCourses: UIView!
    @IBOutlet var btnForAddNewCourses_Update: UIButton!
    @IBOutlet var btnForAddNewCourses_Cancel: UIButton!
    
    //MARK:- Variables
    var arr_InstituteList = NSMutableArray()
    
    //MARK:- UIView Related Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.btnForAddNewCourses_Cancel.addBorder(radius: 0, color: Constants.kColor_Green.cgColor)
        
        if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436 {
            self.constraintH_StatusBar.constant = 44
        }
        
        self.viewForAddNewCourses.frame = self.view.frame
        self.view.addSubview(self.viewForAddNewCourses)
        self.viewForAddNewCourses.isHidden = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        self.viewForAddNewCourses.frame = self.view.frame
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- UIButton Actions
    @IBAction func btnAction_Back(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAction_ReloadData(_ sender: Any) {
        
    }
    
    @IBAction func btnAction_Add(_ sender: Any) {
        
        self.viewForAddNewCourses.isHidden = false
    }
    
    //PopUp View for Add Courses
    @IBAction func btnActionForAddNewCourses_Update(_ sender: Any) {
        
        if let objInstituteListVC = self.storyboard?.instantiateViewController(withIdentifier: "InstituteListVC") as? InstituteListVC {
            self.navigationController?.pushViewController(objInstituteListVC, animated: true)
        }
    }
    
    @IBAction func btnCancelForAddNewCourses_Update(_ sender: Any) {
        self.viewForAddNewCourses.isHidden = true
    }
    
    //MARK:- Webservices Related Methods
    func api_getUserInstitutesList() -> Void {
        
        let urlForLogin = Constants.URL_BASE + "getInstitutes.php?userID=\(appDel.objUserDataModel.strUsername)&apiSecurityKey=\(Constants.apiSecurityKey)"
        
        Webservice.API(urlForLogin, param: nil, controller: self, header: nil, callSilently: false, methodType: .get, successBlock: { (dictResponse) in
            
            Constants.printLog(strLog: "getInstitutes dictResponse : \(dictResponse)")
            
            if let error = dictResponse.value(forKey: "success") {
                let strSuccess = String(describing: error)
                
                if strSuccess == "1" {
                    
                    if let posts = dictResponse.value(forKey: "posts") as? NSArray {
                        self.arr_InstituteList = NSMutableArray(array: posts)
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

}
