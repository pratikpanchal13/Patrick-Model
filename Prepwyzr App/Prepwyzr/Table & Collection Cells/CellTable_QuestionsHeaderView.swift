//
//  CellTable_QuestionsHeaderView.swift
//  Prepwyzr
//
//  Created by Riddhi on 05/08/18.
//  Copyright © 2018 Riddhi. All rights reserved.
//

import UIKit

class CellTable_QuestionsHeaderView: UITableViewCell {

    
    @IBOutlet var lblQuestionNumber: UILabel!
    @IBOutlet var lblQuestionMarks: UILabel!
    
    @IBOutlet var lblQuestion: UILabel!
    @IBOutlet var constraintH_lblQuestion: NSLayoutConstraint!
    
    @IBOutlet var imgQuestionImage: UIImageView!
    @IBOutlet var activityIndicatorView_QuestionImage: UIActivityIndicatorView!
    @IBOutlet var btn_OpenImageView: UIButton!
    
    @IBOutlet var constraintH_imgQuestionImage: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
