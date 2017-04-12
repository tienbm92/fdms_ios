//
//  DeviceEditVC.swift
//  FDMS
//
//  Created by Huy Pham on 4/10/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

class DeviceEditVC: UITableViewController {
    
    @IBOutlet private weak var changeImageButton: UIButton!
    @IBOutlet fileprivate weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Edit".localized
    }
    
    // MARK: - Tableview delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Button Action
    
    @IBAction func onDonePressed(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func onPreviewPressed(_ sender: UIButton) {
        if let image = imageView.image {
            self.previewImage(image)
        }
    }
    
    @IBAction func onChangeImagePressed(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: "Change Image".localized, message: nil,
                                            preferredStyle: .actionSheet)
        let takePhotoAction = UIAlertAction(title: "Take a photo".localized,
                                            style: .default) { [weak self] (_) in
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

extension DeviceEditVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
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

