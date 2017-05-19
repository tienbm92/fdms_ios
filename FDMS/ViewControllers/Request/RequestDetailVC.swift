//
//  RequestDetailVC.swift
//  FDMS
//
//  Created by Bui Minh Tien on 4/7/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

class RequestDetailVC: UIViewController {
    
    fileprivate var request: Request?
    fileprivate let titleButtonArray: [String] = ["Accept", "Cancel", "Edit"]
    @IBOutlet weak fileprivate var listRequestTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.listRequestTableView.register(UINib(nibName: "ButtonCell", bundle: nil),
                                           forCellReuseIdentifier: buttonCellId)
        self.listRequestTableView.estimatedRowHeight = 50
        self.listRequestTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        self.pushEditRequestTableVC()
    }
    
    func setValue(_ setRequest: Request) {
        self.request = setRequest
    }
    
    fileprivate func pushEditRequestTableVC() {
        guard let editRequestVC = storyboard?.instantiateViewController(withIdentifier:
            String(describing: EditRequestTableVC.self)) as? EditRequestTableVC, let request = self.request else {
            return
        }
        editRequestVC.setValue(request: request)
        self.navigationController?.pushViewController(editRequestVC, animated: true)
    }
    
    fileprivate func updateRequest(statusUpdate: String) {
        guard let request = self.request, let uid = DataStore.shared.user?.uid else {
            return
        }
        request.requestStatus = statusUpdate
        WindowManager.shared.showProgressView()
        RequestService.share.updateOrAddRequest(OptionActionRequest: .updateRequest,
                                                RequestUpdate: request, userId: uid) { [weak self] (result) in
            WindowManager.shared.hideProgressView()
            switch result {
            case let .success(requestResult):
                if let request = requestResult as? Request {
                    self?.request = request
                }
            case let .failure(error):
                print(error)
                let message = RequestService.share.getMessage()
                WindowManager.shared.showMessage(message: message, title: nil, completion: nil)
            }
        }
    }
    
}

extension RequestDetailVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Request Info"
        } else if section == 1 {
            return "Devices"
        }
        return nil
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            if let request = self.request, !request.devices.isEmpty {
                return request.devices.count
            } else {
                return 0
            }
        case 2:
            return 3
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellReturn = UITableViewCell()
        if indexPath.section == 0 {
            guard let infoRequestCell = tableView.dequeueReusableCell(withIdentifier: "InfoRequestCell",
                                                                      for: indexPath) as? InfoRequestCell,
                let request = self.request else {
                return UITableViewCell()
            }
            infoRequestCell.setValueForCell(request: request)
            cellReturn = infoRequestCell
        } else if indexPath.section == 1 {
            guard let infoDeviceCell = tableView.dequeueReusableCell(withIdentifier: "DeviceRequestCell",
                                                                     for: indexPath) as? DeviceRequestCell,
                let request = self.request else {
                    return UITableViewCell()
            }
            infoDeviceCell.setValueForCell(device: request.devices[indexPath.row])
            cellReturn = infoDeviceCell
        } else if indexPath.section == 2 {
            guard let buttonCell = tableView.dequeueReusableCell(
                withIdentifier: buttonCellId, for: indexPath) as? ButtonCell else {
                    return UITableViewCell()
            }
            buttonCell.setTextLable(titleButtonArray[indexPath.row], color: #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1))
            cellReturn = buttonCell
        }
        return cellReturn
    }
    
}

extension RequestDetailVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let request = self.request else {
            return
        }
        let positionAccept = 1 + request.devices.count + 1
        let positionCancel = 1 + request.devices.count + 2
        let positionEdit = 1 + request.devices.count + 3
        switch indexPath.row {
        case positionAccept:
            print("Accept")
            self.updateRequest(statusUpdate: "waiting done")
        case positionCancel:
            print("Cancel")
            self.updateRequest(statusUpdate: "cancelled")
        case positionEdit:
            print("Edit")
            self.pushEditRequestTableVC()
        default:
            break
        }
    }
    
}
