//
//  NewRequestTableVC.swift
//  FDMS
//
//  Created by Bui Minh Tien on 4/14/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

class NewRequestTableVC: UITableViewController {

    @IBOutlet fileprivate weak var requestButton: UIButton!
    @IBOutlet fileprivate weak var assignButton: UIButton!
    @IBOutlet fileprivate weak var lineView: UIView!
    fileprivate let manageRequest: ManageRequestVC = ManageRequestVC()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lineView.isHidden = true
    }

    @IBAction func addDevice(_ sender: UIButton) {
        if let infoDeviceVC = self.childViewControllers[0] as? InfoDeviceTableVC {
            self.lineView.isHidden = false
//            infoDeviceVC.countDevices += 1
            infoDeviceVC.tableView.reloadData()
        }
    }
    @IBAction func addRequestFor(_ sender: UIButton) {
//        guard let textButton = self.requestButton.titleLabel?.text else {
//            return
//        }
//        self.manageRequest.pushSearchViewController(title: textButton)
    }
    
    @IBAction func backFromAddDevice(_ segue: UIStoryboardSegue) {
        
    }

    @IBAction func addAssign(_ sender: UIButton) {
//        guard let textButton = self.assignButton.titleLabel?.text else {
//            return
//        }
//        self.manageRequest.pushSearchViewController(title: textButton)
    }

}
