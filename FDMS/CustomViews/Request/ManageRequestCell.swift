//
//  ManageRequestCell.swift
//  FDMS
//
//  Created by Bùi Minh Tiến on 5/19/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

class ManageRequestCell: UITableViewCell {
    @IBOutlet weak private var dateTimeLabel: UILabel!
    @IBOutlet weak private var requestForLabel: UILabel!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var statusLabel: UILabel!
    private var dateTimeLabelText: String?
    
    func setValueForCell(request: Request) {
        if let createAtDate = request.createAt?.toDateString(),
            let createAtTime = request.createAt?.timeToString() {
            self.dateTimeLabelText = createAtDate + "\n" + createAtTime
        }
        valueForCell(dateTimeLabel: dateTimeLabelText, request: request)
    }
    
    private func valueForCell(dateTimeLabel: String?, request: Request?) {
        self.dateTimeLabel.text = dateTimeLabel
        self.requestForLabel.text = request?.requestFor
        self.statusLabel.text = request?.requestStatus
        self.titleLabel.text = request?.title
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        valueForCell(dateTimeLabel: nil, request: nil)
    }
    
}
