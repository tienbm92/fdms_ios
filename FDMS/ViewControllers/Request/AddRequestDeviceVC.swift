//
//  AddRequestDeviceVC.swift
//  FDMS
//
//  Created by Bui Minh Tien on 4/13/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

protocol AddRequestDeviceDelegate: class {
    func addRequestDevice(_ addRequestDeviceVC: AddRequestDeviceVC, didCloseWith result: DevicesForRequest?)
}

class AddRequestDeviceVC: UITableViewController {
    
    @IBOutlet fileprivate weak var deviceCategoryLabel: UILabel!
    @IBOutlet fileprivate weak var numberTextField: UITextField!
    @IBOutlet fileprivate weak var descriptionTextField: UITextField!
    private var device: DevicesForRequest?
    fileprivate var deviceCategoryId: Int?
    weak var delegate: AddRequestDeviceDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func addDeviceAction(_ sender: UIButton) {
        self.initDevice()
        self.delegate?.addRequestDevice(self, didCloseWith: self.device)
        self.navigationController?.popViewController(animated: true)
    }
    
    private func initDevice() {
        guard let numberTextField = self.numberTextField.text ,let number = Int(numberTextField),
            let categoryId = self.deviceCategoryId, let description = self.descriptionTextField.text, let categoryName = self.deviceCategoryLabel.text else {
            WindowManager.shared.showMessage(message: "not.empty".localized, title: nil, completion: nil)
            return
        }
        self.device = DevicesForRequest(deviceId: nil, description: description, number: number,
                                        categoryName: categoryName, categoryId: categoryId)
    }
    
    func getDeviceCategory(completion: @escaping ([OtherObject]?) -> Void) {
        WindowManager.shared.showProgressView()
        DeviceService.shared.getOtherObject(OptionGet: .getDeviceCategories) { (result) in
            WindowManager.shared.hideProgressView()
            switch result {
            case let .success(listDeviceCategory):
                if let listDeviceCategory = listDeviceCategory as? [OtherObject]{
                    completion(listDeviceCategory)
                } else {
                    completion(nil)
                }
            case .failure(_):
                completion(nil)
                let message = DeviceService.shared.getMessage()
                WindowManager.shared.showMessage(message: message, title: nil, completion: nil)
            }
        }
    }
    
    @IBAction private func deviceCatagoryAction(_ sender: UIButton) {
        self.getDeviceCategory { (listDeviceCategory) in
            if let listDeviceCategory = listDeviceCategory, let text = self.deviceCategoryLabel.text {
                WindowManager.shared.pushSearchViewController(self, textTitle: text, otherObject: listDeviceCategory,
                                                              optionSearch: .relative)
            } else {
                return
            }
        }
    }
    
}

extension AddRequestDeviceVC: InfoSearchRequestDelegate {
    
    func searchRequestVC(_ searchViewController: InfoSearchRequestVC, didCloseWith filter: OtherObject?,
                         optionSearch: OptionSearch) {
        if optionSearch == .relative {
            self.deviceCategoryLabel.text = filter?.name
            self.deviceCategoryId = filter?.valueId
        }
    }
    
}

extension AddRequestDeviceVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if textField === self.numberTextField {
            return Int(string) != nil
        } else {
            return true
        }
    }
    
}
