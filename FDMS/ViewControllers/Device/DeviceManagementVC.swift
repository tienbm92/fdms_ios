//
//  DeviceManagementVC.swift
//  FDMS
//
//  Created by Nguyen Quoc Tinh on 4/4/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

class DeviceManagementVC: UIViewController {
    
    @IBOutlet fileprivate weak var filterView: UIView!
    @IBOutlet fileprivate weak var filterTableView: UITableView!
    @IBOutlet fileprivate weak var deviceTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension DeviceManagementVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // For Prototype Only
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // For Prototype Only
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle,
                   forRowAt indexPath: IndexPath) {
    }
    
}

extension DeviceManagementVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "DeviceListToDetail", sender: nil)
    }
    
}
