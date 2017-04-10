//
//  ListRequestVC.swift
//  FDMS
//
//  Created by Bui Minh Tien on 4/10/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

class ListRequestVC: UIViewController {

    @IBOutlet weak fileprivate var listRequest: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
extension ListRequestVC: UITableViewDelegate, UITableViewDataSource {
    
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
