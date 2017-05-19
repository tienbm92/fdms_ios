//
//  DeviceInfoVC.swift
//  FDMS
//
//  Created by Huy Pham on 4/12/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import SDWebImage
import UIKit

class DeviceInfoVC: UITableViewController {

    @IBOutlet private weak var deviceImage: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var deviceCodeLabel: UILabel!
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var createdByLabel: UILabel!
    @IBOutlet private weak var modelNumberLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    var device: Device = Device()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInfo()
    }
    
    func setupInfo() {
        nameLabel.text = device.productionName
        deviceCodeLabel.text = device.deviceCode
        categoryLabel.text = device.deviceCategoryName
        statusLabel.text = device.deviceStatusName
        modelNumberLabel.text = device.modelNumber
        priceLabel.text = String(device.originalPrice)
        dateLabel.text = device.boughtDate?.toDateString()
        print(device.boughtDate?.toDateString())
        print(device.boughtDate)
        deviceImage.sd_setImage(with: device.getImageURL(), placeholderImage: #imageLiteral(resourceName: "img_placeholder"))
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditDevice" {
            guard let destination = segue.destination as? DeviceCustomizationVC else {
                return
            }
            destination.type = .edit
            destination.device = self.device
        } 
    }
    
}
