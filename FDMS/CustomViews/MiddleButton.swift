//
//  MiddleButton.swift
//  FDMS
//
//  Created by Nguyen Quoc Tinh on 4/3/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

class MiddleButton: UIView {
    
    @IBOutlet weak private var middleButton: UIButton!
    @IBOutlet weak private var middleButtonLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        middleButton.frame.size = CGSize(width: 50, height: 50)
        middleButton.layer.cornerRadius = 10
    }
    
    func addTarget(_ target: Any?, action: Selector, for event: UIControlEvents) {
        self.middleButton.addTarget(target, action: action, for: event)
    }
    
}
