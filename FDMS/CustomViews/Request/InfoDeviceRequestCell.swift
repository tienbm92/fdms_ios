//
//  InfoDeviceRequestCell.swift
//  FDMS
//
//  Created by Bui Minh Tien on 4/13/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

class InfoDeviceRequestCell: UITableViewCell {
    
    @IBOutlet weak private var devicesNumberLabel: UILabel!
    @IBOutlet weak private var descriptionLabel: UILabel!
    @IBOutlet weak private var deviceCategoryLabel: UILabel!
    @IBOutlet weak private var numberLabel: UILabel!
    
    func setValue(deviceValue: DevicesForRequest, countDevice: Int) {
        valueForCell(deviceValue: deviceValue, countDevice: countDevice)
    }
    
    private func valueForCell(deviceValue: DevicesForRequest?, countDevice: Int?) {
        self.devicesNumberLabel.text = "\(deviceValue?.number ?? 0)"
        self.descriptionLabel.text = deviceValue?.description
        self.deviceCategoryLabel.text = deviceValue?.categoryName
        self.numberLabel.text = "\(countDevice ?? 0)"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        valueForCell(deviceValue: nil, countDevice: nil)
    }
    
}
