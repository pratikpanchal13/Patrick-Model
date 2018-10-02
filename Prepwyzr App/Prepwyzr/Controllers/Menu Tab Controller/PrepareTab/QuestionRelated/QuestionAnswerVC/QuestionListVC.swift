//
//  QuestionListVC.swift
//  Prepwyzr
//
//  Created by Riddhi on 05/08/18.
//  Copyright © 2018 Riddhi. All rights reserved.
//

import UIKit
import SDWebImage
import JTSImageViewController

class QuestionListVC: UIViewController,UITableViewDataSource,UITableViewDelegate {

    //MARK:- OutSide Variables
    var isItFromFree = false
    var strMode_TestORCasual = "Test"
    
    var strTopicID = ""
    var strTopicName = ""
    var strInstituteID = ""
    var strTotalQuestions = ""
    
    var strMinutes = ""
    var strNegativeMarking = ""
    
    //MARK:- Class References
    var timer = Timer()
    
    //MARK:- IBActions
    @IBOutlet var constraintH_StatusBar: NSLayoutConstraint!
    
    @IBOutlet var lblTimerValue: UILabel!
    
    @IBOutlet var lblCourseName: UILabel!
    @IBOutlet var lblQuestionCurrentAndTotal: UILabel!
    
    @IBOutlet var imgForFlag: UIImageView!
    @IBOutlet var imgForAnswer: UIImageView!
    
    
    @IBOutlet var tblQuestionList: UITableView!
    
    //PopUp View
    @IBOutlet var viewForQuestionsPopUP: UIView!
    @IBOutlet var tblQuestionPopUp: UITableView!
    
    
    //MARK:- Variables
    var arrQuestionsList = NSMutableArray()
    var intCurrentSelectedQuestions = 0
    var strCurrentSelectedQuestionsAnswer = ""
    
    var intSecondsForQuestions = 0
    
    var vcModelPracticTestList = [ModelPracticTestList] ()
    
    //MARK:- UIView Related Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblQuestionList.dataSource = self
        self.tblQuestionList.delegate = self
        
        self.tblQuestionPopUp.dataSource = self
        self.tblQuestionPopUp.delegate = self
        
        self.tblQuestionList.register(UINib(nibName: "CellTable_QuestionsHeaderView", bundle: nil), forCellReuseIdentifier: "CellTable_QuestionsHeaderView")
        self.tblQuestionList.register(UINib(nibName: "CellTable_QuestionsAnwserListForText", bundle: nil), forCellReuseIdentifier: "CellTable_QuestionsAnwserListForText")
        self.tblQuestionList.register(UINib(nibName: "CellTable_QuestionsFooter", bundle: nil), forCellReuseIdentifier: "CellTable_QuestionsFooter")
        
        
        if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436 {
            self.constraintH_StatusBar.constant = 44
        }
        
        //API Call
        self.getPracticeTestList()
        
        if let intMin = Int(self.strMinutes) {
            self.intSecondsForQuestions = intMin * 60
        }
        
        self.lblCourseName.text = self.strTopicName
        self.lblQuestionCurrentAndTotal.text = "\(intCurrentSelectedQuestions+1)/\(strTotalQuestions)"
        
        //For PopUp View
        self.viewForQuestionsPopUP.frame = self.view.frame
        self.view.addSubview(self.viewForQuestionsPopUP)
        self.viewForQuestionsPopUP.isHidden = true
        
        self.viewForQuestionsPopUP.isHidden = true
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        self.lblTimerValue.addBorder(radius: 0, color: Constants.kColor_Green.cgColor)
        
        self.viewForQuestionsPopUP.frame = self.view.frame
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Timer Related Methods
    @objc func updateTimer() {
        
        if self.intSecondsForQuestions == 0 {
            
//            UIAlertController.showAlertWithOkButton(self, aStrMessage: "Your time is over.", completion: { (intIndex, strTitle) in
            
            //MARK:- TODO // remove Comment
               // self.calculateQuestionsAndNavigateToResultScreen(isFromSubmit: false)
            //})
            
        } else {
            
            self.intSecondsForQuestions = self.intSecondsForQuestions - 1
            
            let hours = Int(self.intSecondsForQuestions) / 3600
            let minutes = Int(self.intSecondsForQuestions) / 60 % 60
            let seconds = Int(self.intSecondsForQuestions) % 60
            
            self.lblTimerValue.text = String(format:"%02i:%02i:%02i", hours, minutes, seconds)
        }
        
        
    }
    
