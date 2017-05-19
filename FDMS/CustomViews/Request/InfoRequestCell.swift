//
//  InfoRequestCell.swift
//  FDMS
//
//  Created by Bui Minh Tien on 4/27/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

class InfoRequestCell: UITableViewCell {

    @IBOutlet weak private var descriptionLabel: UILabel!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var statusLabel: UILabel!
    @IBOutlet weak private var requestForLabel: UILabel!
    @IBOutlet weak private var updateByLabel: UILabel!
    @IBOutlet weak private var createByLabel: UILabel!
    
    func setValueForCell(request: Request) {
        let infoRequest = InfoRequest(descriptionLabel: request.description, titleLabel: request.title,
                                      statusLabel: request.requestStatus, requestForLabel: request.requestFor,
                                      updateByLabel: request.updater, createByLabel: request.creater)
        valueForCell(infoRequest: infoRequest)
    }
    
    private func valueForCell(infoRequest: InfoRequest) {
        self.descriptionLabel.text = infoRequest.descriptionLabel
        self.titleLabel.text = infoRequest.titleLabel
        self.statusLabel.text = infoRequest.statusLabel
        self.requestForLabel.text = infoRequest.requestForLabel
        self.updateByLabel.text = infoRequest.updateByLabel
        self.createByLabel.text = infoRequest.createByLabel
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        let infoRequest = InfoRequest(descriptionLabel: nil, titleLabel: nil, statusLabel: nil,
                                      requestForLabel: nil, updateByLabel: nil, createByLabel: nil)
        valueForCell(infoRequest: infoRequest)
    }
    
}
