//
//  InfoDeviceTableVC.swift
//  FDMS
//
//  Created by Bui Minh Tien on 4/14/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

class InfoDeviceTableVC: UITableViewController {
    
    var countDevices: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "InfoDeviceRequestCell", bundle: nil),
                                forCellReuseIdentifier: infoDeviceRequestCell)
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.countDevices
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellInfoDevice = tableView.dequeueReusableCell(withIdentifier: infoDeviceRequestCell, for: indexPath)
            as? InfoDeviceRequestCell else {
            return UITableViewCell()
        }
        return cellInfoDevice
    }

}
