//
//  DeviceEditVC.swift
//  FDMS
//
//  Created by Huy Pham on 4/10/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

enum CustomDeviceType {
    case add
    case edit
}

class DeviceCustomizationVC: UITableViewController {
    
    @IBOutlet fileprivate weak var imageView: UIImageView!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var branchLabel: UILabel!
    @IBOutlet private weak var dateButton: UIButton!
    @IBOutlet private weak var priceTextField: UITextField!
    @IBOutlet private weak var codeTextField: UITextField!
    @IBOutlet private weak var modelTextField: UITextField!
    @IBOutlet private weak var serialTextField: UITextField!
    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet private weak var datePicker: UIDatePicker!
    var device: Device = Device()
    var type: CustomDeviceType = .edit
    private var hasPickDate: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDataForType()
    }
    
    private func setupDataForType() {
        switch type {
        case .add:
            saveButton.setTitle("Add device".localized, for: .normal)
            dateButton.setTitle("Pick a date".localized, for: .normal)
        case .edit:
            imageView.sd_setImage(with: device.getImageURL(), placeholderImage: #imageLiteral(resourceName: "img_placeholder"))
            nameTextField.text = device.productionName
            statusLabel.text = device.deviceStatusName
            categoryLabel.text = device.deviceCategoryName
            dateButton.setTitle(device.boughtDate?.toDateString() ?? "Pick a date".localized, for: .normal)
            saveButton.setTitle("Save changes".localized, for: .normal)
            priceTextField.text = String(device.originalPrice)
            codeTextField.text = device.deviceCode
        }
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
    }
    
    // MARK: - Tableview delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (hasPickDate && indexPath.section == 0 && indexPath.row == 5) ? 216 : 
                (!hasPickDate && indexPath.section == 0 && indexPath.row == 5) ? 0 :
                44
    }
        
    // MARK: - Button Action
    
    @IBAction func onDateButtonPressed(_ sender: UIButton) {
        if hasPickDate {
            hasPickDate = false
            device.boughtDate = datePicker.date
            dateButton.setTitle(device.boughtDate?.toDateString() ?? "Pick a date".localized, for: .normal)
        } else {
            hasPickDate = true
            dateButton.setTitle("Done", for: .normal)
            device.boughtDate = datePicker.date
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    @IBAction func onCancelButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSaveButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func onChangeImagePressed(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Change Image".localized, message: nil, preferredStyle: .actionSheet)
        let takePhotoAction = UIAlertAction(title: "Take a photo".localized, style: .default) { [weak self] (_) in
            self?.openImagePicker(withCamera: true)
        }
        actionSheet.addAction(takePhotoAction)
        let openLibraryAction = UIAlertAction(title: "Open Photo Library".localized,
                                              style: .default) { [weak self] (_) in
                                                self?.openImagePicker(withCamera: false)
        }
        actionSheet.addAction(openLibraryAction)
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        present(actionSheet, animated: true, completion: nil)
    }
    
    private func openImagePicker(withCamera: Bool) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.modalTransitionStyle = .crossDissolve
        if withCamera {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicker.sourceType = .camera
                imagePicker.cameraDevice = .rear
                imagePicker.cameraCaptureMode = .photo
                imagePicker.allowsEditing = true
            } else {
                WindowManager.shared.showMessage(message: "Camera Not Found".localized, title: nil,
                                                 completion: nil)
                return
            }
        } else {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                imagePicker.sourceType = .photoLibrary
            } else {
                WindowManager.shared.showMessage(message: "Library Not Found".localized, title: nil,
                                                 completion: nil)
                return
            }
        }
        present(imagePicker, animated: true, completion: nil)
    }
    
}

extension DeviceCustomizationVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imageView.image = image
        } else {
            WindowManager.shared.showMessage(message: "Photo Error".localized, title: nil,
                                             completion: nil)
        }
        picker.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}
