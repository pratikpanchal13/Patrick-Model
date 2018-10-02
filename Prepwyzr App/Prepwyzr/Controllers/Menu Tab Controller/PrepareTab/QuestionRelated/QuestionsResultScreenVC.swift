//
//  QuestionsResultScreenVC.swift
//  Prepwyzr
//
//  Created by Mitul Mandanka on 17/08/18.
//  Copyright © 2018 Mitul Mandanka. All rights reserved.
//

import UIKit
import Charts

class QuestionsResultScreenVC: UIViewController {

    //MARK:- OutSide Variables
    var arrQuestionsData = NSMutableArray()
    
    var intTotalMarks = 0
    
    var dblPassMarks : Double = 0.0
    var intPassAnswered = 0
    
    var dblFailedMarks : Double  = 0.0
    var intFailedAnswered = 0
    
    var dblNotAnswerdMarks : Double  = 0.0
    var intNotAnswered = 0
    
    var dblNegativeMarking : Double = 0.0 // in Percentage
    
    //MARK:- IBOutlet
    @IBOutlet var constraintH_StatusBar: NSLayoutConstraint!
    
    @IBOutlet var pieChartView: PieChartView!
    
    @IBOutlet var viewForDisplayCalculation: UIView!
    
    @IBOutlet var lbl_YouScored: UILabel!
    @IBOutlet var lbl_ToTalQuestions: UILabel!
    @IBOutlet var lbl_RightAnsw: UILabel!
    @IBOutlet var lbl_WrongAnsw: UILabel!
    
    @IBOutlet var lbl_Marks: UILabel! //1.0/10.0
    
    @IBOutlet var lbl_CorrectAnswerMarks: UILabel!
    @IBOutlet var lbl_NegativeMarks: UILabel!
    @IBOutlet var lbl_ObtainedMarks: UILabel!
    
    
    
    //MARK:- UIView Related Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436 {
            self.constraintH_StatusBar.constant = 44
        }
        
        self.setupUI()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- SetUp View
    func setupUI() -> Void {
        
        self.viewForDisplayCalculation.addBorder(radius: 1, color: Constants.kColor_Green.cgColor)
        
        var totalObtainMarks : Double = 0.0
        
        self.lbl_ToTalQuestions.text = "Total Number Of Questions : \(self.arrQuestionsData.count)"
        
        self.lbl_RightAnsw.text = "Right Answers: \(self.intPassAnswered)"
        self.lbl_WrongAnsw.text = "Right Answers: \(self.intFailedAnswered)"
        
        
        let percentagePass = (self.dblPassMarks * 100) / Double(self.arrQuestionsData.count)
        let percentageFailed = (self.dblFailedMarks * 100) / Double(self.arrQuestionsData.count)
        
        if self.dblNegativeMarking > 0 {
         
            let negativeMarks = (self.dblFailedMarks * self.dblNegativeMarking) / 100
            totalObtainMarks = self.dblPassMarks - negativeMarks
            
            self.lbl_NegativeMarks.text = "- \(negativeMarks)"
            
        } else {
            totalObtainMarks = self.dblPassMarks
        }
        
        self.lbl_Marks.text = "\(totalObtainMarks)/\(self.intTotalMarks)"
        
        self.lbl_CorrectAnswerMarks.text = "\(self.dblPassMarks)"
        self.lbl_ObtainedMarks.text = "\(totalObtainMarks)"
        
        self.lbl_YouScored.text = "You Scored : \(totalObtainMarks)"
        
        //Pie Chart
        var pieChartEntries : [PieChartDataEntry] = Array()
        
        pieChartEntries.append(PieChartDataEntry(value: percentagePass, label: "Correct Answers"))
        pieChartEntries.append(PieChartDataEntry(value: percentageFailed, label: "Wrong Answers"))
        
        if self.intNotAnswered > 0 {
            
            let percentageNotAnswered = (self.dblNotAnswerdMarks * 100) / Double(self.arrQuestionsData.count)
            pieChartEntries.append(PieChartDataEntry(value: percentageNotAnswered, label: "Not Answers"))
        }
        
        let pieChartDataSet = PieChartDataSet(values: pieChartEntries, label: "")
        pieChartDataSet.colors = [UIColor.color(fromHexString: "0x00D400"),UIColor.red,UIColor.color(fromHexString: "0xDAC700")]
        
        self.pieChartView.backgroundColor = UIColor.lightGray
        self.pieChartView.centerText = ""
        self.pieChartView.chartDescription?.text = ""
        self.pieChartView.data = PieChartData(dataSet: pieChartDataSet)
    }
    

    //MARK:- UIButton Related Methods
    @IBAction func btnAction_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
