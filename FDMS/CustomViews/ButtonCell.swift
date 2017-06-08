//
//  ButtonCell.swift
//  FDMS
//
//  Created by Bui Minh Tien on 4/10/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

protocol ButtonCellDelegate: class {
    func updateActionRequestDelegate(_ buttonCell: UITableViewCell, requestUpdate: Request?, isUpdate: Bool)
}

class ButtonCell: UITableViewCell {
    
    @IBOutlet weak var actionLabel: UILabel!
    fileprivate var action: OtherObject?
    fileprivate var controller: UIViewController?
    fileprivate var request: Request?
    weak var delegate: ButtonCellDelegate?
    
    func setValueForButton(action: OtherObject?, textLabel: String?, controller: UIViewController?,
                           request: Request? = nil ) {
        if let action = action {
            self.actionLabel.text = action.name
        }
        self.action = action
        self.controller = controller
        self.request = request
    }
    
    private func actionEditRequest(_ controller: UIViewController) {
        guard let editRequestVC = UIStoryboard.manageRequest.instantiateViewController(withIdentifier:
            String(describing: EditRequestTableVC.self)) as? EditRequestTableVC else {
            return
        }
        editRequestVC.setValueEditRequestVC(self.request)
        self.delegate?.updateActionRequestDelegate(self, requestUpdate: nil, isUpdate: true)
        controller.navigationController?.pushViewController(editRequestVC, animated: true)
    }
    
    @IBAction func actionButton(_ sender: UIButton) {
        if let controller = self.controller, self.actionLabel.text == "Edit" {
            self.actionEditRequest(controller)
        } else {
            self.updateActionRequest()
        }
    }
    
    private func updateActionRequest() {
        guard let action = self.action, let request = self.request else {
            return
        }
        WindowManager.shared.showProgressView()
        request.requestStatusId = action.valueId
        RequestService.share.updateActionRequest(request: request) { (response) in
            WindowManager.shared.hideProgressView()
            switch response {
            case let .success(result):
                if let requestUpdate = result as? Request {
                    self.delegate?.updateActionRequestDelegate(self, requestUpdate: requestUpdate, isUpdate: false)
                } else {
                    self.delegate?.updateActionRequestDelegate(self, requestUpdate: nil, isUpdate: false)
                }
            case let .failure(error):
                self.delegate?.updateActionRequestDelegate(self, requestUpdate: nil, isUpdate: false)
                print(error.localizedDescription)
                let message = RequestService.share.getMessage()
                print(message)
                WindowManager.shared.showMessage(message: "update.action.error".localized, title: nil, completion: nil)
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.setValueForButton(action: nil, textLabel: nil, controller: nil)
    }

}
