//
//  DeviceHistoryCell.swift
//  FDMS
//
//  Created by Bùi Minh Tiến on 6/9/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

class DeviceHistoryCell: UITableViewCell {

    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
