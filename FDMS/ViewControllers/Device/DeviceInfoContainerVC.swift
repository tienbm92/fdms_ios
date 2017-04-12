//
//  DeviceInfoContainerVC.swift
//  FDMS
//
//  Created by Huy Pham on 4/11/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

class DeviceInfoContainerVC: UIViewController {
    
    @IBOutlet private weak var invoiceView: UIView!
    @IBOutlet private weak var usingView: UIView!
    @IBOutlet private weak var historyView: UIView!
    @IBOutlet private weak var infoView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func onSegmentChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            view.bringSubview(toFront: infoView)
        case 1:
            view.bringSubview(toFront: historyView)
        case 2:
            view.bringSubview(toFront: usingView)
        case 3:
            view.bringSubview(toFront: invoiceView)
        default:
            break
        }
    }
    
}
