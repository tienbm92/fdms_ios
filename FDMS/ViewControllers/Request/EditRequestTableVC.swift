//
//  EditRequestTableVC.swift
//  FDMS
//
//  Created by Bui Minh Tien on 4/17/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

class EditRequestTableVC: UITableViewController {

    @IBOutlet fileprivate weak var requestStatusLabel: UILabel!
    @IBOutlet fileprivate weak var descriptionTextField: UITextField!
    @IBOutlet fileprivate weak var assignLabel: UILabel!
    @IBOutlet fileprivate weak var titleTextField: UITextField!
    @IBOutlet fileprivate weak var containerView: UIView!
    @IBOutlet fileprivate weak var requestFor: UILabel!
    @IBOutlet fileprivate weak var lineView: UIView!
    fileprivate var request: Request?
    fileprivate var devices: [DevicesForRequest] = [DevicesForRequest]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.lineView.isHidden = true
        self.setingEditRequestTableVC()
        self.addSubviewForContainerView()
    }
    
    func setValueEditRequestVC(_ request: Request?) {
        self.request = request
    }
    
    @IBAction func actionUpdateRequest(_ sender: UIBarButtonItem) {
        self.updateActionRequest()
    }
    
    private func setingEditRequestTableVC() {
        guard let request = self.request else {
            WindowManager.shared.showMessage(message: "not.empty".localized, title: "Error", completion: { (_) in
                self.navigationController?.popViewController(animated: true)
            })
            return
        }
        if let assignee = request.assignee {
            assignLabel.text = assignee
        }
        titleTextField.text = request.title
        descriptionTextField.text = request.description
        requestFor.text = request.requestFor
        requestStatusLabel.text = request.requestStatus
    }
    
    @IBAction func addDevice(_ sender: UIButton) {
        guard let addRequestDeviceVC = storyboard?.instantiateViewController(withIdentifier:
            String(describing: AddRequestDeviceVC.self)) as? AddRequestDeviceVC else {
            return
        }
        addRequestDeviceVC.delegate = self
        self.navigationController?.pushViewController(addRequestDeviceVC, animated: true)
    }
    
    @IBAction func assignToAction(_ sender: UIButton) {
        let newRequestTableVC = NewRequestTableVC()
        newRequestTableVC.getListAssignTo { (listAssign) in
            if let listAssign = listAssign {
                WindowManager.shared.pushSearchViewController(self, textTitle: "Assign To",
                                                              otherObject: listAssign, optionSearch: .assignee)
            } else {
                return
            }
        }
    }
    
    @IBAction func requestStatusAction(_ sender: UIButton) {
        guard let listAction = self.request?.listAction else {
            WindowManager.shared.showMessage(message: "action.empty".localized, title: nil, completion: nil)
            return
        }
        WindowManager.shared.pushSearchViewController(self, textTitle: "Action Request",
                                                      otherObject: listAction, optionSearch: .actionRequest)
    }
    
    fileprivate func addSubviewForContainerView() {
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
    
    fileprivate func updateActionRequest() {
        guard let title = self.titleTextField.text, let description = self.descriptionTextField.text,
            let request = self.request else {
            WindowManager.shared.showMessage(message: "not.empty".localized, title: "Error", completion: nil)
            return
        }
        request.title = title
        request.description = description
        WindowManager.shared.showProgressView()
        RequestService.share.updateOrAddRequest(OptionActionRequest: .updateRequest, RequestUpdate: request,
                                                device: self.devices) { [weak self] (response) in
            WindowManager.shared.hideProgressView()
            switch response {
            case let .success(requestResult):
                if let result = requestResult as? Request {
                    self?.request = result
                    self?.navigationController?.popViewController(animated: true)
                }
            case let .failure(error):
                print(error)
                let message = RequestService.share.getMessage()
                WindowManager.shared.showMessage(message: message, title: nil, completion: nil)
            }
        }
    }

}

extension EditRequestTableVC: InfoSearchRequestDelegate {
    
    func searchRequestVC(_ searchViewController: InfoSearchRequestVC, didCloseWith filter: OtherObject?,
                         optionSearch: OptionSearch) {
        guard let filter = filter else {
            return
        }
        switch optionSearch {
        case .actionRequest:
            self.requestStatusLabel.text = filter.name
            self.request?.requestStatusId = filter.valueId
        case .assignee:
            self.assignLabel.text = filter.name
            self.request?.assigneeId = filter.valueId
        default:
            break
        }
    }
    
}

extension EditRequestTableVC: AddRequestDeviceDelegate {
    
    func addRequestDevice(_ addRequestDeviceVC: AddRequestDeviceVC, didCloseWith result: DevicesForRequest?) {
        if let device = result {
            self.devices.append(device)
            self.addSubviewForContainerView()
        }
    }

}

extension EditRequestTableVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        self.updateActionRequest()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == self.descriptionTextField {
            self.view.endEditing(true)
        } else if textField == self.titleTextField {
            self.view.endEditing(true)
        }
        return true
    }
    
}
