//
//  NewRequestTableVC.swift
//  FDMS
//
//  Created by Bui Minh Tien on 4/14/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

class NewRequestTableVC: UITableViewController {

    @IBOutlet fileprivate weak var containerView: UIView!
    @IBOutlet fileprivate weak var descriptionTextField: UITextField!
    @IBOutlet fileprivate weak var titleTextField: UITextField!
    @IBOutlet fileprivate weak var assignToLabel: UILabel!
    @IBOutlet fileprivate weak var requestForLabel: UILabel!
    @IBOutlet fileprivate weak var lineView: UIView!
    fileprivate var requestForId: Int?
    fileprivate var assignToId: Int?
    fileprivate var request: Request?
    fileprivate var devices: [DevicesForRequest] = [DevicesForRequest]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.lineView.isHidden = true
    }

    @IBAction func addDevice(_ sender: UIButton) {
        self.lineView.isHidden = false
        if let addRequestTableVC = storyboard?.instantiateViewController(withIdentifier:
            String(describing: AddRequestDeviceVC.self)) as? AddRequestDeviceVC {
            addRequestTableVC.delegate = self
            self.navigationController?.pushViewController(addRequestTableVC, animated: true)
        } else {
            return
        }
    }
    
    @IBAction func addRequestFor(_ sender: UIButton) {
        ManageRequestVC.share.getListUserRelative { (listRequestFor) in
            if let listRequestFor = listRequestFor, let text = self.requestForLabel?.text {
                WindowManager.shared.pushSearchViewController(self, textTitle: text, otherObject: listRequestFor,
                                                              optionSearch: .relative)
            } else {
                return
            }
        }
    }
    @IBAction func actionAddRequest(_ sender: UIBarButtonItem) {
        self.addRequestToServer { (request) in
            if let request = request {
                self.request = request
            }
        }
    }
    
    private func addRequestToServer(completion: @escaping (Request?) -> Void) {
        guard self.initRequest(), let request = self.request else {
            completion(nil)
            return
        }
        WindowManager.shared.showProgressView()
        RequestService.share.updateOrAddRequest(OptionActionRequest: .addRequest,
                                                RequestUpdate: request, device: self.devices) { (result) in
            WindowManager.shared.hideProgressView()
            switch result {
            case .success(_):
                let message = RequestService.share.getMessage()
                WindowManager.shared.showMessage(message: message, title: nil, completion: { [weak self] (_) in
                    self?.navigationController?.popViewController(animated: true)
                })
            case let .failure(error):
                print(error.localizedDescription)
                WindowManager.shared.showMessage(message: "add.request.false".localized, title: "Error", completion: nil)
            }
        }
    }
    
    private func initRequest() -> Bool {
        guard let title = self.titleTextField.text, let description = self.descriptionTextField.text,
            let requestForId = self.requestForId, let assignId = self.assignToId else {
            WindowManager.shared.showMessage(message: "not.empty".localized, title: nil, completion: nil)
            return false
        }
        self.request = Request(title: title, description: description, assignToId: assignId,
                               requestForId: requestForId, devices: self.devices)
        if self.request != nil {
            return true
        } else {
            return false
        }
    }
    
    fileprivate func setDataInfoDeviceTableVC() {
        guard let requestDevicesVC = storyboard?.instantiateViewController(withIdentifier: String(describing:
            RequestDeviceTableVC.self)) as? RequestDeviceTableVC else {
                return
        }
        requestDevicesVC.setValue(devices: self.devices)
        self.addChildViewController(requestDevicesVC)
        requestDevicesVC.view.frame = CGRect(x: 0, y: 0, width: self.containerView.frame.size.width,
                                             height: self.containerView.frame.size.height)
        self.containerView.addSubview(requestDevicesVC.view)
        requestDevicesVC.didMove(toParentViewController: self)
    }
    
    @IBAction func backFromAddDevice(_ segue: UIStoryboardSegue) {
        
    }

    @IBAction func addAssign(_ sender: UIButton) {
        self.getListAssignTo { (listAssign) in
            if let listAssign = listAssign, let text = self.assignToLabel?.text {
                WindowManager.shared.pushSearchViewController(self, textTitle: text, otherObject: listAssign,
                                                              optionSearch: .assignee)
            }
        }
    }
    
    func getListAssignTo(completion: @escaping ([OtherObject]?) -> Void) {
        WindowManager.shared.showProgressView()
        DeviceService.shared.getOtherObject(OptionGet: .getAssignTo) { (result) in
            WindowManager.shared.hideProgressView()
            switch result {
            case let .success(listAssignTo):
                if let listAssignTo = listAssignTo as? [OtherObject] {
                    completion(listAssignTo)
                } else {
                    completion(nil)
                }
            case let .failure(error):
                completion(nil)
                WindowManager.shared.showMessage(message: error.localizedDescription, title: nil, completion: nil)
            }
        }
    }
    
}

extension NewRequestTableVC: InfoSearchRequestDelegate {
    
    func searchRequestVC(_ searchViewController: InfoSearchRequestVC, didCloseWith filter: OtherObject?,
                         optionSearch: OptionSearch) {
        switch optionSearch {
        case .assignee:
            self.assignToLabel?.text = filter?.name
            self.assignToId = filter?.valueId
        case .relative:
            self.requestForLabel?.text = filter?.name
            self.requestForId = filter?.valueId
        default:
            break
        }
    }
    
}

extension NewRequestTableVC: AddRequestDeviceDelegate {
    
    func addRequestDevice(_ addRequestDeviceVC: AddRequestDeviceVC, didCloseWith result: DevicesForRequest?) {
        if let result = result {
            self.devices.append(result)
            self.setDataInfoDeviceTableVC()
        }
    }
    
}
