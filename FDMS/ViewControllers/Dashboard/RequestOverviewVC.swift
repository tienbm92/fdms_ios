//
//  RequestOverviewVC.swift
//  FDMS
//
//  Created by Nguyen Quoc Tinh on 4/18/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import ESPullToRefresh
import UIKit

class RequestOverviewVC: UITableViewController {
    
    private var tableData: [SectionInfo] = [SectionInfo]()
    private var requests: [Request] = [Request]()
    private var dashboard: [Dashboard] = [Dashboard]()
    private let deviceOverview: DeviceOverviewVC = DeviceOverviewVC()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.settingValueForVC()
        self.registerCellClass()
        self.tableView.es_addPullToRefresh { [weak self] in
            self?.settingValueForVC(isShowProgressView: false)
        }
    }

    private func registerCellClass() {
        self.tableView.register(UINib(nibName: kListTopRequestsCell, bundle: nil),
                                      forCellReuseIdentifier: kListTopRequestsCell)
        self.tableView.register(UINib(nibName: kPieChartCell, bundle: nil), forCellReuseIdentifier: kPieChartCell)
    }
    
    private func cellForListTopRequest(in tableview: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: kListTopRequestsCell, for: indexPath)
            as? ListTopRequestsCell else {
            return UITableViewCell()
        }
        cell.setValueForCell(self.requests, controller: self)
        return cell
    }
    
    private func cellForPieChart(in tableview: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: kPieChartCell, for: indexPath)
            as? PieChartCell else {
            return UITableViewCell()
        }
        cell.setValueForCell(self.dashboard)
        return cell
    }
    
    private func cellForTopRequestTitle(in tableview: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kTopRequestTitleCell, for: indexPath)
        return cell
    }
    
    private func handleReturnCell(in tableview: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return self.cellForPieChart(in: tableView, at: indexPath)
        case 1:
            if indexPath.row == 0 {
                return self.cellForTopRequestTitle(in: tableView, at: indexPath)
            } else {
                return self.cellForListTopRequest(in: tableView, at: indexPath)
            }
        default:
            return UITableViewCell()
        }
    }
    
    private func getListTopRequests(completion: @escaping ([Request]?) -> Void) {
        let page = Page()
        RequestService.share.getListRequests(option: .topRequest, RequestStatusId: nil, RelativeID: nil,
                                             Page: page) { [weak self] (result) in
            WindowManager.shared.hideProgressView()
            self?.tableView.es_stopPullToRefresh()
            switch result {
            case let .success(requestsResult):
                if let requests = requestsResult as? [Request] {
                    completion(requests)
                } else {
                    completion(nil)
                }
            case let .failure(error):
                let message = RequestService.share.getMessage()
                if message != "" {
                    WindowManager.shared.showMessage(message: message, title: nil, completion: nil)
                } else {
                    WindowManager.shared.showMessage(message: error.localizedDescription, title: nil, completion: nil)
                }
                completion(nil)
            }
        }
    }
    
    func getDashboad(_ comtroller: UITableViewController, option: OptionGetURL,
                     completion: @escaping ([Dashboard]?) -> Void) {
        DeviceService.shared.getDashboad(OptionGet: option) { [weak comtroller] (result) in
            WindowManager.shared.hideProgressView()
            comtroller?.tableView.es_stopPullToRefresh()
            switch result {
            case let .success(dashboard):
                if let dashboard = dashboard as? [Dashboard] {
                    completion(dashboard)
                } else {
                    completion(nil)
                }
            case let .failure(error):
                let message = DeviceService.shared.getMessage()
                if message != "" {
                    WindowManager.shared.showMessage(message: message, title: nil, completion: nil)
                } else {
                    WindowManager.shared.showMessage(message: error.localizedDescription, title: nil, completion: nil)
                }
                completion(nil)
            }
        }
    }
    
    private func settingValueForVC(isShowProgressView: Bool = true) {
        if isShowProgressView {
            WindowManager.shared.showProgressView()
        }
        self.getDashboad(self, option: .getRequestDashboad) { [weak self] (requestDashboad) in
            if let requestDashboad = requestDashboad {
                self?.dashboard = requestDashboad
            } else {
                WindowManager.shared.showMessage(message: "data.empty".localized, title: nil, completion: nil)
            }
            self?.getListTopRequests { [weak self] (result) in
                if let result = result {
                    self?.requests = result
                } else {
                    WindowManager.shared.showMessage(message: "data.empty".localized, title: nil, completion: nil)
                }
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    private func setTitleHeader(section: Int) -> String? {
        switch section {
        case 1:
            return "top.request".localized
        default:
            return nil
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deviceOverview.setNumberOfRowInSection(section: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.handleReturnCell(in: tableView, at: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.setTitleHeader(section: section)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return deviceOverview.setHeightForRow(in: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return deviceOverview.setHeightForHeaderFooter(section: section)
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return deviceOverview.setHeightForHeaderFooter(section: section)
    }

}
