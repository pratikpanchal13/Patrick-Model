//
//  MyTestsVC.swift
//  Prepwyzr
//
//  Created by Riddhi on 21/07/18.
//  Copyright © 2018 Riddhi. All rights reserved.
//

import UIKit

class MyTestsVC: UIViewController {

    @IBOutlet var constraintH_StatusBar: NSLayoutConstraint!
    
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
    
    @IBAction func btnAction_Back(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    

}
