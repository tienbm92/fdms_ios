//
//  DeviceRequestCell.swift
//  FDMS
//
//  Created by Bui Minh Tien on 4/10/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

class DeviceRequestCell: UITableViewCell {

    @IBOutlet weak private var descriptionLabel: UILabel!
    @IBOutlet weak private var deviceCategory: UILabel!
    @IBOutlet weak private var numberLabel: UILabel!
    
    func setValueForCell(device: DevicesForRequest?) {
        valueForCell(with: device)
    }
    
    private func valueForCell(with device: DevicesForRequest?) {
        self.descriptionLabel.text = device?.description
        self.deviceCategory.text = device?.categoryName
        self.numberLabel.text = "\(device?.number ?? 0)"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        valueForCell(with: nil)
    }
    
}
