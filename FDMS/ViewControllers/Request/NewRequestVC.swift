//
//  NewRequestVC.swift
//  FDMS
//
//  Created by Bui Minh Tien on 4/13/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

class NewRequestVC: UIViewController {

    @IBOutlet private weak var infoDeviceTableView: UITableView!
    fileprivate var countDevices: Int = 0
    fileprivate var twoSection: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.infoDeviceTableView.register(UINib(nibName: "InfoDeviceRequestCell", bundle: nil),
                                          forCellReuseIdentifier: infoDeviceRequestCell)
        self.infoDeviceTableView.estimatedRowHeight = 100
        self.infoDeviceTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    @IBAction func addDevice(_ sender: UIButton) {
        self.twoSection = true
        self.countDevices += countDevices
        infoDeviceTableView.reloadData()
    }
    
    @IBAction func backFromAddDevice(_ segue: UIStoryboardSegue) {
        
    }

}

extension NewRequestVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.countDevices
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let infoDeviceCell = tableView.dequeueReusableCell(withIdentifier: infoDeviceRequestCell,
                                                                 for: indexPath) as? InfoDeviceRequestCell
            else {
                return UITableViewCell()
        }
        return infoDeviceCell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle,
                   forRowAt indexPath: IndexPath) {
        
    }
    
}

extension NewRequestVC: UITableViewDelegate {
    
}
