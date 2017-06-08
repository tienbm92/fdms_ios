//
//  DeviceManagementVC.swift
//  FDMS
//
//  Created by Nguyen Quoc Tinh on 4/4/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit
import ESPullToRefresh

class DeviceManagementVC: UIViewController {
    
    @IBOutlet fileprivate weak var categoryLabel: UILabel!
    @IBOutlet fileprivate  weak var deviceListTableView: UITableView!
    @IBOutlet fileprivate weak var statusLabel: UILabel!
    @IBOutlet private weak var addButton: UIBarButtonItem!
    fileprivate var devices: [Device] = [Device]()
    fileprivate let pageDefault:Page = Page()
    fileprivate var currentPage: Int = 1
    fileprivate var statusId: Int?
    fileprivate var categoryId: Int?
    var selectedDevice: Device?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchDeviceList(statusId: nil, categoryId: nil, page: self.pageDefault)
        self.deviceListTableView.es_addPullToRefresh { [weak self] in
            self?.refreshListDevice(isShowProgressView: false)
        }
        self.deviceListTableView.es_addInfiniteScrolling { [weak self] in
            self?.loadMoreListDevices()
        }
    }
    @IBAction func searchStatusAction(_ sender: UIButton) {
        self.getListCategoryAndStatus(option: .getDeviceStatus) { [weak self] (result) in
            if let listDeviceStatus = result, let text = self?.statusLabel.text, let controller = self {
                WindowManager.shared.pushSearchViewController(controller, textTitle: text,
                                                              otherObject: listDeviceStatus,
                                                              optionSearch: .deviceStatus)
            } else {
                return
            }
        }
    }
    @IBAction func searchCategoryAction(_ sender: UIButton) {
        self.getListCategoryAndStatus(option: .getDeviceCategories) { [weak self] (result) in
            if let listCategorys = result, let text = self?.categoryLabel.text, let controller = self {
                WindowManager.shared.pushSearchViewController(controller, textTitle: text,
                                                              otherObject: listCategorys,
                                                              optionSearch: .deviceCategory)
            } else {
                return
            }
        }
    }
    
    fileprivate func refreshListDevice(isShowProgressView: Bool) {
        if isShowProgressView {
            WindowManager.shared.showProgressView()
        }
        self.fetchDeviceList(statusId: nil, categoryId: nil, page: self.pageDefault)
        self.statusId = nil
        self.categoryId = nil
        self.statusLabel.text = "Status"
        self.categoryLabel.text = "Category"
    }
    
    fileprivate func getListCategoryAndStatus(option: OptionGetURL, completion: @escaping ([OtherObject]?) -> Void) {
        WindowManager.shared.showProgressView()
        DeviceService.shared.getOtherObject(OptionGet: option) { (response) in
            WindowManager.shared.hideProgressView()
            switch response {
            case let .success(result):
                if let listCategorys = result as? [OtherObject] {
                    completion(listCategorys)
                } else {
                    completion(nil)
                }
            case .failure(_):
                completion(nil)
                WindowManager.shared.showMessage(message: "data.empty".localized, title: "Error", completion: nil)
            }
        }
    }
    
    fileprivate func fetchDeviceList(statusId: Int?, categoryId: Int?, page: Page) {
        DeviceService.shared.getListDevices(CategoryID: categoryId, StatusID: statusId, Page: page) { (response) in
            WindowManager.shared.hideProgressView()
            self.deviceListTableView.es_stopPullToRefresh()
            self.deviceListTableView.es_stopLoadingMore()
            switch response {
            case let .success(devicesResult):
                if let devices = devicesResult as? [Device] {
                    self.devices = devices
                }
            case .failure(_):
                self.devices.removeAll()
                WindowManager.shared.showMessage(message: "data.empty".localized, title: "Error", completion: nil)
            }
            self.deviceListTableView.reloadData()
        }
    }
    
    private func loadMoreListDevices() {
        self.currentPage += 1
        let page = Page(page: self.currentPage, perPage: 10)
        DeviceService.shared.getListDevices(CategoryID: self.categoryId, StatusID: self.statusId,
                                            Page: page) { [weak self] (response) in
            self?.deviceListTableView.es_stopLoadingMore()
            switch response {
            case let .success(result):
                guard let devices = result as? [Device] else {
                    return
                }
                let lastIndex = self?.devices.count ?? 0
                self?.devices.append(contentsOf: devices)
                var newIndexPaths = [IndexPath]()
                for index in 0..<devices.count {
                    newIndexPaths.append(IndexPath(row: index + lastIndex, section: 0))
                }
                self?.deviceListTableView.beginUpdates()
                self?.deviceListTableView.insertRows(at: newIndexPaths, with: .fade)
                self?.deviceListTableView.endUpdates()
            case let .failure(error):
                print(error.localizedDescription)
                self?.deviceListTableView.es_noticeNoMoreData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DeviceListToDetail" {
            guard let destination = segue.destination as? DeviceInfoContainerVC else {
                return
            }
            //bui minh tien 04/05/2017- begin
            destination.setValue(selectedDevice ?? Device())
            //destination.device = selectedDevice ?? Device()
            //end
        } else if segue.identifier == "AddDevice" {
            guard let destination = segue.destination as? DeviceCustomizationVC else {
                return
            }
            destination.type = .add
        }
    }
    
}

extension DeviceManagementVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Device",
                                                       for: indexPath) as? DeviceListCell else {
                                                        return UITableViewCell()
        }
        cell.device = devices[indexPath.row]
        cell.setData()
        return cell
    }
    
}

extension DeviceManagementVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedDevice = devices[indexPath.row]
        return indexPath
    }
    
}

extension DeviceManagementVC: InfoSearchRequestDelegate {
    
    func searchRequestVC(_ searchViewController: InfoSearchRequestVC, didCloseWith filter: OtherObject?, optionSearch: OptionSearch) {
        switch optionSearch {
        case .deviceStatus:
            self.statusLabel.text = filter?.name
            self.statusId = filter?.valueId
        case .deviceCategory:
            self.categoryLabel.text = filter?.name
            self.categoryId = filter?.valueId
        default:
            break
        }
        self.fetchDeviceList(statusId: self.statusId, categoryId: self.categoryId, page: self.pageDefault)
    }
    
}
