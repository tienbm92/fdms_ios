//
//  RequestDetailVC.swift
//  FDMS
//
//  Created by Bui Minh Tien on 4/7/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

class RequestDetailVC: UIViewController {
    
    fileprivate let titleRequestArray: [String] = ["Description", "Title", "Request status",
                                       "Request for", "Create by", "Updated by"]
    fileprivate var request: Request?
    fileprivate let titleButtonArray: [String] = ["Accept", "Cancel", "Edit"]
    @IBOutlet weak fileprivate var listRequestTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.listRequestTableView.register(UINib(nibName: "ButtonCell", bundle: nil),
                                           forCellReuseIdentifier: buttonCellId)
        self.listRequestTableView.estimatedRowHeight = 50
        self.listRequestTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
    }
    
}

extension RequestDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Request Info"
        } else if section == 1 {
            return "Devices"
        }
        return nil
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 6
        case 1:
            return 2
        case 2:
            return 3
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellReturn = UITableViewCell()
        if indexPath.section == 0 {
            let infoRequestCell = tableView.dequeueReusableCell(withIdentifier: "InfoRequestCell", for: indexPath)
            infoRequestCell.textLabel?.text = self.titleRequestArray[indexPath.row]
            infoRequestCell.detailTextLabel?.text = self.titleRequestArray[indexPath.row]
            cellReturn = infoRequestCell
        } else if indexPath.section == 1 {
            guard let infoDeviceCell = tableView.dequeueReusableCell(withIdentifier: "DeviceRequestCell",
                                                                     for: indexPath) as? DeviceRequestCell
                else {
                    return UITableViewCell()
            }
            cellReturn = infoDeviceCell
        } else if indexPath.section == 2 {
            guard let buttonCell = tableView.dequeueReusableCell(
                withIdentifier: buttonCellId, for: indexPath) as? ButtonCell else {
                    return UITableViewCell()
            }
            buttonCell.setTextLable(titleButtonArray[indexPath.row], color: #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1))
            cellReturn = buttonCell
        }
        return cellReturn
    }
    
}
