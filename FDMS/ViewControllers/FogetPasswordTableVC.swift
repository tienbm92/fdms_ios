//
//  FogetPasswordTableVC.swift
//  FDMS
//
//  Created by Bui Minh Tien on 4/7/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

class FogetPasswordTableVC: UITableViewController {

    @IBOutlet weak fileprivate var emailTextField: UITextField!
    @IBOutlet weak fileprivate var statusLable: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.statusLable.isHidden = true
        self.emailTextField.text = nil
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "framgia_logo"))
        
    }
    
    @IBAction func viewDidTab(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

    @IBAction func resetPassButton(_ sender: UIButton) {
        self.view.endEditing(true)
    }
    
}
extension FogetPasswordTableVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
}
