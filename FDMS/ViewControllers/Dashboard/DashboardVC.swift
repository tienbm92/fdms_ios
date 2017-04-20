//
//  DashboardVC.swift
//  FDMS
//
//  Created by Nguyen Quoc Tinh on 4/3/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

class DashboardVC: UIViewController {
    
    @IBOutlet fileprivate weak var requestView: UIView!
    @IBOutlet fileprivate weak var deviceView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
        
    @IBAction func onSegmentChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            view.bringSubview(toFront: requestView)
        case 1:
            view.bringSubview(toFront: deviceView)
        default:
            break
        }
    }
    
}
