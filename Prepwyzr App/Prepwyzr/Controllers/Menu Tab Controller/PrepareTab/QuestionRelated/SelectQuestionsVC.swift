
//
//  SelectQuestionsVC.swift
//  Prepwyzr
//
//  Created by Riddhi on 04/08/18.
//  Copyright © 2018 Riddhi. All rights reserved.
//

import UIKit
import CZPicker

class SelectQuestionsVC: UIViewController,CZPickerViewDelegate,CZPickerViewDataSource {

    var czPickerView: CZPickerView?
    
    //MARK:- OutSide Variables
    var isItFromFree = false
    var strTopicID = ""
    var strTopicName = ""
    var strInstituteID = ""
    
    //MARK:- IBActions
    @IBOutlet var constraintH_StatusBar: NSLayoutConstraint!
    
    @IBOutlet var txtQuestions: UITextField!
    @IBOutlet var segmentForMode: UISegmentedControl!
    @IBOutlet var lblSegmentNotes: UILabel!
    
    //PopUpView
    @IBOutlet var popUpView_TestPreferences: UIView!
    @IBOutlet var popUpView_TestTimeInMinutes: UITextField!
    @IBOutlet var popUpView_SwitchOnOff: UISwitch!
    
    @IBOutlet var popUpView_btnSelectNagativeMarking: UIButton!
    
    //MARK:- Variables
    var arrNegativeMarking = ["10","20","25","33.33","50","75","100"]
    
    var strNegativeMarking = "0"
    
    //MODEL
    var vcModel: ModelTopicList!

    
    //MARK:- UIView Related Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436 {
            self.constraintH_StatusBar.constant = 44
        }
        
        if self.isItFromFree {
            self.txtQuestions.isUserInteractionEnabled = false
        }
        
        self.txtQuestions.addBorder(radius: 1, color: Constants.kColor_Green.cgColor)
        self.popUpView_btnSelectNagativeMarking.addBorder(radius: 1, color: Constants.kColor_Green.cgColor)
    
        self.popUpView_TestPreferences.frame = self.view.frame
        self.view.addSubview(self.popUpView_TestPreferences)
        self.popUpView_TestPreferences.isHidden = true
        
        self.popUpView_btnSelectNagativeMarking.isHidden = true
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        self.popUpView_TestPreferences.frame = self.view.frame
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- UISegmentedControl
    @IBAction func segmentAction_ChangeMode(_ sender: UISegmentedControl) {
        
        if self.isItFromFree && sender.selectedSegmentIndex == 0 {
            
            UIAlertController.showAlertWithOkButton(self, aStrMessage: "Casual Mode not available in Free Trail.", completion: { (index, strTitle) in
                sender.selectedSegmentIndex = 1
            })
        }
        
    }
    
    //MARK:- UISwitch
    @IBAction func switch_PopUpValueChange(_ sender: UISwitch) {
        
        self.popUpView_btnSelectNagativeMarking.isHidden = !sender.isOn
        
        if !sender.isOn {
            
            self.strNegativeMarking = ""
            self.popUpView_btnSelectNagativeMarking.setTitle("Select", for: .normal)
        }
        
    }
    
    //MARK:- CZPickerView Related Methods
    func openPickerViewForMarking() {
        
        czPickerView = CZPickerView(headerTitle: "Select Marking", cancelButtonTitle: "Cancel", confirmButtonTitle: "Confirm")
        czPickerView?.delegate = self
        czPickerView?.dataSource = self
        czPickerView?.headerBackgroundColor = Constants.kColor_Green
        czPickerView?.needFooterView = false
        czPickerView?.confirmButtonBackgroundColor = Constants.kColor_Green
        czPickerView?.show()
        
    }
    
    //Delegate Methods
    func numberOfRows(in pickerView: CZPickerView!) -> Int {
        return self.arrNegativeMarking.count
    }
    
    func czpickerView(_ pickerView: CZPickerView!, titleForRow row: Int) -> String! {
        return self.arrNegativeMarking[row] + "%"
    }
    
    func czpickerView(_ pickerView: CZPickerView!, didConfirmWithItemAtRow row: Int) {
        
        self.strNegativeMarking = self.arrNegativeMarking[row]
        self.popUpView_btnSelectNagativeMarking.setTitle(self.strNegativeMarking + "%", for: .normal)
    }
    
    
    func czpickerViewDidClickCancelButton(_ pickerView: CZPickerView!) {
    }
    
    
    //MARK:- UIButton Actions
    @IBAction func btnAction_Back(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAction_Start(_ sender: Any) {
        
        self.popUpView_TestPreferences.isHidden = false
    }
    
    //PopUpView Related Methods
    
    @IBAction func btnAction_ClosePopUpView(_ sender: Any) {
        self.popUpView_TestPreferences.isHidden = true
    }
    
    
    @IBAction func btnAction_PopUpViewSelectNagativeMarking(_ sender: Any) {
        
        self.openPickerViewForMarking()
    }
    
    @IBAction func btnAction_PopUpViewStartTest(_ sender: Any) {
        
        var strMinutes = ""
        if let min = self.popUpView_TestTimeInMinutes.text {
            strMinutes = min
        }
        
        var strTotalQuestions = "10"
        if let totalQue = self.txtQuestions.text {
            strTotalQuestions = String(describing: totalQue)
        }
        if strTotalQuestions.count == 0 {
            strTotalQuestions = "10"
        }
        
        if strMinutes.replacingOccurrences(of: " ", with: "").count == 0 {
            
            UIAlertController.showAlertWithOkButton(self, aStrMessage: "Enter Proper time.", completion: { (intIndex, strTitle) in
            })
            return
        }
        
        var testMode = "Test"
        if segmentForMode.selectedSegmentIndex == 0 {
            testMode = "Casual"
        }
        
        if let objQuestionListVC = self.storyboard?.instantiateViewController(withIdentifier: "QuestionListVC") as? QuestionListVC {
            
            objQuestionListVC.isItFromFree = self.isItFromFree
            objQuestionListVC.strMode_TestORCasual = testMode
            
            objQuestionListVC.strTopicID = self.strTopicID
            objQuestionListVC.strTopicName = self.strTopicName
            objQuestionListVC.strInstituteID = self.strInstituteID
            
            objQuestionListVC.strTotalQuestions = strTotalQuestions
            objQuestionListVC.strMinutes = strMinutes
            objQuestionListVC.strNegativeMarking = strNegativeMarking
            
            self.navigationController?.pushViewController(objQuestionListVC, animated: true)
        }
        
    }
    

}
