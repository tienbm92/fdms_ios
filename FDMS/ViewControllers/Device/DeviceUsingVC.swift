//
//  DeviceUsingVC.swift
//  FDMS
//
//  Created by Huy Pham on 4/12/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

class DeviceUsingVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = indexPath.row == 0 ? kDeviceUsingTitleCell : kDeviceUsingCell
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        return cell
    }

}
