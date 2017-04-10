//
//  AddRequestDeviceVC.swift
//  FDMS
//
//  Created by Bui Minh Tien on 4/13/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

class AddRequestDeviceVC: UITableViewController {
    
    fileprivate let manageRequest: ManageRequestVC = ManageRequestVC()
    @IBOutlet private weak var deviceCatagoryButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.row == 3 {
//            self.performSegue(withIdentifier: "BackFromAddDevice", sender: nil)
//        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BackFromAddDevice" {
//            if let manageRequestVC = segue.destination as? ManageRequestVC {
//                manageRequest
//            }
        }
    }
    @IBAction private func deviceCatagoryAction(_ sender: UIButton) {
//        guard let textButton = self.deviceCatagoryButton.titleLabel?.text else {
//            return
//        }
//        self.manageRequest.pushSearchViewController(title: textButton)
    }
    
}
