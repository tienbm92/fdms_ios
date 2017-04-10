//
//  ListRequestTableVC.swift
//  FDMS
//
//  Created by Bui Minh Tien on 4/12/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

class ListRequestTableVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoRequestCell", for: indexPath)
        cell.textLabel?.text = "12asdz"
        cell.detailTextLabel?.text = "sazza12343"
        return cell
    }

}
