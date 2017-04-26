//
//  DeviceInfoContainerVC.swift
//  FDMS
//
//  Created by Huy Pham on 4/11/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

class DeviceInfoContainerVC: UIViewController {
    
    @IBOutlet private weak var usingView: UIView!
    @IBOutlet private weak var historyView: UIView!
    @IBOutlet private weak var infoView: UIView!
    @IBOutlet private weak var closeButton: UIBarButtonItem!
    var device: Device = Device()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if navigationController?.viewControllers[0] === self {
            self.closeButton.isEnabled = true
        } else {
            self.closeButton.isEnabled = false
            self.closeButton.tintColor = UIColor.clear
        }
    }
    
    @IBAction func onSegmentChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            view.bringSubview(toFront: infoView)
        case 1:
            view.bringSubview(toFront: historyView)
        case 2:
            view.bringSubview(toFront: usingView)
        default:
            break
        }
    }
    
    @IBAction private func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDeviceInfo" {
            guard let childVC = segue.destination as? DeviceInfoVC else {
                return
            }
            childVC.device = self.device
        }
    }
    
}
