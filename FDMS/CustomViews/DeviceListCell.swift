//
//  DeviceListCell.swift
//  FDMS
//
//  Created by Nguyen Quoc Tinh on 4/25/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import SDWebImage
import UIKit

class DeviceListCell: UITableViewCell {

    @IBOutlet private weak var deviceImage: UIImageView!
    @IBOutlet private weak var deviceNameLabel: UILabel!
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    var device: Device?
    
    func setData() {
        guard let device = device else {
            return
        }
        deviceNameLabel.text = device.productionName
        categoryLabel.text = device.deviceCategoryName
        statusLabel.text = device.deviceStatusName
        deviceImage.sd_setImage(with: device.getImageURL(), placeholderImage: #imageLiteral(resourceName: "img_placeholder"))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        deviceImage.image = nil
        deviceNameLabel.text = nil
        categoryLabel.text = nil
        statusLabel.text = nil
    }

}
