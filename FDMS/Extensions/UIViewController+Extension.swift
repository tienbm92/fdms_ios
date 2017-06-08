//
//  UIViewController+Extension.swift
//  FDMS
//
//  Created by Huy Pham on 4/5/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import IDMPhotoBrowser
import UIKit

extension UIViewController {
    
    func previewImage(_ image: UIImage) {
        if let browser = IDMPhotoBrowser(photos: [IDMPhoto(
            image: image)]) {
            browser.displayActionButton = false
            browser.displayArrowButton = false
            browser.usePopAnimation = true
            browser.forceHideStatusBar = true
            present(browser, animated: true, completion: nil)
        }
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
