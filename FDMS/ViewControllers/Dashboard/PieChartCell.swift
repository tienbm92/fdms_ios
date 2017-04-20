//
//  PieChartCell.swift
//  FDMS
//
//  Created by Nguyen Quoc Tinh on 4/18/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import Charts
import UIKit

class PieChartCell: UITableViewCell {

    @IBOutlet private weak var pieChartView: PieChartView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
