//
//  TopRequestCell.swift
//  FDMS
//
//  Created by Bùi Minh Tiến on 6/5/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

class TopRequestCell: UITableViewCell {

    @IBOutlet private weak var timeAgoLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var requestForLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    fileprivate var request: Request?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupContentCell()
    }
    
    func setValueForCell(_ request: Request) {
        self.request = request
        self.setupContentCell()
    }
    
    private func setupContentCell() {
        self.titleLabel.text = self.request?.title
        self.statusLabel.text = self.request?.requestStatus
        self.requestForLabel.text = self.request?.requestFor
        if let dateString = self.request?.createAt?.toDateString(),
            let timeString = self.request?.createAt?.timeToString() {
            self.timeAgoLabel.text = dateString + "\n" + timeString
        } else {
            self.timeAgoLabel.text = ""
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.request = nil
        self.setupContentCell()
    }

}
