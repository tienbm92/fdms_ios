//
//  InfoSearchTableVC.swift
//  FDMS
//
//  Created by Bui Minh Tien on 4/14/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

protocol InfoSearchRequestDelegate: class {
    func searchRequestVC(_ searchViewController: InfoSearchRequestVC, didCloseWith filter: OtherObject?,
                         optionSearch: OptionSearch)
}

enum OptionSearch {
    case requestStatus
    case relative
    case assignee
    case actionRequest
    case deviceStatus
    case deviceCategory
}

class InfoSearchRequestVC: UITableViewController {
    
    weak var delegate: InfoSearchRequestDelegate?
    fileprivate var searchDataInput: [OtherObject] = [OtherObject]()
    fileprivate var searchDataResult: [OtherObject] = [OtherObject]()
    fileprivate var optionSearch: OptionSearch = .requestStatus
    fileprivate let searchController: UISearchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.loadViewIfNeeded()
        definesPresentationContext = true
        self.tableView.tableHeaderView = searchController.searchBar
    }
    
    func setProperty(searchDataInput: [OtherObject], optionSearch: OptionSearch) {
        self.searchDataInput = searchDataInput
        self.optionSearch = optionSearch
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let isSearch = searchController.isActive && searchController.searchBar.text != ""
        return isSearch ? searchDataResult.count : searchDataInput.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoSearchCell", for: indexPath)
        let isSearch = searchController.isActive && searchController.searchBar.text != ""
        cell.textLabel?.text = isSearch ? searchDataResult[indexPath.row].name : searchDataInput[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchDataResult.isEmpty {
            self.delegate?.searchRequestVC(self, didCloseWith: searchDataInput[indexPath.row],
                                           optionSearch: optionSearch)
        } else {
            self.delegate?.searchRequestVC(self, didCloseWith: searchDataResult[indexPath.row],
                                           optionSearch: optionSearch)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    fileprivate func filterContentForSearchText(searchText: String) {
        self.searchDataResult = self.searchDataInput.filter({ (other) -> Bool in
            return other.name.lowercased().contains(searchText.lowercased())
        })
        self.tableView.reloadData()
    }

}

extension InfoSearchRequestVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            return
        }
        self.filterContentForSearchText(searchText: searchText)
    }
    
}
