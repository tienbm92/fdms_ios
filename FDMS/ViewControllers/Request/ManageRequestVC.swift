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

    @IBOutlet weak var segmentedTypeView: UISegmentedControl!
    @IBOutlet fileprivate weak var statusLabel: UILabel!
    @IBOutlet fileprivate weak var relativeLabel: UILabel!
    @IBOutlet weak fileprivate var listRequestTableView: UITableView!
    fileprivate var requests: [Request] = [Request]()
    fileprivate var relativeId: Int?
    fileprivate var statusId: Int?
    fileprivate let pageDefault:Page = Page()
    fileprivate var currentPage: Int = 1
    fileprivate var typeView: optionGetRequests = .manageRequests
    fileprivate var checkReloadData: Bool = false
    static let share: ManageRequestVC = ManageRequestVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            WindowManager.shared.showProgressView()
            self.getListRequest(statusId: nil, relativeId: nil, page: self.pageDefault)
        }
        self.listRequestTableView.register(UINib(nibName: "ManageRequestCell", bundle: nil),
                                           forCellReuseIdentifier: kManageRequestCell)
        self.listRequestTableView.estimatedRowHeight = 120
        self.listRequestTableView.rowHeight = UITableViewAutomaticDimension
        self.listRequestTableView.es_addPullToRefresh { [weak self] in
            DispatchQueue.main.async {
                self?.refreshListRequest(isShowProgressView: false)
            }
        }
        self.listRequestTableView.es_addInfiniteScrolling { [weak self] in
            DispatchQueue.main.async {
                self?.loadMoreListRequest()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if self.checkReloadData {
            self.refreshListRequest(isShowProgressView: true)
            self.checkReloadData = false
        }
    }
    
    @IBAction func changeViewType(_ sender: UISegmentedControl) {
        switch self.segmentedTypeView.selectedSegmentIndex {
        case 0:
            self.typeView = .manageRequests
            self.refreshListRequest(isShowProgressView: true)
        case 1:
            self.typeView = .yourRequests
            self.refreshListRequest(isShowProgressView: true)
        default:
            break
        }
    }
    
    @IBAction func relativeToButton(_ sender: UIButton) {
        self.getListUserRelative { (listRelative) in
            if let listRelative = listRelative,
                let text = self.relativeLabel?.text {
                self.pushSearchViewController(textTitle: text, otherObject: listRelative, optionSearch: .relative)
            } else {
                return
            }
        }
    }
        
    @IBAction func requestStatusButton(_ sender: UIButton) {
        self.getListStatus { (listStatus) in
            if let text = self.statusLabel?.text, let listStatus = listStatus {
                self.pushSearchViewController(textTitle: text, otherObject: listStatus, optionSearch: .requestStatus)
            } else {
                return
            }
        }
    }
    
    private func refreshListRequest(isShowProgressView: Bool) {
        if isShowProgressView {
            WindowManager.shared.showProgressView()
        }
        self.getListRequest(statusId: nil, relativeId: nil, page: self.pageDefault, optionGetRequest: self.typeView)
        self.statusLabel.text = "Status"
        self.relativeLabel.text = "Relative"
        self.statusId = nil
        self.relativeId = nil
        self.currentPage = 1
    }
    
    private func loadMoreListRequest() {
        self.currentPage += 1
        let page = Page(page: self.currentPage, perPage: 10)
        RequestService.share.getListRequests(option: self.typeView, RequestStatusId: self.statusId,
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
    
    fileprivate func pushRequestDetailVC(index: Int) {
        guard let requestDetailVC = storyboard?.instantiateViewController(withIdentifier:
            String(describing: RequestDetailTableVC.self)) as? RequestDetailTableVC else {
            return
        }
        self.checkReloadData = true
        requestDetailVC.setValue(request: self.requests[index])
        self.navigationController?.pushViewController(requestDetailVC, animated: true)
    }
    
    fileprivate func getListRequest(statusId: Int?, relativeId: Int?, page: Page,
                                    optionGetRequest: optionGetRequests = .manageRequests) {
        RequestService.share.getListRequests(option: optionGetRequest, RequestStatusId: statusId,
                                             RelativeID: relativeId, Page: page) { [weak self] (requestResult) in
            WindowManager.shared.hideProgressView()
            self?.listRequestTableView.es_stopPullToRefresh()
            self?.listRequestTableView.es_stopLoadingMore()
            switch requestResult {
            case let .success(requests):
                if let requests = requests as? [Request] {
                    self?.requests = requests
                }
            case .failure(_):
                self?.requests.removeAll()
                let message = RequestService.share.getMessage()
                WindowManager.shared.showMessage(message: message, title: nil, completion: nil)
            }
            self?.listRequestTableView.reloadData()
        }
    }
    
    func getListUserRelative(completion: @escaping ([OtherObject]?) -> Void) {
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
    
    fileprivate func pushSearchViewController(textTitle: String, otherObject: [OtherObject],
                                              optionSearch: OptionSearch) {
        guard let searchViewController = UIStoryboard.manageRequest.instantiateViewController(withIdentifier:
            String(describing: InfoSearchRequestVC.self)) as? InfoSearchRequestVC else {
                return
        }
        searchViewController.setProperty(searchDataInput: otherObject, optionSearch: optionSearch)
        searchViewController.title = textTitle
        searchViewController.delegate = self
        self.navigationController?.pushViewController(searchViewController, animated: true)
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
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
        self.getListRequest(statusId: self.statusId, relativeId: self.relativeId, page: self.pageDefault,
                            optionGetRequest: self.typeView)
    }
    
}