    //MARK:- UIButton Actions
    @IBAction func btnAction_Back(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAction_SubmitQuestions(_ sender: Any) {
      
        print("vcModelPracticTestList",vcModelPracticTestList)
//        for(index ,dic) in vcModelPracticTestList.enumerated(){
//            print("Data ANswer \(index)",dic.UserAnswer)
//            print("Data Flag \(index)",dic.flag)
//        }
        
        self.calculateQuestionsAndNavigateToResultScreen(isFromSubmit: true)
    }
    
    @IBAction func btnAction_QuestionList(_ sender: Any) {
        
        self.tblQuestionPopUp.reloadData()
        self.viewForQuestionsPopUP.isHidden = false
    }
    
    //PopUp
    @IBAction func btnAction_PopUpClose(_ sender: Any) {
        self.viewForQuestionsPopUP.isHidden = true
    }
    
    //MARK:- Calculate All Questions Details
    func calculateQuestionsAndNavigateToResultScreen(isFromSubmit:Bool) {
        
        var intTotalMarks = 0
        
        var dblPassMarks : Double = 0.0
        var intPassAnswered = 0
        
        var dblFailedMarks : Double  = 0.0
        var intFailedAnswered = 0
        
        var dblNotAnswerdMarks : Double  = 0.0
        var intNotAnswered = 0
        
        for i in 0 ..< self.arrQuestionsList.count {
            
            let dict = self.arrQuestionsList[i] as? NSDictionary
            
            var strActualAnswer = ""
            if let ans = dict?.value(forKey: "ans") as? String {
                strActualAnswer = ans
            }
            
            var strUserAnswer = ""
            if let user_ans = dict?.value(forKey: "user_ans") as? String {
                strUserAnswer = user_ans
            }
            
            var strMarks = "0"
            if let marks = dict?.value(forKey: "marks") {
                strMarks = String(describing: marks)
            }
            
            intTotalMarks = intTotalMarks + Int(strMarks)!
            
            if strUserAnswer.count > 0 {
                
                if strActualAnswer == strUserAnswer {
                    dblPassMarks = dblPassMarks + Double(strMarks)!
                    
                    intPassAnswered = intPassAnswered + 1
                    
                } else {
                    dblFailedMarks = dblFailedMarks + Double(strMarks)!
                    
                    intFailedAnswered = intFailedAnswered + 1
                }
                
            } else {
                intNotAnswered = intNotAnswered + 1
                dblNotAnswerdMarks = dblNotAnswerdMarks + Double(strMarks)!
            }
        }
        
        if isFromSubmit {
            UIAlertController.showAlertWithOkCancelButton(self, strTitle: "Confirm", aStrMessage: "Are you sure you want to Submit Test? Questions not Answered: \(intNotAnswered)") { (intIndex, strTitle) in
                
                if intIndex == 0 {
                    
                    if let objQuestionsResult = self.storyboard?.instantiateViewController(withIdentifier: "QuestionsResultScreenVC") as? QuestionsResultScreenVC {
                        
                        objQuestionsResult.dblNegativeMarking = Double(self.strNegativeMarking)!
                        objQuestionsResult.arrQuestionsData = self.arrQuestionsList
                        objQuestionsResult.dblPassMarks = dblPassMarks
                        objQuestionsResult.dblFailedMarks = dblFailedMarks
                        objQuestionsResult.dblNotAnswerdMarks = dblNotAnswerdMarks
                        objQuestionsResult.intNotAnswered = intNotAnswered
                        objQuestionsResult.intPassAnswered = intPassAnswered
                        objQuestionsResult.intFailedAnswered = intFailedAnswered
                        objQuestionsResult.intTotalMarks = intTotalMarks
                        
                        self.navigationController?.pushViewController(objQuestionsResult, animated: true)
                    }
                    
                }
            }
        } else {
         
            UIAlertController.showAlertWithOkButton(self, strTitle: "Time Up!", aStrMessage: "Time's Up! Click OK to view the results. Questions not Answered: \(intNotAnswered)", completion: { (intIndex, strTitle) in
                
                if let objQuestionsResult = self.storyboard?.instantiateViewController(withIdentifier: "QuestionsResultScreenVC") as? QuestionsResultScreenVC {
                    
                    objQuestionsResult.dblNegativeMarking = Double(self.strNegativeMarking)!
                    objQuestionsResult.arrQuestionsData = self.arrQuestionsList
                    objQuestionsResult.dblPassMarks = dblPassMarks
                    objQuestionsResult.dblFailedMarks = dblFailedMarks
                    objQuestionsResult.dblNotAnswerdMarks = dblNotAnswerdMarks
                    objQuestionsResult.intNotAnswered = intNotAnswered
                    objQuestionsResult.intPassAnswered = intPassAnswered
                    objQuestionsResult.intFailedAnswered = intFailedAnswered
                    objQuestionsResult.intTotalMarks = intTotalMarks
                    
                    self.navigationController?.pushViewController(objQuestionsResult, animated: true)
                }
                
            })
        }
    }
    
    //MARK:- UITableView Related Methods
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        //For PopUp
        if tableView == tblQuestionPopUp {
            return 44
        }
        
        //Main Controller
        if indexPath.row == 0 {
            return 57
        }
        
        //Currenlty this answer is not there
//        if indexPath.row == 5 || indexPath.row == 6 || indexPath.row == 7 || indexPath.row == 8 {
//            return 0
//        }
        
        return 197
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        //For PopUp
        if tableView == tblQuestionPopUp {
            return 44
        }
        
        //Main Controller
        
        //Currenlty this answer is not there
//        if indexPath.row == 5 || indexPath.row == 6 || indexPath.row == 7 || indexPath.row == 8 {
//            return 0
//        }
        
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //For PopUp
        if tableView == tblQuestionPopUp {
            //return self.arrQuestionsList.count
            return self.vcModelPracticTestList.count
        }
        
        //Main Controller
        if self.vcModelPracticTestList.count > 0 {
        //if self.arrQuestionsList.count > 0 {
            
            return 4+1+1
            //return 8 + 1 + 1 //8 options, 1 Header  and 1 Footer
        }
        
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //For PopUp
        if tableView == tblQuestionPopUp {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_QuestionPopUp", for: indexPath) as! Cell_QuestionPopUp
            
            
            //let dictCell = self.arrQuestionsList[indexPath.row] as? NSDictionary
            
            let model = self.vcModelPracticTestList[indexPath.row]
            
            let strQuestionTitle = "Question \(indexPath.row+1)"

            if let marks = model.marks{
                cell.lblQuestionWithMark.text = strQuestionTitle + "\n" + "\(marks)" + " Mark"

            }
//            var strMakrs = "1"
//            if let marks = dictCell?.value(forKey: "marks") {
//                strMakrs = String(describing: marks)
//            }
//            cell.lblQuestionWithMark.text = strQuestionTitle + "\n" + strMakrs + " Mark"
            
            if let flag = model.flag{
                if flag == "1" {
                    cell.imgFlag.isHidden = false
                } else {
                    cell.imgFlag.isHidden = true
                }
                
            }
            /*
            var strFlag = ""
            if let flag = dictCell?.value(forKey: "flag") {
                strFlag = String(describing: flag)
            }
 
            
            if strFlag == "1" {
                cell.imgFlag.isHidden = false
            } else {
                cell.imgFlag.isHidden = true
            }
 
            
             
            //imgRight
            var strUserAns = ""
            if let user_ans = dictCell?.value(forKey: "user_ans") {
                strUserAns = String(describing: user_ans)
            }
            
            if strUserAns.count > 0 {
                cell.imgRight.isHidden = false
            } else {
                cell.imgRight.isHidden = true
            }
            */
            
            if let userAnswer = model.UserAnswer{
                if userAnswer.count > 0 {
                    cell.imgRight.isHidden = false
                } else {
                    cell.imgRight.isHidden = true
                }
            }
            
            
            return cell
        }
        
        //Main Controller
        
        self.lblQuestionCurrentAndTotal.text = "\(intCurrentSelectedQuestions+1)/\(strTotalQuestions)"
        
        //let dictCell = self.arrQuestionsList[self.intCurrentSelectedQuestions] as? NSDictionary
        
        let model = self.vcModelPracticTestList[self.intCurrentSelectedQuestions]
        
        
        if let flag = model.flag{
            
            if flag == "1"{
                self.imgForFlag.isHidden = false
            }else{
                self.imgForFlag.isHidden = true

            }
        }
        /*
        var strFlag = ""
        if let flag = dictCell?.value(forKey: "flag") {
            strFlag = String(describing: flag)
        }
        
        if strFlag == "1" {
            self.imgForFlag.isHidden = false
        } else {
            self.imgForFlag.isHidden = true
        }
 
         */
        
        //For User Answer
        let strUserAnswer = self.strCurrentSelectedQuestionsAnswer
        
        if strUserAnswer.count > 0 {
            self.imgForAnswer.isHidden = false
        } else {
            self.imgForAnswer.isHidden = true
        }
        
        
        //For Header
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellTable_QuestionsHeaderView", for: indexPath) as! CellTable_QuestionsHeaderView
            
            cell.lblQuestionNumber.text = "Question : \(self.intCurrentSelectedQuestions+1)"
            
            if let marks = model.marks{
                cell.lblQuestionMarks.text = "\(marks)" + " Mark"
            }
            
//            var strMakrs = "1"
//            if let marks = dictCell?.value(forKey: "marks") {
//                strMakrs = String(describing: marks)
//            }
//
//            cell.lblQuestionMarks.text = strMakrs + " Mark"

            if let quesImg = model.quesImg{
                
                cell.activityIndicatorView_QuestionImage.stopAnimating()
                
                if (quesImg.lowercased() == "na") {
                    cell.constraintH_imgQuestionImage.constant = 0
                } else {
                    cell.constraintH_imgQuestionImage.constant = 123
                    if let urlForUpload = URL(string: quesImg) {
                        cell.activityIndicatorView_QuestionImage.startAnimating()
                        cell.imgQuestionImage.sd_setImage(with: urlForUpload, placeholderImage: UIImage(), options: .refreshCached) { (image, error, cacheType, url) in
                            cell.activityIndicatorView_QuestionImage.stopAnimating()
                        }
                    }
                    
                }
            }
//            var strQuesImg = ""
//            if let quesImg = dictCell?.value(forKey: "quesImg") as? String {
//                strQuesImg = quesImg
//            }
            
//            cell.activityIndicatorView_QuestionImage.stopAnimating()
//            if (strQuesImg.lowercased() == "na") {
//                cell.constraintH_imgQuestionImage.constant = 0
//            } else {
//                cell.constraintH_imgQuestionImage.constant = 123
//                if let urlForUpload = URL(string: strQuesImg) {
//                    cell.activityIndicatorView_QuestionImage.startAnimating()
//                    cell.imgQuestionImage.sd_setImage(with: urlForUpload, placeholderImage: UIImage(), options: .refreshCached) { (image, error, cacheType, url) in
//                        cell.activityIndicatorView_QuestionImage.stopAnimating()
//                    }
//                }
//
//            }

            if let question = model.question{
             
                if (question.lowercased() == "!@ns@!") || (question.lowercased() == "na") {
                    cell.constraintH_lblQuestion.constant = 0
                    cell.lblQuestion.text = ""
                } else {
                    cell.lblQuestion.text = question
                }
            }
            
//            var strQuestion = ""
//            if let question = dictCell?.value(forKey: "question") as? String {
//                strQuestion = question
//            }
            
//            if (strQuestion.lowercased() == "!@ns@!") || (strQuestion.lowercased() == "na") {
//                cell.constraintH_lblQuestion.constant = 0
//                cell.lblQuestion.text = ""
//            } else {
//
//                let strvalue = strQuestion as? NSString
//                cell.lblQuestion.text = strvalue as? String
//            }
            
            
            cell.btn_OpenImageView.addTarget(self, action: #selector(btnAction_OpenHeaderImage(sender:)), for: .touchUpInside)
            
            return cell
            
        //} else if indexPath.row == 5 {
            
        } else if indexPath.row == 5 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellTable_QuestionsFooter", for: indexPath) as! CellTable_QuestionsFooter

            if let flag = model.flag{
                if flag == "1" {
                    cell.btn_FlagThis.setTitle("UNFLAG", for: .normal)
                } else {
                    cell.btn_FlagThis.setTitle("FLAG THIS", for: .normal)
                }
            }
//            var strFlag = ""
//            if let flag = dictCell?.value(forKey: "flag") {
//                strFlag = String(describing: flag)
//            }
//
//            if strFlag == "1" {
//                cell.btn_FlagThis.setTitle("UNFLAG", for: .normal)
//            } else {
//                cell.btn_FlagThis.setTitle("FLAG THIS", for: .normal)
//            }
            
            cell.btn_ReSet.addTarget(self, action: #selector(btnAction_ReSet(sender:)), for: .touchUpInside)
            cell.btn_FlagThis.addTarget(self, action: #selector(btnAction_FlagThis(sender:)), for: .touchUpInside)
            cell.btn_NextQuestions.addTarget(self, action: #selector(btnAction_NextQuestions(sender:)), for: .touchUpInside)
            
 
            return cell
            
        }

        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellTable_QuestionsAnwserListForText", for: indexPath) as! CellTable_QuestionsAnwserListForText
        
        var strQuesImg = ""
        var strQuestion = ""
        
        if indexPath.row == 1 {
            
            cell.lblOptionsNumber.text = "A"
            cell.btn_OpenImageView.accessibilityLabel = "A"
            
            if let quesImg = model.optAImg{
                strQuesImg = quesImg
            }
            if let question = model.optA{
                strQuestion = question
            }
            
//            if let quesImg = dictCell?.value(forKey: "optAImg") as? String {
//                strQuesImg = quesImg
//            }
//
//            if let question = dictCell?.value(forKey: "optA") as? String {
//                strQuestion = question
//            }
            
            if strUserAnswer == "A" {
                
                cell.viewForBackground.backgroundColor = Constants.kColor_Green
                cell.lblOptionsValue.textColor = UIColor.white
                
            } else {
                
                cell.viewForBackground.backgroundColor = UIColor.white
                cell.lblOptionsValue.textColor =  Constants.kColor_Green
            }
            
        }
        else if indexPath.row == 2 {
            cell.lblOptionsNumber.text = "B"
            cell.btn_OpenImageView.accessibilityLabel = "B"

            if let quesImg = model.optBImg{
                strQuesImg = quesImg
            }
            if let question = model.optB{
                strQuestion = question
            }
            
//            if let quesImg = dictCell?.value(forKey: "optBImg") as? String {
//                strQuesImg = quesImg
//            }
//
//            if let question = dictCell?.value(forKey: "optB") as? String {
//                strQuestion = question
//            }
            
            if strUserAnswer == "B" {
                
                cell.viewForBackground.backgroundColor = Constants.kColor_Green
                cell.lblOptionsValue.textColor = UIColor.white
                
            } else {
                
                cell.viewForBackground.backgroundColor = UIColor.white
                cell.lblOptionsValue.textColor =  Constants.kColor_Green
            }
            
        }
        else if indexPath.row == 3 {
            cell.lblOptionsNumber.text = "C"
            cell.btn_OpenImageView.accessibilityLabel = "C"

            
            if let quesImg = model.optCImg{
                strQuesImg = quesImg
            }
            if let question = model.optC{
                strQuestion = question
            }
            
//            if let quesImg = dictCell?.value(forKey: "optCImg") as? String {
//                strQuesImg = quesImg
//            }
//
//            if let question = dictCell?.value(forKey: "optC") as? String {
//                strQuestion = question
//            }
            
            if strUserAnswer == "C" {
                
                cell.viewForBackground.backgroundColor = Constants.kColor_Green
                cell.lblOptionsValue.textColor = UIColor.white
                
            } else {
                
                cell.viewForBackground.backgroundColor = UIColor.white
                cell.lblOptionsValue.textColor =  Constants.kColor_Green
            }
        }
        else if indexPath.row == 4 {
            cell.lblOptionsNumber.text = "D"
            cell.btn_OpenImageView.accessibilityLabel = "D"

            
            if let quesImg = model.optDImg{
                strQuesImg = quesImg
            }
            if let question = model.optD{
                strQuestion = question
            }
            
//            if let quesImg = dictCell?.value(forKey: "optDImg") as? String {
//                strQuesImg = quesImg
//            }
//
//            if let question = dictCell?.value(forKey: "optD") as? String {
//                strQuestion = question
//            }
            
            if strUserAnswer == "D" {
                
                cell.viewForBackground.backgroundColor = Constants.kColor_Green
                cell.lblOptionsValue.textColor = UIColor.white
                
            } else {
                
                cell.viewForBackground.backgroundColor = UIColor.white
                cell.lblOptionsValue.textColor =  Constants.kColor_Green
            }
            
        }
//        else if indexPath.row == 5 {
//            cell.lblOptionsNumber.text = "E"
//        }
//        else if indexPath.row == 6 {
//            cell.lblOptionsNumber.text = "F"
//        }
//        else if indexPath.row == 7 {
//            cell.lblOptionsNumber.text = "G"
//        }
//        else if indexPath.row == 8 {
//            cell.lblOptionsNumber.text = "H"
//        }
//        else if indexPath.row == 5 || indexPath.row == 6 || indexPath.row == 7 || indexPath.row == 8 {
//            cell.constraintH_OptionsImage.constant = 0
//            cell.constraintH_OptionsValue.constant = 0
//        }
        
        cell.activityIndicatorView_ImgOptions.stopAnimating()
        if (strQuesImg.lowercased() == "na") || strQuesImg.lowercased().count == 0 {
            cell.constraintH_OptionsImage.constant = 0
        } else {
            
            cell.constraintH_OptionsImage.constant = 120
            
            if let urlForUpload = URL(string: strQuesImg) {
        
                cell.activityIndicatorView_ImgOptions.startAnimating()
                cell.imgOptions.sd_setImage(with: urlForUpload, placeholderImage: UIImage(), options: .refreshCached) { (image, error, cacheType, url) in
                    cell.activityIndicatorView_ImgOptions.stopAnimating()
                }
            }
            
        }
        if (strQuestion.lowercased() == "!@ns@!") || (strQuestion.lowercased() == "na") || strQuestion.lowercased().count == 0 {
            cell.constraintH_OptionsValue.constant = 0
            cell.lblOptionsValue.text = ""
        } else {
            cell.lblOptionsValue.text = strQuestion
        }
        
        cell.btn_OpenImageView.addTarget(self, action: #selector(btnAction_OpenQuestionsImage(sender:)), for: .touchUpInside)
        
        cell.layoutIfNeeded()
        return cell
 
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        //For PopUp
        if tableView == tblQuestionPopUp {
            
            self.intCurrentSelectedQuestions = indexPath.row
            self.tblQuestionList.reloadData()
            self.viewForQuestionsPopUP.isHidden = true
            return
        }
        
        //Main Controller
        
        if indexPath.row == 1 {
            self.strCurrentSelectedQuestionsAnswer = "A"
        } else if indexPath.row == 2 {
            self.strCurrentSelectedQuestionsAnswer = "B"
        } else if indexPath.row == 3 {
            self.strCurrentSelectedQuestionsAnswer = "C"
        } else if indexPath.row == 4 {
            self.strCurrentSelectedQuestionsAnswer = "D"
        }

        print("Answer",self.strCurrentSelectedQuestionsAnswer)
        vcModelPracticTestList[intCurrentSelectedQuestions].UserAnswer = self.strCurrentSelectedQuestionsAnswer
        tableView.reloadData()

//        vcModelPracticTestList = vcModelPracticTestList.map{
//            var mutableBook = $0
//            if intCurrentSelectedQuestions == 1{
//                if $0.UserAnswer == "" {
//                    mutableBook.UserAnswer = strCurrentSelectedQuestionsAnswer
//                }
//            }
//
//            return mutableBook
//        }
//
        
        
//        vcModelPracticTestList = vcModelPracticTestList.map{
//            var mutableCopyAnswer = $0
//
//            if $0 == "1" {
//                mutableCopyAnswer.UserAnswer = self.strCurrentSelectedQuestionsAnswer
//            }
//            return mutableCopyAnswer
//        }
//
//        if let dictCell = self.arrQuestionsList[self.intCurrentSelectedQuestions] as? NSDictionary {
//            let dictMutuableData = NSMutableDictionary(dictionary: dictCell)
//
//            dictMutuableData.setValue(self.strCurrentSelectedQuestionsAnswer, forKey: "user_ans")
//            self.arrQuestionsList.replaceObject(at: self.intCurrentSelectedQuestions, with: dictMutuableData)
//
//        }
        
        //tableView.reloadData()
    }

    @objc func btnAction_OpenHeaderImage(sender:UIButton) -> Void {
        
        let dictCell = self.arrQuestionsList[self.intCurrentSelectedQuestions] as? NSDictionary
        var strQuesImg = ""
        if let quesImg = dictCell?.value(forKey: "quesImg") as? String {
            strQuesImg = quesImg
        }
        
        if strQuesImg.count > 0 {
            self.openJTSImageViewController(strURL: strQuesImg, sender: sender)
        }
        
    }
    
    @objc func btnAction_OpenQuestionsImage(sender:UIButton) -> Void {
    }
    
    @objc func btnAction_FlagThis(sender:UIButton) -> Void {
        
        let model = vcModelPracticTestList[self.intCurrentSelectedQuestions]
        
        if let flag = model.flag{
//            if flag == "1" {
//                model.flag = "0"
//            } else {
//                //dictMutuableData.setValue("1", forKey: "flag")
//                model.flag = "1"
//            }

            vcModelPracticTestList = vcModelPracticTestList.map{
                var mutableFlag = $0
                if $0.flag == "1" {
                    mutableFlag.flag = "0"
                }else{
                    mutableFlag.flag = "1"
                }
                return mutableFlag
            }
            self.tblQuestionList.reloadData()

            
            
//            if let row = self.upcoming.index(where: {$0.eventID == id}) {
//                array[row] = newValue
//            }
            //vcModelPracticTestList[self.intCurrentSelectedQuestions].
        }
        /*
        
        if let dictCell = self.arrQuestionsList[self.intCurrentSelectedQuestions] as? NSDictionary {
            let dictMutuableData = NSMutableDictionary(dictionary: dictCell)
            
            
            var strFlag = ""
            if let flag = dictCell.value(forKey: "flag") {
                strFlag = String(describing: flag)
            }
            
            if strFlag == "1" {
                dictMutuableData.setValue("0", forKey: "flag")
            } else {
                dictMutuableData.setValue("1", forKey: "flag")
            }
            
            self.arrQuestionsList.replaceObject(at: self.intCurrentSelectedQuestions, with: dictMutuableData)
        }
        
        self.tblQuestionList.reloadData()
        */
    }
    
    @objc func btnAction_NextQuestions(sender:UIButton) -> Void {
        
        let model = vcModelPracticTestList[self.intCurrentSelectedQuestions]
        
        if let user_ans = model.UserAnswer {
            self.strCurrentSelectedQuestionsAnswer = user_ans
            vcModelPracticTestList[self.intCurrentSelectedQuestions].UserAnswer = user_ans

        }
//        vcModelPracticTestList = vcModelPracticTestList.map{
//            var mutableFlag = $0
//
//            if let user_ans = model.UserAnswer {
//                self.strCurrentSelectedQuestionsAnswer = user_ans
//            }
//
//            mutableFlag.UserAnswer = self.strCurrentSelectedQuestionsAnswer
//
////            if $0.UserAnswer == "1" {
////                mutableFlag.UserAnswer = self.strCurrentSelectedQuestionsAnswer
////            }else{
////                mutableFlag.UserAnswer = self.strCurrentSelectedQuestionsAnswer
////            }
//            return mutableFlag
//        }
        self.intCurrentSelectedQuestions = self.intCurrentSelectedQuestions + 1

        self.tblQuestionList.reloadData()

        /*
        if self.arrQuestionsList.count-1 > self.intCurrentSelectedQuestions {
        
            if let dictCell = self.arrQuestionsList[self.intCurrentSelectedQuestions] as? NSDictionary {
//                let dictMutuableData = NSMutableDictionary(dictionary: dictCell)
//
//                dictMutuableData.setValue(self.strCurrentSelectedQuestionsAnswer, forKey: "user_ans")
//
//                self.arrQuestionsList.replaceObject(at: self.intCurrentSelectedQuestions, with: dictMutuableData)
                
                self.intCurrentSelectedQuestions = self.intCurrentSelectedQuestions + 1
                
                //Set Next Value
                
                let dictCellNext = self.arrQuestionsList[self.intCurrentSelectedQuestions] as? NSDictionary
                self.strCurrentSelectedQuestionsAnswer = ""
                if let user_ans = dictCellNext?.value(forKey: "user_ans") as? String {
                    self.strCurrentSelectedQuestionsAnswer = user_ans
                }
                
            }
        }
        
        self.tblQuestionList.reloadData()
 */
    }
    
    @objc func btnAction_ReSet(sender:UIButton) -> Void {
        
        if let dictCell = self.arrQuestionsList[self.intCurrentSelectedQuestions] as? NSDictionary {
            let dictMutuableData = NSMutableDictionary(dictionary: dictCell)
            
            self.strCurrentSelectedQuestionsAnswer = ""
            dictMutuableData.setValue("", forKey: "user_ans")
            
            self.arrQuestionsList.replaceObject(at: self.intCurrentSelectedQuestions, with: dictMutuableData)
            
        }
        
        self.tblQuestionList.reloadData()
    }
    
    //MARK:- API Related Methods
    func getPracticeTestList() -> Void {
        
        //    https://prepwyzr.com/android_api/getPracticeTest.php?topicID=4&instituteID=abChem&count=10&apiSecurityKey=!894$4v!B7b8REj
        
        var urlForLogin = Constants.URL_BASE + "getPracticeTest.php?topicID=\(self.strTopicID)&instituteID=\(self.strInstituteID)&apiSecurityKey=\(Constants.apiSecurityKey)&count=\(self.strTotalQuestions)"
        
        if self.strMode_TestORCasual == "Test" {
            urlForLogin = Constants.URL_BASE + "getPracticeTestFree.php?topicID=\(self.strTopicID)&instituteID=\(self.strInstituteID)&apiSecurityKey=\(Constants.apiSecurityKey)&count=\(self.strTotalQuestions)"
        }
        
        Webservice.API(urlForLogin, param: nil, controller: self, header: nil, methodType: .get, successBlock: { (dictResponse) in
            
            Constants.printLog(strLog: "getPackageInfo dictResponse : \(dictResponse)")
            
            if let success = dictResponse.value(forKey: "success") {
                let strSuccess = String(describing: success)
                
                if strSuccess == "1" {
                   
                    
                    if let dict = dictResponse as? [String:Any]{
                        if let tempModelPracticTestList = ModelPracticTestList.parseModelPracticTestList(dict: dict) , tempModelPracticTestList.count > 0{
                         
                            self.vcModelPracticTestList = tempModelPracticTestList
                            print("self.vcModelPracticTestList",self.vcModelPracticTestList)
                            print("self.vcModelPracticTestList COunt",self.vcModelPracticTestList.count)
                            
                            self.tblQuestionList.reloadData()

                        }
                        
                    }
                    /*
                    if let posts = dictResponse.value(forKey: "posts") as? NSArray {
                        self.arrQuestionsList = NSMutableArray(array: posts)
                        self.tblQuestionList.reloadData()
                    }
                    */
                    
                    self.timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
                }
                
            }
            
        }) { (error, isTimeOut) in
            Constants.printLog(strLog: String(describing: error?.localizedDescription))
        }
        
    }

    //MARK:- JSTViewController
    func openJTSImageViewController(strURL:String,sender:UIButton) -> Void {
        
        if let urlForImage = URL(string: strURL) {
            
            let imageInfo = JTSImageInfo()
            imageInfo.imageURL = urlForImage
            imageInfo.referenceRect = sender.frame
            imageInfo.referenceView = sender.superview;
            
            let imageViewer = JTSImageViewController(imageInfo: imageInfo, mode: JTSImageViewControllerMode.image, backgroundStyle: JTSImageViewControllerBackgroundOptions.scaled)
            imageViewer?.show(from: self, transition: JTSImageViewControllerTransition.fromOriginalPosition)
            
        }
    }
    
    
    
}
