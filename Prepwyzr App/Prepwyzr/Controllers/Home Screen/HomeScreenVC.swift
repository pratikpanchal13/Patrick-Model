
//
//  HomeScreenVC.swift
//  Prepwyzr
//
//  Created by rlogical-dev-11 on 15/08/18.
//  Copyright © 2018 Mitul Mandanka. All rights reserved.
//

import UIKit
import CZPicker

class HomeScreenVC: UIViewController,UITableViewDelegate,UITableViewDataSource,CZPickerViewDelegate,CZPickerViewDataSource {

    var czPickerView: CZPickerView?
    
    //MARK:- IBOutets
    @IBOutlet var lbl_DisplayMsg: UILabel!
    @IBOutlet var tbl_CourseDetails: UITableView!
    @IBOutlet var btn_SelectedCourses: UIButton!
    
    //PopUp
    @IBOutlet var viewForRankingPopUp: UIView!
    @IBOutlet var lbl_PopUpRank: UILabel!
    
    @IBOutlet var tbl_PopUpRank: UITableView!    
    @IBOutlet weak var viewDashLine: UIView!
    
    
    //MARK:- Variables
    var vcModelInstituteSub : [ModelInstitute] = []
    var vcModelTopic : [ModelTopicSub] = []
    var vcModelTopicRank : [ModelTopicRank] = []
    
    var strSelectedInstitute = ""
    
    //MARK:- UIView Related Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tbl_CourseDetails.register(UINib(nibName: "CellTable_HomeCourse", bundle: nil), forCellReuseIdentifier: "CellTable_HomeCourse")
        
        //Get List of Institute List
        self.api_getUserInstitutesList()
        
        self.viewForRankingPopUp.frame = self.view.frame
        self.view.addSubview(self.viewForRankingPopUp)
        self.viewForRankingPopUp.isHidden = true
        self.btn_SelectedCourses.isHidden = true
        self.viewDashLine.isHidden = true
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        self.viewForRankingPopUp.frame = self.view.frame
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK:- UITableView Related Methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == self.tbl_PopUpRank {
            return 40
        }
        
        return 120
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.tbl_PopUpRank {
            return vcModelTopicRank.count
        }
        
