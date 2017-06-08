//
//  InfoDeviceRequestCell.swift
//  FDMS
//
//  Created by Bui Minh Tien on 4/13/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

class InfoDeviceRequestCell: UITableViewCell {
    
    @IBOutlet weak private var descriptionLabel: UILabel!
    @IBOutlet weak private var deviceCategoryLabel: UILabel!
    @IBOutlet weak private var numberLabel: UILabel!
    @IBOutlet weak private var lineView: UIView!
    
    func setValue(deviceValue: DevicesForRequest, lineViewHidden: Bool) {
        valueForCell(deviceValue: deviceValue)
        if lineViewHidden {
            self.lineView.isHidden = true
        } else {
            self.lineView.isHidden = false
        }
    }
    
    private func valueForCell(deviceValue: DevicesForRequest?) {
        self.descriptionLabel.text = deviceValue?.description
        self.deviceCategoryLabel.text = deviceValue?.categoryName
        self.numberLabel.text = "\(deviceValue?.number ?? 0)"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        valueForCell(deviceValue: nil)
    }
    
}
