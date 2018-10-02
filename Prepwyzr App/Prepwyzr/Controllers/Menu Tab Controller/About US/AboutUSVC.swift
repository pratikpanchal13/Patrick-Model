//
//  AboutUSVC.swift
//  Prepwyzr
//
//  Created by Riddhi on 21/07/18.
//  Copyright © 2018 Riddhi. All rights reserved.
//

import UIKit

class AboutUSVC: UIViewController {

    //MARK:- OutSide Variables
    //var isFromLoginOrRegistrationScreen = false
    
    //MARK:- IBOutlets
    @IBOutlet var constraintH_StatusBar: NSLayoutConstraint!
    @IBOutlet var lblAppVersion: UILabel!
    
    //View For Information
    @IBOutlet var viewForInformation: UIView!
    @IBOutlet var webViewForHtmlLoad: UIWebView!
    
    
    @IBOutlet var btnBack: UIBarButtonItem!
    
    //MARK:- Vaariables
    
    //MARK:- UIView Related Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webViewForHtmlLoad.addBorder(radius: 0, color: Constants.kColor_Green.cgColor)
        
        if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436 {
            self.constraintH_StatusBar.constant = 44
        }
        
//        if !self.isFromLoginOrRegistrationScreen {
//            //Remove
//            self.btnBack.image = nil
//        }
        
        if let strVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") {
            self.lblAppVersion.text = "App Version: \(strVersion)"
        }
        
        self.viewForInformation.frame = self.view.frame
        self.view.addSubview(self.viewForInformation)
        self.viewForInformation.isHidden = true
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        self.viewForInformation.frame = self.view.frame
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- UIButton Actions
    @IBAction func btnAction_Back(_ sender: Any) {
        
        //if self.isFromLoginOrRegistrationScreen {
            self.navigationController?.popViewController(animated: true)
        //}
    }
    
    @IBAction func btnAction_PrivacyPolicy(_ sender: Any) {
        
        //self.webViewForHtmlLoad.loadHTMLString(Constants.getPrivacyPolicy(), baseURL: nil)
        if let url = Bundle.main.url(forResource: "Privacy_Policy/index", withExtension: "html") {
            self.webViewForHtmlLoad.loadRequest(URLRequest(url: url))
        }
        
        self.viewForInformation.isHidden = false
    }
    
    @IBAction func btnAction_TermsAndConditions(_ sender: Any) {
        
        //self.webViewForHtmlLoad.loadHTMLString(Constants.getTermsAndConditions(), baseURL: nil)
        if let url = Bundle.main.url(forResource: "Terms_Conditions/index", withExtension: "html") {
            self.webViewForHtmlLoad.loadRequest(URLRequest(url: url))
        }
        
        
        self.viewForInformation.isHidden = false
    }
    
    @IBAction func btnAction_CancellationAndRefundPolicy(_ sender: Any) {
        
        //self.webViewForHtmlLoad.loadHTMLString(Constants.getCancellationAndRefundPolicy(), baseURL: nil)
        if let url = Bundle.main.url(forResource: "Cancellation_Refund_Policy/index", withExtension: "html") {
            self.webViewForHtmlLoad.loadRequest(URLRequest(url: url))
        }        
        self.viewForInformation.isHidden = false
    }

    @IBAction func btnAction_ViewInformation_OK(_ sender: Any) {
        
        self.viewForInformation.isHidden = true
        
    }
    
    
    
}
