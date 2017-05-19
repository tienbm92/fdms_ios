//
//  InfoDeviceTableVC.swift
//  FDMS
//
//  Created by Bui Minh Tien on 4/14/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

class InfoDeviceTableVC: UITableViewController {
    
    fileprivate var devices: [DevicesForRequest]?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "InfoDeviceRequestCell", bundle: nil),
                                forCellReuseIdentifier: infoDeviceRequestCell)
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func setValue(devices: [DevicesForRequest]) {
        self.devices = devices
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.devices?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellInfoDevice = tableView.dequeueReusableCell(withIdentifier: infoDeviceRequestCell, for: indexPath)
            as? InfoDeviceRequestCell, let devices = self.devices else {
            return UITableViewCell()
        }
        if devices.count < 2 {
            cellInfoDevice.setValue(deviceValue: devices[indexPath.row], countDevice: indexPath.row,
                                    lineViewHidden: true)
        } else {
            cellInfoDevice.setValue(deviceValue: devices[indexPath.row], countDevice: indexPath.row,
                                    lineViewHidden: false)
        }
        return cellInfoDevice
    }

}
