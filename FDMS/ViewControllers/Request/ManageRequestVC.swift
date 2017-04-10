//
//  ManageRequestVC.swift
//  FDMS
//
//  Created by Bui Minh Tien on 4/12/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

class ManageRequestVC: UIViewController {

    @IBOutlet fileprivate weak var statusButton: UIButton!
    @IBOutlet fileprivate weak var relativeButton: UIButton!
    @IBOutlet weak private var listRequestTableView: UITableView!
    fileprivate var filter: [AnyObject] = [AnyObject]()
    fileprivate var request: [Request] = [Request]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func relativeToButton(_ sender: UIButton) {
        guard let textButton = self.relativeButton.titleLabel?.text,
            let listUserRelative = self.getListUserRelative() else {
            return
        }
        self.pushSearchViewController(title: textButton, listUserRelative: listUserRelative, listStatus: nil)
    }
    
    @IBAction func requestStatusButton(_ sender: UIButton) {
        guard let textButton = self.statusButton.titleLabel?.text,
            let listStatus = self.getListStatus() else {
            return
        }
        self.pushSearchViewController(title: textButton, listUserRelative: nil, listStatus: listStatus)
    }
    
    func pushSearchViewController(title textTitle: String, listUserRelative: [User]?, listStatus: [RequestStatus]?) {
        guard let searchViewController = storyboard?.instantiateViewController(withIdentifier:
            String(describing: InfoSearchTableVC.self)) as? InfoSearchTableVC else {
            return
        }
        if let listUserRelative = listUserRelative {
            searchViewController.setProperty(input: listUserRelative)
        } else if let listStatus = listStatus {
            searchViewController.setProperty(input: listStatus)
        }
        searchViewController.title = textTitle
        self.navigationController?.pushViewController(searchViewController, animated: true)
    }
    
    fileprivate func getListRequest() {
        
    }
    
    fileprivate func getListUserRelative() -> [User]? {
        guard let listUserRelative = self.filter as? [User] else {
            return nil
        }
        return listUserRelative
    }
    
    fileprivate func getListStatus() -> [RequestStatus]? {
        guard let listStatus = self.filter as? [RequestStatus] else {
            return nil
        }
        return listStatus
    }
    
}

extension ManageRequestVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoRequestCell", for: indexPath)
        cell.textLabel?.text = "12asdz"
        cell.detailTextLabel?.text = "sazza12343"
        return cell
    }
    
}

extension ManageRequestVC: InfoSearchVCDelegate {
    
    func searchViewController(_ searchViewController: InfoSearchTableVC, didCloseWith filter: AnyObject?,
                              resultOption option: OptionFilter) {
        switch option {
        case .user:
            if let filterUser = filter as? User {
                self.relativeButton.titleLabel?.text = filterUser.name
            }
        case .requestStatus:
            if let filterStatus = filter as? RequestStatus {
                self.statusButton.titleLabel?.text = filterStatus.name
            }
        default:
            return
        }
    }
    
}
