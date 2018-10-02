//
//  CellTable_HomeCourse.swift
//  Prepwyzr
//
//  Created by rlogical-dev-11 on 15/08/18.
//  Copyright © 2018 Mitul Mandanka. All rights reserved.
//

import UIKit

class CellTable_HomeCourse: UITableViewCell {

    //MARK: IBOutlets
    @IBOutlet var lbl_CourseName: UILabel!
    @IBOutlet var lbl_CoursePercentage: UILabel!
    
    @IBOutlet var progressViewForCourse: RadialProgressView!
    
    
    //MARK: UITableViewCell Related Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.progressViewForCourse.showPercentage = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
