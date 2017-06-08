//
//  DeviceUsingCell.swift
//  FDMS
//
//  Created by Bùi Minh Tiến on 6/9/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

class DeviceUsingCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var fromDateLabel: UILabel!
    @IBOutlet weak var dateNowLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