        return self.vcModelTopic.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.tbl_PopUpRank {
    
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_RankData", for: indexPath)
            
            let lblIndex = cell.viewWithTag(101) as! UILabel
            let lblUserName = cell.viewWithTag(102) as! UILabel
            let lblRank = cell.viewWithTag(103) as! UILabel
            
            lblIndex.text = "\(indexPath.row + 1)"
            
            let model = vcModelTopicRank[indexPath.row]

            if let userName = model.user{
                if  userName == appDel.objUserDataModel.strUsername {
                    lblIndex.textColor = Constants.kColor_Green
                    lblUserName.textColor = Constants.kColor_Green
                    lblRank.textColor = Constants.kColor_Green

                } else {
                    lblIndex.textColor = UIColor.gray
                    lblUserName.textColor = UIColor.gray
                    lblRank.textColor = UIColor.gray
                }
                lblUserName.text = userName
            }
            
            if let percentage = model.percentage{
                lblRank.text = "\(BusinessLogic.displayAmount("\(percentage)")) %"
            }

            return cell
            
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellTable_HomeCourse", for: indexPath) as! CellTable_HomeCourse
        
        let model = vcModelTopic[indexPath.row]
        
        if let topicName = model.topicName{
            cell.lbl_CourseName.text = topicName
        }
        
        if let percentage = model.percentage{
            cell.lbl_CoursePercentage.text =  "\(BusinessLogic.displayAmount("\(percentage)")) %"
            cell.progressViewForCourse.ringProgress =  CGFloat(percentage)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView == self.tbl_PopUpRank {
        
        } else {

            let model = vcModelTopic[indexPath.row]
            if let topicID = model.topicID{
                print("topicID",topicID)
                self.api_getTopicRank(strTopicID: "\(topicID)", strInstituteID: self.strSelectedInstitute)
            }
        }
        
    }
    
    //MARK:- CZPickerView Related Methods
    func openPickerViewForMarking() {
        
        czPickerView = CZPickerView(headerTitle: "Select", cancelButtonTitle: "Cancel", confirmButtonTitle: "Confirm")
        czPickerView?.delegate = self
        czPickerView?.dataSource = self
        czPickerView?.headerBackgroundColor = Constants.kColor_Green
        czPickerView?.needFooterView = false
        czPickerView?.confirmButtonBackgroundColor = Constants.kColor_Green
        czPickerView?.show()
        
    }
    
    //Delegate Methods
    func numberOfRows(in pickerView: CZPickerView!) -> Int {
        return self.vcModelInstituteSub.count
    }
    
    func czpickerView(_ pickerView: CZPickerView!, titleForRow row: Int) -> String! {
        
        let model = self.vcModelInstituteSub[row]
        if let strInstituteName = model.name{
            return strInstituteName
        }
        return ""
    }
    
    func czpickerView(_ pickerView: CZPickerView!, didConfirmWithItemAtRow row: Int) {
        
        let model = self.vcModelInstituteSub[row]

        guard let strInstituteID = model.instituteID else{
            return
        }
        
        guard let strInstituteName = model.name else{
            return
        }
        
        self.api_getGraphData(strUserID: appDel.objUserDataModel.strUsername, strInstituteID: strInstituteID, strInstituteName: strInstituteName)
    }
    
    func czpickerViewDidClickCancelButton(_ pickerView: CZPickerView!) {
    }
    
    // MARK: - UIButton Actions
    @IBAction func btnAction_SelectedCourses(_ sender: Any) {
        
        self.openPickerViewForMarking()
    }
    
    @IBAction func btnAction_PREPARE(_ sender: Any) {
        
        if let objView = self.storyboard?.instantiateViewController(withIdentifier: "PrepareVC") {
            self.navigateToView(objView: objView)
        }
        
    }
    
    @IBAction func btnAction_MYTESTS(_ sender: Any) {
        
        if let objView = self.storyboard?.instantiateViewController(withIdentifier: "MyTestsVC") {
            self.navigateToView(objView: objView)
        }
    }
    
    @IBAction func btnAction_ACCOUNT(_ sender: Any) {
        
        if let objView = self.storyboard?.instantiateViewController(withIdentifier: "AccountVC") {
            self.navigateToView(objView: objView)
        }
    }
    
    @IBAction func btnAction_CONTACTUS(_ sender: Any) {
        
        if let objView = self.storyboard?.instantiateViewController(withIdentifier: "ContactUSVC") {
            self.navigateToView(objView: objView)
        }
    }
    
    @IBAction func btnAction_ABOUTUS(_ sender: Any) {
        
        if let objView = self.storyboard?.instantiateViewController(withIdentifier: "AboutUSVC") {
            self.navigateToView(objView: objView)
        }
    }
    
    //PopUp
    @IBAction func btnAction_PopUpRankOK(_ sender: Any) {
        self.viewForRankingPopUp.isHidden = true
    }
    

    //MARK:- Webservices Related Methods
    func api_getUserInstitutesList() -> Void {
        
        self.vcModelInstituteSub.removeAll()
        
        let urlForLogin = Constants.URL_BASE + "getInstitutes.php?userID=\(appDel.objUserDataModel.strUsername)&apiSecurityKey=\(Constants.apiSecurityKey)"
        
        Webservice.API(urlForLogin, param: nil, controller: self, header: nil, callSilently: false, methodType: .get, successBlock: { (dictResponse) in
            
            Constants.printLog(strLog: "getInstitutes dictResponse : \(dictResponse)")
            
            if let error = dictResponse.value(forKey: "success") {
                let strSuccess = String(describing: error)
                
                if strSuccess == "1" {
                    
                    if let dict =  dictResponse as? [String:Any]{
                        if let tempInstituteData = ModelInstitute.parseInstituteSub(dict: dict),tempInstituteData.count>0 {
                            self.vcModelInstituteSub = tempInstituteData
                            print("vcModelInstituteSub",self.vcModelInstituteSub)
                            print("vcModelInstituteSub Count" ,self.vcModelInstituteSub.count)
                        }
                    }
                }
                
                if self.vcModelInstituteSub.count > 0 {
                    self.api_getGraphData(strUserID: appDel.objUserDataModel.strUsername, strInstituteID: self.vcModelInstituteSub[0].instituteID!, strInstituteName: self.vcModelInstituteSub[0].name!)
                }else{
                    self.lbl_DisplayMsg.isHidden = false
                    self.lbl_DisplayMsg.text = "No courses added yet!!"

                }
            }
            
        }, failureBlock: { (error, isTimeOut) in
            Constants.printLog(strLog: String(describing: error?.localizedDescription))
        })
        
    }
    
    func api_getGraphData(strUserID:String,strInstituteID:String,strInstituteName:String) -> Void {
        
        
        self.vcModelTopic.removeAll()
        self.tbl_CourseDetails.reloadData()
        
        self.btn_SelectedCourses.setTitle(strInstituteName, for: .normal)
        self.btn_SelectedCourses.isHidden = false
        self.viewDashLine.isHidden = false
        
        self.strSelectedInstitute = strInstituteID
        
        //https://prepwyzr.com/android_api/getGraphData.php?userID=bhargav&instituteID=abChem&apiSecurityKey=!894$4v!B7b8REj

        let urlForLogin = Constants.URL_BASE + "getGraphData.php?userID=\(appDel.objUserDataModel.strUsername)&instituteID=\(strInstituteID)&apiSecurityKey=\(Constants.apiSecurityKey)"
        
        Webservice.API(urlForLogin, param: nil, controller: self, header: nil, callSilently: false, methodType: .get, successBlock: { (dictResponse) in
            
            Constants.printLog(strLog: "getGraphData dictResponse : \(dictResponse)")
            
            if let error = dictResponse.value(forKey: "success") {
                let strSuccess = String(describing: error)
                
                if strSuccess == "1" {
                    if let dict =  dictResponse as? [String:Any]{
                        if let tempToipc = ModelTopicSub.parseModelTopic(dict: dict),tempToipc.count>0 {
                            self.vcModelTopic = tempToipc
                            print("vcModelInstituteSub",self.vcModelTopic)
                            print("vcModelInstituteSub Count" ,self.vcModelTopic.count)
                        }
                    }
                    self.lbl_DisplayMsg.isHidden = true
                    self.tbl_CourseDetails.reloadData()
                    
                } else {
                    self.lbl_DisplayMsg.isHidden = false
                    self.lbl_DisplayMsg.text = "No data available for this institute!"
                }
            }
            
        }, failureBlock: { (error, isTimeOut) in
            Constants.printLog(strLog: String(describing: error?.localizedDescription))
        })
        
    }
    
    func api_getTopicRank(strTopicID:String,strInstituteID:String) -> Void {
        
        self.vcModelTopicRank.removeAll()
        self.tbl_PopUpRank.reloadData()
        
        let urlForLogin = Constants.URL_BASE + "getTopicRank.php?topicID=\(strTopicID)&instituteID=\(strInstituteID)&apiSecurityKey=\(Constants.apiSecurityKey)"
        
        Webservice.API(urlForLogin, param: nil, controller: self, header: nil, callSilently: false, methodType: .get, successBlock: { (dictResponse) in
            
            Constants.printLog(strLog: "getTopicRank dictResponse : \(dictResponse)")
            
            if let error = dictResponse.value(forKey: "success") {
                let strSuccess = String(describing: error)
                
                if strSuccess == "1" {
                    if let dict =  dictResponse as? [String:Any]{
                        if let tempTopicRankData = ModelTopicRank.parseTopicRank(dict: dict),tempTopicRankData.count>0 {
                            self.vcModelTopicRank = tempTopicRankData
                            print("vcModelTopicRank",self.vcModelTopicRank)
                            print("vcModelTopicRank Count" ,self.vcModelTopicRank)
                        }
                    }
                    self.viewForRankingPopUp.isHidden = false
                    self.tbl_PopUpRank.reloadData()                    
                } else {
                }
            }
            
        }, failureBlock: { (error, isTimeOut) in
            Constants.printLog(strLog: String(describing: error?.localizedDescription))
        })
        
    }
    
    
    //MARK:- Navigation Related Methods
    func navigateToView(objView:UIViewController) -> Void {
        self.navigationController?.pushViewController(objView, animated: true)
    }


}
