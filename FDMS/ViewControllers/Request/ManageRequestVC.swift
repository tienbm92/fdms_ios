//
//  ManageRequestVC.swift
//  FDMS
//
//  Created by Bui Minh Tien on 4/12/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

class ManageRequestVC: UIViewController {

    @IBOutlet weak private var listRequestTableView: UITableView!
    @IBOutlet weak private var requestSegment: UISegmentedControl!
    @IBOutlet weak private var relativeToTextField: UITextField!
    @IBOutlet weak private var requestStatusTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func relativeToButton(_ sender: UIButton) {
        
    }
    
    @IBAction func requestStatusButton(_ sender: UIButton) {
        
    }
    @IBAction func changeViewType(_ sender: UISegmentedControl) {
        switch requestSegment.selectedSegmentIndex {
        case 0:
            self.sendIndex(index: 0)
        case 1:
            self.sendIndex(index: 1)
        default:
            break
        }
    }
    
    func sendIndex(index: Int) {
        print("send Index")
    }
    
}

extension ManageRequestVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoRequestCell", for: indexPath)
        cell.textLabel?.text = "12asdz"
        cell.detailTextLabel?.text = "sazza12343"
        return cell
    }
    
}
