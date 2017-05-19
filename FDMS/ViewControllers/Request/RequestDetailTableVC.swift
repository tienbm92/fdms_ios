//
//  RequestDetailTableVC.swift
//  FDMS
//
//  Created by Bùi Minh Tiến on 5/23/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

class RequestDetailTableVC: UITableViewController {

    @IBOutlet fileprivate weak var updateLabel: UILabel!
    @IBOutlet fileprivate weak var createLabel: UILabel!
    @IBOutlet fileprivate weak var requestForLabel: UILabel!
    @IBOutlet fileprivate weak var requestStatusLabel: UILabel!
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var descriptionLabel: UILabel!
    fileprivate var request: Request?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setValueRequestDetatil()
    }
    
    func setValue(request: Request) {
        self.request = request
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "InfoDeviceTableVC" {
            guard let infoDeviceTableVC = segue.destination as? InfoDeviceTableVC, let request = self.request else {
                return
            }
            infoDeviceTableVC.setValue(devices: request.devices)
        }
    }
    
    private func setValueRequestDetatil() {
        self.updateLabel.text = self.request?.updater
        self.createLabel.text = self.request?.creater
        self.requestForLabel.text = self.request?.requestFor
        self.requestStatusLabel.text = self.request?.requestStatus
        self.titleLabel.text = self.request?.title
        self.descriptionLabel.text = self.request?.description
    }
    
    @IBAction func editBarButton(_ sender: UIBarButtonItem) {
        WindowManager.shared.actionDetailRequest()
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
        RequestService.share.updateOrAddRequest(OptionActionRequest: .updateRequest, RequestUpdate: request,
                                                userId: uid) { [weak self] (result) in
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
    
    private func sizeHeightRowListDevice() -> CGFloat {
        if let request = self.request, !request.devices.isEmpty {
            return 300
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 2 {
            return 0
        } else {
            return 70
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 200
        case 1:
            return self.sizeHeightRowListDevice()
        default:
            return 50
        }
    }

}
