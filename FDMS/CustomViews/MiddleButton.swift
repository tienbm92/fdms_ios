//
//  MiddleButton.swift
//  FDMS
//
//  Created by Nguyen Quoc Tinh on 4/3/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

class MiddleButton: UIView {
    
    @IBOutlet weak var middleButton: UIButton!
    @IBOutlet weak var middleButtonLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        middleButton.frame.size = CGSize(width: 50, height: 50)
        middleButton.layer.cornerRadius = 10
    }
    
}
