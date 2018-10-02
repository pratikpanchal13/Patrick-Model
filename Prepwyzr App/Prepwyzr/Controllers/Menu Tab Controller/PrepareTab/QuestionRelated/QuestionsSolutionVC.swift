//
//  QuestionsSolutionVC.swift
//  Prepwyzr
//
//  Created by Mitul Mandanka on 19/08/18.
//  Copyright © 2018 Mitul Mandanka. All rights reserved.
//

import UIKit

class QuestionsSolutionVC: UIViewController {

    //MARK:- OutSide Variables
    var arrQuestionsData = NSMutableArray()
    
    //MARK:- IBOutlet
    @IBOutlet var constraintH_StatusBar: NSLayoutConstraint!
    
    @IBOutlet var tbl_QuestionSolutions: UITableView!
    
    
    //MARK:- UIView Related Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436 {
            self.constraintH_StatusBar.constant = 44
        }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK:- UIButton Related Methods
    @IBAction func btnAction_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK:- UITableView Related Methods

}
