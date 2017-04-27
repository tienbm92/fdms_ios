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
    fileprivate var requests: [Request] = [Request]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getListRequest(userID: 11, statusId: nil, relativeId: nil)
    }
    
    @IBAction func relativeToButton(_ sender: UIButton) {
        guard let textButton = self.relativeButton.titleLabel?.text,
            let listUserRelative = self.getListUserRelative() else {
            return
        }
        self.pushSearchViewController(title: textButton, listUserRelative: listUserRelative, otherObject: nil)
    }
    
    @IBAction func requestStatusButton(_ sender: UIButton) {
        guard let textButton = self.statusButton.titleLabel?.text,
            let listStatus = self.getListStatus() else {
            return
        }
        self.pushSearchViewController(title: textButton, listUserRelative: nil, otherObject: listStatus)
    }
    
    func pushSearchViewController(title textTitle: String, listUserRelative: [User]?, otherObject: [OtherObject]?) {
        guard let searchViewController = storyboard?.instantiateViewController(withIdentifier:
            String(describing: InfoSearchTableVC.self)) as? InfoSearchTableVC else {
            return
        }
        if let listUserRelative = listUserRelative {
            searchViewController.setProperty(input: listUserRelative)
        } else if let otherObject = otherObject {
            searchViewController.setProperty(input: otherObject)
        }
        searchViewController.title = textTitle
        self.navigationController?.pushViewController(searchViewController, animated: true)
    }
    
    fileprivate func getListRequest(userID: Int, statusId: Int?, relativeId: Int?, perPage: Int = 10, page: Int = 1) {
        let page = Page(page: page, perPage: perPage)
        RequestService.share.getListRequest(UserID: userID, RequestStatusId: statusId,
                                            RelativeID: relativeId, Page: page) { [weak self] (requestResult) in
            switch requestResult {
            case let .success(requests):
                self?.requests = requests
            case let .failure(error):
                self?.requests.removeAll()
                WindowManager.shared.showMessage(message: error.localizedDescription, title: nil, completion: nil)
            }
            self?.listRequestTableView.reloadData()
        }
    }
    
    fileprivate func getListUserRelative() -> [User]? {
        guard let listUserRelative = self.filter as? [User] else {
            return nil
        }
        return listUserRelative
    }
    
    fileprivate func getListStatus() -> [OtherObject]? {
        var listStatus = [OtherObject]()
        DeviceService.share.getOtherObject(OptionGet: .getRquestStatus) { (result) in
            switch result {
            case let .success(listStatusResult):
                listStatus = listStatusResult
            case let .failure(error):
                WindowManager.shared.showMessage(message: error.localizedDescription, title: nil, completion: nil)
            }
        }
        if listStatus.isEmpty {
            return nil
        } else {
            return listStatus
        }
    }
    
}

extension ManageRequestVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.requests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoRequestCell", for: indexPath)
        cell.textLabel?.text = self.requests[indexPath.row].title
        cell.detailTextLabel?.text = self.requests[indexPath.row].description
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
            if let filterStatus = filter as? OtherObject {
                self.statusButton.titleLabel?.text = filterStatus.name
            }
        default:
            return
        }
    }
    
}
