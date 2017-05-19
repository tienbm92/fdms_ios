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
    //bui minh tien 04/05/2017- begin
    //var device: Device = Device()
    private var device: Device?
    //end
    
    //bui minh tien 04/05/2017- begin
    func setValue(_ device: Device) {
        self.device = device
    }
    //end
    
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
            //bui minh tien 04/05/2017- begin
            guard let childVC = segue.destination as? DeviceInfoVC, let device = self.device else {
                return
            }
            //childVC.device = self.device
            childVC.device = device
            //end
        }
    }
    
}
