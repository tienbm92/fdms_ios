//
//  DevicesRequestCell.swift
//  FDMS
//
//  Created by Bùi Minh Tiến on 5/28/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

class DevicesRequestCell: UITableViewCell {
    
    @IBOutlet fileprivate weak var devicesTableView: UITableView!
    fileprivate var devices: [DevicesForRequest]?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.devicesTableView.delegate = self
        self.devicesTableView.dataSource = self
        registerCellClass()
    }
    
    fileprivate func registerCellClass() {
        self.devicesTableView.register(UINib(nibName: kInfoDeviceRequestCell, bundle: nil),
                                       forCellReuseIdentifier: kInfoDeviceRequestCell)
    }
    
    func setValue(devices: [DevicesForRequest]?) {
        self.devices = devices
        self.devicesTableView.reloadData()
    }

}

extension DevicesRequestCell: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.devices?.count ?? 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellInfoDevice = tableView.dequeueReusableCell(withIdentifier: kInfoDeviceRequestCell, for: indexPath)
            as? InfoDeviceRequestCell, let devices = self.devices else {
                return UITableViewCell()
        }
        if devices.count < 2 {
            cellInfoDevice.setValue(deviceValue: devices[indexPath.row], lineViewHidden: true)
        } else {
            cellInfoDevice.setValue(deviceValue: devices[indexPath.row], lineViewHidden: false)
        }
        return cellInfoDevice

    }
    
}

extension DevicesRequestCell: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}
