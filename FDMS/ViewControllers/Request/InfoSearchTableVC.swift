//
//  InfoSearchTableVC.swift
//  FDMS
//
//  Created by Bui Minh Tien on 4/14/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

protocol InfoSearchVCDelegate: class {
    func searchViewController(_ searchViewController: InfoSearchTableVC, didCloseWith filter: AnyObject?,
                              resultOption option: OptionFilter)
}

enum OptionFilter {
    case categoriesDevices
    case requestStatus
    case user
}

class InfoSearchTableVC: UITableViewController {
    
    fileprivate var filter: [AnyObject] = [AnyObject]()
    fileprivate weak var delegate: InfoSearchVCDelegate?
    fileprivate lazy var searchResultUser: [User] = [User]()
    fileprivate lazy var searchResultDevices: [ManagerValue] = [ManagerValue]()
    fileprivate lazy var searchResultStatus: [ManagerValue] = [ManagerValue]()
    fileprivate lazy var filterUser: [User] = [User]()
    fileprivate lazy var filterDevices: [ManagerValue] = [ManagerValue]()
    fileprivate lazy var filterStatus: [ManagerValue] = [ManagerValue]()
    fileprivate var optionResult: OptionFilter = .user
    fileprivate let searchController: UISearchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkTitleVC()
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = true
        searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        self.tableView.tableHeaderView = searchController.searchBar
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            switch optionResult {
            case .user:
                return self.searchResultUser.count
            case .categoriesDevices:
                return self.searchResultDevices.count
            case .requestStatus:
                return self.searchResultStatus.count
            }
        }
        return filter.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoSearchCell", for: indexPath)
        if searchController.isActive && searchController.searchBar.text != "" {
            switch optionResult {
            case .user:
                cell.textLabel?.text = searchResultUser[indexPath.row].name
            case .categoriesDevices:
                cell.textLabel?.text = searchResultDevices[indexPath.row].name
            case .requestStatus:
                cell.textLabel?.text = searchResultStatus[indexPath.row].name
            }
        } else {
            switch optionResult {
            case .user:
                cell.textLabel?.text = filterUser[indexPath.row].name
            case .categoriesDevices:
                cell.textLabel?.text = filterDevices[indexPath.row].name
            case .requestStatus:
                cell.textLabel?.text = filterStatus[indexPath.row].name
            }
        }
            return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.searchViewController(self, didCloseWith: filter[indexPath.row], resultOption: optionResult)
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func setProperty(input filter: [AnyObject]) {
        self.filter = filter
    }
    
    fileprivate func checkTitleVC() {
        if self.title == "Relative" || self.title == "Request For" || self.title == "Assign To" {
            if let filter = self.filter as? [User] {
                self.filterUser = filter
            }
        } else if self.title == "Device Category" {
            if let filter = self.filter as? [ManagerValue] {
                self.filterDevices = filter
                self.optionResult = .categoriesDevices
            }
        } else if self.title == "Status" {
            if let filter = self.filter as? [ManagerValue] {
                self.filterStatus = filter
                self.optionResult = .requestStatus
            }
        }
    }
    
    fileprivate func filterContentForSearchText(searchText: String, searchOption: OptionFilter) {
        switch searchOption {
        case .user:
            self.searchResultUser = self.filterUser.filter({ (user) -> Bool in
                if user.name.lowercased().contains(searchText.lowercased()) {
                    return true
                }
                return false
            })
        case .categoriesDevices:
            self.searchResultDevices = self.filterDevices.filter({ (device) -> Bool in
                if device.name.lowercased().contains(searchText.lowercased()) {
                    return true
                }
                return false
            })
        case .requestStatus:
            self.searchResultStatus = self.filterStatus.filter({ (status) -> Bool in
                if status.name.lowercased().contains(searchText.lowercased()) {
                    return true
                }
                return false
            })
        }
        self.tableView.reloadData()
    }

}

extension InfoSearchTableVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            return
        }
        self.filterContentForSearchText(searchText: searchText, searchOption: optionResult)
    }
    
}
