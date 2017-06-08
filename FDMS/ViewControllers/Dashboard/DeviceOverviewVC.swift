//
//  DeviceOverviewVC.swift
//  FDMS
//
//  Created by Nguyen Quoc Tinh on 4/18/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import ESPullToRefresh
import UIKit

class DeviceOverviewVC: UITableViewController {

    private var dashboad: [Dashboard] = [Dashboard]()
    private var topDevices: [TopDevice] = [TopDevice]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCellClass()
        settingValueForVC()
        self.tableView.es_addPullToRefresh { [weak self] in
            self?.settingValueForVC(isShowProgressView: false)
        }
    }
    
    private func registerCellClass() {
        self.tableView.register(UINib(nibName: kPieChartCell, bundle: nil), forCellReuseIdentifier: kPieChartCell)
        self.tableView.register(UINib.init(nibName: kListTopDevicesCell, bundle: nil),
                                forCellReuseIdentifier: kListTopDevicesCell)
    }
    
    fileprivate func cellForPieChart(in tableview: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: kPieChartCell, for: indexPath) as? PieChartCell else {
            return UITableViewCell()
        }
        cell.setValueForCell(self.dashboad)
        return cell
    }
    
    fileprivate func cellForListTopDevices(in tableview: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: kListTopDevicesCell, for: indexPath)
            as? ListTopDevicesCell else {
            return UITableViewCell()
        }
        cell.setValueForCell(self.topDevices)
        return cell
    }
    
    fileprivate func cellForTopDeviceTitle(in tableview: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kTopDeviceTitleCell, for: indexPath)
        return cell
    }
    
    fileprivate func handleReturnCell(in tableview: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return self.cellForPieChart(in: tableView, at: indexPath)
        case 1:
            if indexPath.row == 0 {
                return self.cellForTopDeviceTitle(in: tableView, at: indexPath)
            } else {
                return self.cellForListTopDevices(in: tableView, at: indexPath)
            }
        default:
            return UITableViewCell()
        }
    }
    
    func setHeightForRow(in indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 280
        case 1:
            return indexPath.row == 0 ? 50 : 260
        default:
            return 0
        }
    }
    
    private func setTitleHeader(section: Int) -> String? {
        switch section {
        case 1:
            return "top.device.category".localized
        default:
            return nil
        }
    }
    
    func setHeightForHeaderFooter(section: Int) -> CGFloat {
        switch section {
        case 1:
            return 36
        default:
            return 1
        }
    }
    
    func setNumberOfRowInSection(section: Int) -> Int {
        switch section {
        case 1:
            return 2
        default:
            return 1
        }
    }
    
    private func getTopDevices(completion: @escaping ([TopDevice]?) -> Void) {
        DeviceService.shared.getTopDevices { [weak self] (result) in
            WindowManager.shared.hideProgressView()
            self?.tableView.es_stopPullToRefresh()
            switch result {
            case let .success(response):
                if let topDevices = response as? [TopDevice] {
                    completion(topDevices)
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
        let requestOverviewVC = RequestOverviewVC()
        if isShowProgressView {
            WindowManager.shared.showProgressView()
        }
        requestOverviewVC.getDashboad(self, option: .getDeviceDashboad) { [weak self] (requestDashboad) in
            if let requestDashboad = requestDashboad {
                self?.dashboad = requestDashboad
            } else {
                WindowManager.shared.showMessage(message: "data.empty".localized, title: nil, completion: nil)
            }
            self?.getTopDevices { [weak self] (result) in
                if let result = result {
                    self?.topDevices = result
                } else {
                    WindowManager.shared.showMessage(message: "data.empty".localized, title: nil, completion: nil)
                }
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.view.bringSubview(toFront: (self?.tableView)!)
                }
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.setNumberOfRowInSection(section: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.handleReturnCell(in: tableView, at: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.setTitleHeader(section: section)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.setHeightForRow(in: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.setHeightForHeaderFooter(section: section)
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return self.setHeightForHeaderFooter(section: section)
    }

}
