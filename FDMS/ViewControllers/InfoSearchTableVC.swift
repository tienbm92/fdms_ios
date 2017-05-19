//
//  InfoSearchTableVC.swift
//  FDMS
//
//  Created by Bui Minh Tien on 4/14/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

protocol InfoSearchDelegate: class {
    func searchViewController(_ searchViewController: InfoSearchTableVC, didCloseWith filter: AnyObject?,
                              resultOption option: OptionSearch)
}

class InfoSearchTableVC: UITableViewController {
    
    var inputData: [FilterInfo] = [FilterInfo]()
    fileprivate var filterResult: [FilterInfo] = [FilterInfo]()
    fileprivate weak var delegate: InfoSearchDelegate?
    fileprivate let searchController: UISearchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let hasSearch = searchController.isActive && searchController.searchBar.text != ""
        return hasSearch ? filterResult.count : inputData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "InfoSearchCell",
                                                       for: indexPath) as? SearchCell else {
            return UITableViewCell()
        }
        let hasSearch = searchController.isActive && searchController.searchBar.text != ""
        cell.filterResult = hasSearch ? filterResult[indexPath.row] : inputData[indexPath.row]
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.delegate?.searchViewController(self, didCloseWith: filter[indexPath.row], resultOption: optionResult)
//        self.presentingViewController?.dismiss(animated: true, completion: nil)
//    }
    
    fileprivate func filterContentForSearchText(searchText: String) {
        filterResult = inputData.filter({ (result) -> Bool in
            return result.name.lowercased().contains(searchText.lowercased())
        })
        self.tableView.reloadData()
    }

}

extension InfoSearchTableVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            return
        }
        self.filterContentForSearchText(searchText: searchText)
    }
    
}
