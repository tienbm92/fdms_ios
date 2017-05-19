//
//  ManageRequestVC.swift
//  FDMS
//
//  Created by Bui Minh Tien on 4/12/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import ESPullToRefresh
import UIKit

class ManageRequestVC: UIViewController {

    @IBOutlet fileprivate weak var statusLabel: UILabel!
    @IBOutlet fileprivate weak var relativeLabel: UILabel!
    @IBOutlet weak fileprivate var listRequestTableView: UITableView!
    fileprivate var requests: [Request] = [Request]()
    fileprivate var relativeId: Int?
    fileprivate var statusId: Int?
    fileprivate let pageDefault:Page = Page()
    fileprivate var currentPage: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getListRequest(statusId: nil, relativeId: nil, page: pageDefault)
        self.listRequestTableView.register(UINib(nibName: "ManageRequestCell", bundle: nil),
                                           forCellReuseIdentifier: kManageRequestCell)
        self.listRequestTableView.estimatedRowHeight = 80
        self.listRequestTableView.rowHeight = UITableViewAutomaticDimension
        self.listRequestTableView.es_addPullToRefresh { [weak self] in
            DispatchQueue.main.async {
                self?.refreshListRequest()
            }
        }
        self.listRequestTableView.es_addInfiniteScrolling { [weak self] in
            DispatchQueue.main.async {
                self?.loadMoreListRequest()
            }
        }
    }
    
    @IBAction func relativeToButton(_ sender: UIButton) {
        self.getListUserRelative { (listRelative) in
            if let listRelative = listRelative,
                let text = self.relativeLabel?.text {
                self.pushSearchViewController(title: text, otherObject: listRelative, optionSearch: .relative)
            } else {
                return
            }
        }

    }
        
    @IBAction func requestStatusButton(_ sender: UIButton) {
        self.getListStatus { (listStatus) in
            if let text = self.statusLabel?.text, let listStatus = listStatus {
                self.pushSearchViewController(title: text, otherObject: listStatus, optionSearch: .requestStatus)
            } else {
                return
            }
        }
    }
    
    private func refreshListRequest() {
        self.getListRequest(statusId: nil, relativeId: nil, page: pageDefault)
        self.statusLabel.text = "Status"
        self.relativeLabel.text = "Relative"
        self.statusId = nil
        self.relativeId = nil
        self.currentPage = 1
    }
    
    private func loadMoreListRequest() {
        self.currentPage += 1
        let page = Page(page: self.currentPage, perPage: 10)
        RequestService.share.getListRequests(option: .manageRequests, RequestStatusId: self.statusId,
                                             RelativeID: self.relativeId, Page: page) { [weak self] (requestResult) in
            switch requestResult {
            case let .success(result):
                self?.listRequestTableView.es_stopLoadingMore()
                guard let requests = result as? [Request] else {
                    return
                }
                let lastIndex = self?.requests.count ?? 0
                self?.requests.append(contentsOf: requests)
                var newIndexPaths = [IndexPath]()
                for index in 0..<requests.count {
                    newIndexPaths.append(IndexPath(row: index + lastIndex, section: 0))
                }
                self?.listRequestTableView.beginUpdates()
                self?.listRequestTableView.insertRows(at: newIndexPaths, with: .fade)
                self?.listRequestTableView.endUpdates()
            case let .failure(error):
                print(error.localizedDescription)
                self?.listRequestTableView.es_noticeNoMoreData()
            }
        }
    }
    
    func pushSearchViewController(title textTitle: String, otherObject: [OtherObject], optionSearch: OptionSearch) {
        guard let searchViewController = storyboard?.instantiateViewController(withIdentifier:
            String(describing: InfoSearchRequestVC.self)) as? InfoSearchRequestVC else {
            return
        }
        searchViewController.setProperty(searchDataInput: otherObject, optionSearch: optionSearch)
        searchViewController.title = textTitle
        searchViewController.delegate = self
        self.navigationController?.pushViewController(searchViewController, animated: true)
    }
    
    fileprivate func pushRequestDetailVC(index: Int) {
        guard let requestDetailVC = storyboard?.instantiateViewController(withIdentifier:
            String(describing: RequestDetailTableVC.self)) as? RequestDetailTableVC else {
            return
        }
        requestDetailVC.setValue(request: self.requests[index])
        requestDetailVC.title = "Request Detail"
        self.navigationController?.pushViewController(requestDetailVC, animated: true)
    }
    
    fileprivate func getListRequest(statusId: Int?, relativeId: Int?, page: Page) {
        RequestService.share.getListRequests(option: .manageRequests, RequestStatusId: statusId,
                                             RelativeID: relativeId, Page: page) { [weak self] (requestResult) in
            self?.listRequestTableView.es_stopPullToRefresh()
            self?.listRequestTableView.es_stopLoadingMore()
            switch requestResult {
            case let .success(requests):
                if let requests = requests as? [Request] {
                    self?.requests = requests
                }
            case let .failure(error):
                self?.requests.removeAll()
                WindowManager.shared.showMessage(message: error.localizedDescription, title: nil, completion: nil)
            }
            self?.listRequestTableView.reloadData()
        }
    }
    
    fileprivate func getListUserRelative(completion: @escaping ([OtherObject]?) -> Void) {
        WindowManager.shared.showProgressView()
        DeviceService.shared.getOtherObject(OptionGet: .getRelativeTo) { (result) in
            WindowManager.shared.hideProgressView()
            switch result {
            case let .success(listRelativeResult):
                if let listRelativeResult = listRelativeResult as? [OtherObject] {
                    completion(listRelativeResult)
                } else {
                    completion(nil)
                }
            case let .failure(error):
                completion(nil)
                WindowManager.shared.showMessage(message: error.localizedDescription, title: nil, completion: nil)
            }
        }
    }
    
    fileprivate func getListStatus(completion: @escaping ([OtherObject]?) -> Void) {
        WindowManager.shared.showProgressView()
        DeviceService.shared.getOtherObject(OptionGet: .getRquestStatus) { (result) in
            WindowManager.shared.hideProgressView()
            switch result {
            case let .success(listStatusResult):
                if let listStatusResult = listStatusResult as? [OtherObject] {
                    completion(listStatusResult)
                } else {
                    completion(nil)
                }
            case let .failure(error):
                completion(nil)
                WindowManager.shared.showMessage(message: error.localizedDescription, title: nil, completion: nil)
            }
        }
    }
    
}

extension ManageRequestVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.requests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: kManageRequestCell,
                                                       for: indexPath) as? ManageRequestCell else {
            return UITableViewCell()
        }
        cell.setValueForCell(request: requests[indexPath.row])
        return cell
    }
    
}

extension ManageRequestVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.pushRequestDetailVC(index: indexPath.row)
    }
    
}

extension ManageRequestVC: InfoSearchRequestDelegate {
    
    func searchRequestVC(_ searchViewController: InfoSearchRequestVC, didCloseWith filter: OtherObject?,
                         optionSearch: OptionSearch) {
        switch optionSearch {
        case .requestStatus:
            self.statusLabel?.text = filter?.name
            self.statusId = filter?.valueId
        case .relative:
            self.relativeLabel?.text = filter?.name
            self.relativeId = filter?.valueId
        default:
            break
        }
        self.getListRequest(statusId: self.statusId, relativeId: self.relativeId, page: self.pageDefault)
    }
    
}
