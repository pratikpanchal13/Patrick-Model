//
//  TopicsVC.swift
//  Prepwyzr
//
//  Created by Riddhi on 28/07/18.
//  Copyright © 2018 Riddhi. All rights reserved.
//

import UIKit

class TopicsVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    //MARK:- OutSide Variables
    //var dictInstituteData = NSDictionary()
    var isFromFree = false
    
    var vcModel: ModelInstituteList!
    
    var vcModelTopicList : [ModelTopicList] = []
    var selectedTopicList : ModelTopicList?
    
    //MARK:- IBOutlets
    @IBOutlet var constraintH_StatusBar: NSLayoutConstraint!
    
    @IBOutlet weak var tbl_TopicsList: UITableView!
    
    //MARK:- Varibales
    var arrTopicsList = NSMutableArray()
    
    //MARK:- UIView Related Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tbl_TopicsList.delegate = self
        self.tbl_TopicsList.dataSource = self
        
        if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436 {
            self.constraintH_StatusBar.constant = 44
        }
        
        if let instituteID = vcModel.instituteID{
            self.getTopicsList(strInstituteID: "\(instituteID)")
        }
        /*
        if let instituteID = self.dictInstituteData.value(forKey: "instituteID") as? String {
            self.getTopicsList(strInstituteID: instituteID)
        }
        */
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- UIButton Actions
    @IBAction func btnAction_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK:- UITableView Related Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vcModelTopicList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_TopicsList", for: indexPath) as! Cell_TopicsList
        
        let model = vcModelTopicList[indexPath.row]
        if let topicName = model.topicName{
            cell.lbl_TopicsName.text = topicName
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let model  = self.vcModelTopicList[indexPath.row]
        self.selectedTopicList = model

        if let instituteID = vcModel.instituteID{
            
            if let objSelectQuestionsVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectQuestionsVC") as? SelectQuestionsVC {
                objSelectQuestionsVC.isItFromFree = self.isFromFree
                objSelectQuestionsVC.strInstituteID = instituteID
                objSelectQuestionsVC.vcModel = self.selectedTopicList
                self.navigationController?.pushViewController(objSelectQuestionsVC, animated: true)
            }
        }

    }
    
    //MARK:- API Related Methods
    func getTopicsList(strInstituteID:String) -> Void {
        
        //https://prepwyzr.com/android_api/getTopics.php?instituteID=abChem&apiSecurityKey=!894$4v!B7b8REj
        
        let urlForLogin = Constants.URL_BASE + "getTopics.php?instituteID=\(strInstituteID)&apiSecurityKey=\(Constants.apiSecurityKey)"
        
        Webservice.API(urlForLogin, param: nil, controller: self, header: nil, methodType: .get, successBlock: { (dictResponse) in
            
            Constants.printLog(strLog: "getPackageInfo dictResponse : \(dictResponse)")
            
            if let success = dictResponse.value(forKey: "success") {
                let strSuccess = String(describing: success)
                
                if strSuccess == "1" {
                    
                    if let dict =  dictResponse as? [String:Any]{
                        if let tempTopicList = ModelTopicList.parseTopicList(dict: dict),tempTopicList.count>0 {
                            self.vcModelTopicList = tempTopicList
                            print("vcModelTopicList",self.vcModelTopicList)
                            print("vcModelTopicList Count" ,self.vcModelTopicList)
                            self.tbl_TopicsList.reloadData()

                        }
                    }
                    /*
                    if let posts = dictResponse.value(forKey: "posts") as? NSArray {
                        self.arrTopicsList = NSMutableArray(array: posts)
                        self.tbl_TopicsList.reloadData()
                    }
                    */
                    
                    
                }
                
            }
            
        }) { (error, isTimeOut) in
            Constants.printLog(strLog: String(describing: error?.localizedDescription))
        }
        
    }
    
    
}

class Cell_TopicsList: UITableViewCell {
    
    @IBOutlet weak var lbl_TopicsName: UILabel!
    
    
}
