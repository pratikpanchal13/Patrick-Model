//
//  CellTable_QuestionsAnwserListForText.swift
//  Prepwyzr
//
//  Created by Riddhi on 09/08/18.
//  Copyright © 2018 Riddhi. All rights reserved.
//

import UIKit

class CellTable_QuestionsAnwserListForText: UITableViewCell {

    //MARK:- IBOutlets
    @IBOutlet var viewForBackground: UIView!
    
    @IBOutlet var lblOptionsNumber: UILabel!
    
    @IBOutlet var lblOptionsValue: UILabel!
    @IBOutlet var constraintH_OptionsValue: NSLayoutConstraint!
    
    @IBOutlet var imgOptions: UIImageView!
    @IBOutlet var activityIndicatorView_ImgOptions: UIActivityIndicatorView!
    @IBOutlet var btn_OpenImageView: UIButton!
    
    @IBOutlet var constraintH_OptionsImage: NSLayoutConstraint!
    
    
    //MARK:- UITableView Cell
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.viewForBackground.addBorder(radius: 1, color: Constants.kColor_Green.cgColor)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
