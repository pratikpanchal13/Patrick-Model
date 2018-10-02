//
//  CellTable_QuestionsFooter.swift
//  Prepwyzr
//
//  Created by Riddhi on 11/08/18.
//  Copyright © 2018 Riddhi. All rights reserved.
//

import UIKit

class CellTable_QuestionsFooter: UITableViewCell {

    @IBOutlet var btn_FlagThis: UIButton!
    @IBOutlet var btn_NextQuestions: UIButton!
    @IBOutlet var btn_ReSet: UIButton!
    
    //MARK:- UITableViewCell Related Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.btn_FlagThis.addBorder(radius: 0, color: Constants.kColor_Green.cgColor)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
