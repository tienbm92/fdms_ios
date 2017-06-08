//
//  ListTopDevicesCell.swift
//  FDMS
//
//  Created by Bùi Minh Tiến on 6/6/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

class ListTopDevicesCell: UITableViewCell {
    
    @IBOutlet fileprivate weak var myTableView: UITableView!
    fileprivate var topDevices: [TopDevice] = [TopDevice]()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.myTableView.dataSource = self
        self.myTableView.delegate = self
        self.myTableView.register(UINib(nibName: kTopDeviceCell, bundle: nil),
                                  forCellReuseIdentifier: kTopDeviceCell)
    }
    
    func setValueForCell(_ topDevices: [TopDevice]) {
        self.topDevices = topDevices
        self.myTableView.reloadData()
    }
    
}

extension ListTopDevicesCell: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.topDevices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let topDeviceCell = tableView.dequeueReusableCell(withIdentifier: kTopDeviceCell, for: indexPath)
            as? TopDeviceCell, !self.topDevices.isEmpty else {
            return UITableViewCell()
        }
        topDeviceCell.setValueForCell(self.topDevices[indexPath.row])
        return topDeviceCell
    }
    
}

extension ListTopDevicesCell: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}
