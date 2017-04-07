//
//  DeviceInfoVC.swift
//  FDMS
//
//  Created by Huy Pham on 4/12/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

class DeviceInfoVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table View Delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 || indexPath.section == 2 {
            return false
        }
        return true
    }

}
