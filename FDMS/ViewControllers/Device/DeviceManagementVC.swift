//
//  DeviceManagementVC.swift
//  FDMS
//
//  Created by Nguyen Quoc Tinh on 4/4/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

class DeviceManagementVC: UIViewController {
    
    @IBOutlet private weak var deviceListTableView: UITableView!
    @IBOutlet private weak var addButton: UIBarButtonItem!
    fileprivate var devices: [Device] = [Device]()
    var selectedDevice: Device?
    lazy var dataToPassing: [FilterInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDeviceList()
    }
    
    private func fetchDeviceList() {
        let page: Page = Page(page: 1, perPage: 10)
        WindowManager.shared.showProgressView()
        DeviceService.shared.getListDevices(CategoryID: nil, StatusID: nil, Page: page) { [weak self] (result) in
            WindowManager.shared.hideProgressView()
            switch result {
            case let .success(devices):
                //bui minh tien 04/05/2017- begin
                if let devices = devices as? [Device] {
                    self?.devices = devices
                }
                //end
                self?.deviceListTableView.reloadData()
            case let .failure(error):
                print(error)
            }
        }
    }
    
    private func moveToSearchScreen(optionGet: OptionGetURL, with segueIdentifier: String) {
        DeviceService.shared.getOtherObject(OptionGet: optionGet, completion: { [weak self] (result) in
            switch result {
            case let .success(data):
                var inputData: [FilterInfo] = []
//                for i in 0..<data.count {
//                    let filterElement = FilterInfo()
//                    filterElement.objectId = data[i].valueId
//                    filterElement.name = data[i].name
//                    inputData.append(filterElement)
//                }
                self?.dataToPassing = inputData
                self?.performSegue(withIdentifier: segueIdentifier, sender: nil)
            case let .failure(error):
                print(error)
            }
        })
    }
    
    @IBAction func onStatusButtonPressed(_ sender: UIButton) {
        self.moveToSearchScreen(optionGet: .getDeviceStatus, with: "DeviceStatusFilter")
    }
    
    @IBAction func onCategoryButtonPressed(_ sender: UIButton) {
        self.moveToSearchScreen(optionGet: .getDeviceCategories, with: "CategoryFilter")
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
        } else if segue.identifier == "CategoryFilter" {
//            guard let destination = segue.destination as? InfoSearchTableVC else {
//                return
//            }
//            destination.title = "Categories"
//            destination.inputData = dataToPassing
        } else if segue.identifier == "DeviceStatusFilter" {
//            guard let destination = segue.destination as? InfoSearchTableVC else {
//                return
//            }
//            destination.title = "Device Status"
//            destination.inputData = dataToPassing
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
