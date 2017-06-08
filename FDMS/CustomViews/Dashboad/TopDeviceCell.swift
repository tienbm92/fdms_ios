//
//  TopDeviceCell.swift
//  FDMS
//
//  Created by Bùi Minh Tiến on 6/5/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

class TopDeviceCell: UITableViewCell {

    @IBOutlet private weak var summaryLabel: UILabel!
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setValueForCell(_ topDevice: TopDevice?) {
        setupValueForCell(topDevice: topDevice)
    }
    
    private func setupValueForCell(topDevice: TopDevice?) {
        self.categoryLabel.text = topDevice?.name
        self.statusLabel.text = "\(topDevice?.status ?? 0)" + "% Using"
        self.summaryLabel.text = "(assignment: \(topDevice?.summary?.assignment ?? 0)," +
        " available \(topDevice?.summary?.available ?? 0), total \(topDevice?.summary?.total ?? 0))"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setupValueForCell(topDevice: nil)
    }

}
