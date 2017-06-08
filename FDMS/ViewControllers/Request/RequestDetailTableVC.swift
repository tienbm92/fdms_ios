//
//  RequestDetailTableVC.swift
//  FDMS
//
//  Created by Bùi Minh Tiến on 5/23/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

enum TypeView {
    case requestInfo
    case devicesAssignment
    case manageRequest
    case yourRequest
}

class RequestDetailTableVC: UITableViewController {

    fileprivate var request: Request?
    fileprivate let numberOfSections: Int = 4
    fileprivate let defaultNumberOfRow: Int = 1
    fileprivate let defaultHeightForHeader: CGFloat = 50
    fileprivate var typeView: TypeView = .requestInfo
    fileprivate var checkingUpdate: Bool = false
    @IBOutlet private weak var segmentedChangeView: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCellClass()
        self.tableView.sectionHeaderHeight = defaultHeightForHeader
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let requestId = self.request?.requestId, self.checkingUpdate {
            WindowManager.shared.showProgressView()
            self.getRequestById(requestId: requestId)
        }
    }
    
    func setValue(request: Request) {
        self.request = request
    }
    @IBAction func changeViewType(_ sender: UISegmentedControl) {
        switch segmentedChangeView.selectedSegmentIndex {
        case 0:
            self.typeView = .requestInfo
        case 1:
            self.typeView = .devicesAssignment
        default:
            break
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func getRequestById(requestId: Int) {
        RequestService.share.getRequestById(requestId: requestId) { [weak self] (result) in
            WindowManager.shared.hideProgressView()
            switch result {
            case let .success(request):
                if let request = request as? Request {
                    self?.request = request
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                }
            case .failure(_):
                self?.request = nil
                let message = RequestService.share.getMessage()
                WindowManager.shared.showMessage(message: message, title: nil, completion: nil)
            }
        }
    }
    
    private func registerCellClass() {
        self.tableView.register(UINib(nibName: kInfoRequestCell, bundle: nil),
                                forCellReuseIdentifier: kInfoRequestCell)
        self.tableView.register(UINib(nibName: kDevicesRequestCell, bundle: nil),
                                forCellReuseIdentifier: kDevicesRequestCell)
        self.tableView.register(UINib(nibName: buttonCellId, bundle: nil),
                                forCellReuseIdentifier: buttonCellId)
        self.tableView.register(UINib(nibName: kDevicesAssignmentCell, bundle: nil),
                                forCellReuseIdentifier: kDevicesAssignmentCell)
    }
    
    fileprivate func cellForInfoRequest(in tabelview: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: kInfoRequestCell, for: indexPath)
            as? InfoRequestCell, let request = self.request else {
            return UITableViewCell()
        }
        cell.setValueForCell(request: request)
        return cell
    }
    
    fileprivate func cellForDevicesRequest(in tableview: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableview.dequeueReusableCell(withIdentifier: kDevicesRequestCell, for: indexPath)
            as? DevicesRequestCell else {
            return UITableViewCell()
        }
        cell.setValue(devices: request?.devices)
        return cell
    }
    
    fileprivate func cellForButtonAction(in tableview: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableview.dequeueReusableCell(withIdentifier: buttonCellId, for: indexPath)
            as? ButtonCell else {
            return UITableViewCell()
        }
        if indexPath.row == 2 {
            cell.setValueForButton(action: nil, textLabel: "Edit", controller: self, request: self.request)
        } else if let listAction = self.request?.listAction, !listAction.isEmpty, indexPath.row < listAction.count {
            cell.setValueForButton(action: listAction[indexPath.row], textLabel: nil, controller: nil,
                                   request: self.request)
            cell.delegate = self
        } else {
            cell.setValueForButton(action: nil, textLabel: "Edit", controller: self, request: self.request)
        }
        return cell
    }
    
    fileprivate func cellForDeviceAssignment(in tableview: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableview.dequeueReusableCell(withIdentifier: kDevicesAssignmentCell, for: indexPath)
            as? DevicesAssignmentCell, let deviceAssignment = self.request?.devicesAssignment else {
            return UITableViewCell()
        }
        cell.setValueForCell(imageUrl: deviceAssignment[indexPath.row].image,
                             productName: deviceAssignment[indexPath.row].productName,
                             deviceCategory: deviceAssignment[indexPath.row].deviceCategory)
        return cell
    }
    
    fileprivate func handleReturnCell(in tableview: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return self.cellForInfoRequest(in: tableview, at: indexPath)
        case 1:
            return self.cellForDevicesRequest(in: tableview, at: indexPath)
        case 2:
            if self.request?.requestStatus != "cancelled", self.request?.requestStatus != "done",
               let listAction = self.request?.listAction, !listAction.isEmpty {
                return self.cellForButtonAction(in: tableview, at: indexPath)
            } else {
                return UITableViewCell()
            }
        default:
            return UITableViewCell()
        }
    }
    
    private func sizeHeightRowListDevice() -> CGFloat {
        if let request = self.request, let devices = request.devices, !devices.isEmpty {
            if devices.count == 1 {
                return 85
            } else if devices.count == 2 {
                return 170
            } else {
                return 255
            }
        } else {
            return 0
        }
    }
    
    private func checkingDevices() -> Bool {
        if let devices = self.request?.devices, !devices.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    private func titleHeaderInSection(section: Int) -> String? {
        switch section {
        case 0:
            return "Info Request"
        case 1:
            if self.checkingDevices() {
                return "Devices"
            } else {
                return nil
            }
        case 2:
            return " "
        case 3:
            return " "
        default:
            return nil
        }
    }
    
    private func checkTypeView() -> Bool {
        switch self.typeView {
        case .devicesAssignment:
            return false
        case .requestInfo:
            return true
        default:
            return false
        }
    }
    
    private func setNumberOfRowInSection(in section: Int) -> Int {
        if self.checkTypeView() {
            if section == 2, let listAction = self.request?.listAction {
                return listAction.count + 1
            } else {
                return self.defaultNumberOfRow
            }
        } else {
            if let devicesAssignment = self.request?.devicesAssignment {
                return devicesAssignment.count
            } else {
                return 0
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.checkTypeView() ? self.numberOfSections : 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 3 {
            return 20
        } else if !self.checkingDevices(), section == 1 {
            return 0
        } else {
            return self.defaultHeightForHeader
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.checkTypeView() ? self.titleHeaderInSection(section: section) : "Devices Assignment"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.setNumberOfRowInSection(in: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.checkTypeView() ?
            self.handleReturnCell(in: tableView, at: indexPath) :
            self.cellForDeviceAssignment(in: tableView, at: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            if self.checkTypeView() {
                return 190
            } else {
                return 90
            }
        case 1:
            return self.sizeHeightRowListDevice()
        case 2:
            return 50
        default:
            return 0
        }
    }

}

extension RequestDetailTableVC: ButtonCellDelegate {
    
    func updateActionRequestDelegate(_ buttonCell: UITableViewCell, requestUpdate: Request?, isUpdate: Bool) {
        if let request = requestUpdate {
            self.request = request
            self.tableView.reloadData()
        } else if isUpdate {
            self.checkingUpdate = true
        } else {
            WindowManager.shared.showMessage(message: "update.action.error".localized, title: nil, completion: nil)
        }
    }
    
}
