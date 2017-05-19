//
//  EditRequestTableVC.swift
//  FDMS
//
//  Created by Bui Minh Tien on 4/17/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

class EditRequestTableVC: UITableViewController {

    @IBOutlet weak private var requestFor: UILabel!
    @IBOutlet weak private var descriptionLabel: UILabel!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet fileprivate weak var lineView: UIView!
    private var request: Request? {
        didSet {
            self.requestFor.text = request?.requestFor
            self.descriptionLabel.text = request?.description
            self.titleLabel.text = request?.title
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lineView.isHidden = true
    }
    
    @IBAction func addDevice(_ sender: UIButton) {
        if let infoDeviceVC = self.childViewControllers[0] as? InfoDeviceTableVC {
            self.lineView.isHidden = false
            infoDeviceVC.countDevices += 1
            infoDeviceVC.tableView.reloadData()
        }
    }
    
    func setValue(request: Request) {
        self.request = request
    }

}
