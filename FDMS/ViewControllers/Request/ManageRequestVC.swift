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
        self.listRequestTableView.register(UINib(nibName: "RequestManageCell", bundle: nil),
                                           forCellReuseIdentifier: kRequestManageCell)
    }
    
    @IBAction func relativeToButton(_ sender: UIButton) {
        guard let textButton = self.relativeButton.titleLabel?.text,
            let listUserRelative = self.getListUserRelative() else {
            return
        }
        self.pushSearchViewController(title: textButton, otherObject: listUserRelative, optionSearch: .relative)
    }
        
    @IBAction func requestStatusButton(_ sender: UIButton) {
        guard let textButton = self.statusButton.titleLabel?.text,
            let listStatus = self.getListStatus() else {
            return
        }
        self.pushSearchViewController(title: textButton, otherObject: listStatus, optionSearch: .requestStatus)
    }
    
    func pushSearchViewController(title textTitle: String, otherObject: [OtherObject], optionSearch: OptionSearch) {
        guard let searchViewController = storyboard?.instantiateViewController(withIdentifier:
            String(describing: InfoSearchTableVC.self)) as? InfoSearchRequestVC else {
            return
        }
        searchViewController.setProperty(searchDataInput: otherObject, optionSearch: optionSearch)
        searchViewController.title = textTitle
        self.navigationController?.pushViewController(searchViewController, animated: true)
    }
    
    fileprivate func pushRequestDetailVC(index: Int) {
        guard let requestDetailVC = storyboard?.instantiateViewController(withIdentifier:
            String(describing: RequestDetailVC.self)) as? RequestDetailVC else {
            return
        }
        requestDetailVC.setValue(self.requests[index])
        self.navigationController?.pushViewController(requestDetailVC, animated: true)
    }
    
    fileprivate func getListRequest(userID: Int, statusId: Int?, relativeId: Int?, perPage: Int = 10, page: Int = 1) {
        let page = Page(page: page, perPage: perPage)
        RequestService.share.getListRequests(UserID: userID, RequestStatusId: statusId,
                                            RelativeID: relativeId, Page: page) { [weak self] (requestResult) in
            switch requestResult {
            case let .success(requests):
                if let requests = requests as? [Request] {
                    self?.requests = requests
                }
            case let .failure(error):
                self?.requests.removeAll()
                WindowManager.shared.showMessage(message: error.localizedDescription, title: nil, completion: nil)
            }
            self?.listRequestTableView.reloadData()
        }
    }
    
    fileprivate func getListUserRelative() -> [OtherObject]? {
        var listUserRelative = [OtherObject]()
        WindowManager.shared.showProgressView()
        DeviceService.shared.getOtherObject(OptionGet: .getRelativeTo) { (result) in
            WindowManager.shared.hideProgressView()
            switch result {
            case let .success(listRelativeResult):
                if let listRelativeResult = listRelativeResult as? [OtherObject] {
                    listUserRelative = listRelativeResult
                }
            case let .failure(error):
                WindowManager.shared.showMessage(message: error.localizedDescription, title: nil, completion: nil)
            }
        }
        if listUserRelative.isEmpty {
            return nil
        } else {
            return listUserRelative
        }
    }
    
    fileprivate func getListStatus() -> [OtherObject]? {
        var listStatus = [OtherObject]()
        WindowManager.shared.showProgressView()
        DeviceService.shared.getOtherObject(OptionGet: .getRquestStatus) { (result) in
            WindowManager.shared.hideProgressView()
            switch result {
            case let .success(listStatusResult):
                if let listStatusResult = listStatusResult as? [OtherObject] {
                    listStatus = listStatusResult
                }
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: kRequestManageCell,
                                                       for: indexPath) as? RequestManageCell else {
            return UITableViewCell()
        }
        cell.setValueForCell(request: requests[indexPath.row])
        return cell
    }
    
}

extension ManageRequestVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.pushRequestDetailVC(index: indexPath.row)
    }
    
}

extension ManageRequestVC: InfoSearchRequestDelegate {
    
    func searchRequestVC(_ searchViewController: InfoSearchRequestVC, didCloseWith filter: OtherObject?,
                         optionSearch: OptionSearch) {
        switch optionSearch {
        case .requestStatus:
            self.statusButton.titleLabel?.text = filter?.name
        case .relative:
            self.relativeButton.titleLabel?.text = filter?.name
        default:
            break
        }
    }
    
}
