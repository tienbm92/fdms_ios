//
//  ButtonCell.swift
//  FDMS
//
//  Created by Bui Minh Tien on 4/10/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

class ButtonCell: UITableViewCell {

    @IBOutlet weak private var actionText: UILabel!
    func setTextLable(_ value: String, color: UIColor) {
        self.actionText.text = value
        self.actionText.textColor = color
    }
    
}
