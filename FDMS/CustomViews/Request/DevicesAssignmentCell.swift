//
//  DevicesAssignmentCell.swift
//  FDMS
//
//  Created by Bùi Minh Tiến on 5/29/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit
import SDWebImage

class DevicesAssignmentCell: UITableViewCell {
    
    @IBOutlet private weak var imageDevice: UIImageView!
    @IBOutlet private weak var productName: UILabel!
    @IBOutlet private weak var deviceCategory: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setValueForCell(imageUrl: String?, productName: String, deviceCategory: String) {
        if let imageUrl = imageUrl {
            let url = URL(string: kBaseURL + imageUrl)
            self.imageDevice.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "img_placeholder"))
        } else {
            self.imageDevice.image = #imageLiteral(resourceName: "img_placeholder")
        }
        self.productName.text = productName
        self.deviceCategory.text = deviceCategory
    }
    
}
