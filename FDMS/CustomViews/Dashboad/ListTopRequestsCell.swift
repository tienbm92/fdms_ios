//
//  ListTopRequestsCell.swift
//  FDMS
//
//  Created by Bùi Minh Tiến on 6/7/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

class ListTopRequestsCell: UITableViewCell {

    @IBOutlet weak var myTableView: UITableView!
    fileprivate var requests: [Request] = [Request]()
    fileprivate var controller: UIViewController = UIViewController()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.myTableView.dataSource = self
        self.myTableView.delegate = self
        self.myTableView.register(UINib(nibName: kTopRequestCell, bundle: nil),
                                  forCellReuseIdentifier: kTopRequestCell)
    }
    
    func setValueForCell(_ requests: [Request], controller: UIViewController) {
        self.requests = requests
        self.controller = controller
        self.myTableView.reloadData()
    }
    
    fileprivate func pushRequestDetailVC(indexPath: IndexPath) {
        guard let requestDeatilVC = UIStoryboard.manageRequest.instantiateViewController(withIdentifier: String(describing: RequestDetailTableVC.self)) as? RequestDetailTableVC else {
            return
        }
        requestDeatilVC.setValue(request: self.requests[indexPath.row])
        self.controller.navigationController?.pushViewController(requestDeatilVC, animated: true)
    }
    
}

extension ListTopRequestsCell: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.requests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let topRequestCell = tableView.dequeueReusableCell(withIdentifier: kTopRequestCell, for: indexPath) as? TopRequestCell else {
            return UITableViewCell()
        }
        topRequestCell.setValueForCell(self.requests[indexPath.row])
        return topRequestCell
    }
    
}

extension ListTopRequestsCell: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.pushRequestDetailVC(indexPath: indexPath)
    }
    
}
