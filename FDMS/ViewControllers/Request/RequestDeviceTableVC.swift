//
//  RequestDeviceTableVC.swift
//  FDMS
//
//  Created by Bùi Minh Tiến on 5/31/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

class RequestDeviceTableVC: UITableViewController {

    fileprivate var devices: [DevicesForRequest]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCellClass()
    }
    
    fileprivate func registerCellClass() {
        self.tableView.register(UINib.init(nibName: kInfoDeviceRequestCell, bundle: nil),
                                       forCellReuseIdentifier: kInfoDeviceRequestCell)
    }
    
    func setValue(devices: [DevicesForRequest]?) {
        self.devices = devices
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.devices?.count ?? 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

}
