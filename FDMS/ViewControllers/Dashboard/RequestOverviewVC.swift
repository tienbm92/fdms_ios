//
//  RequestOverviewVC.swift
//  FDMS
//
//  Created by Nguyen Quoc Tinh on 4/18/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

class RequestOverviewVC: UITableViewController {
    
    private var tableData: [SectionInfo] = [SectionInfo]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: kPieChartCell, bundle: nil), forCellReuseIdentifier: kPieChartCell)
        setupTableData()
    }
    
    private func setupTableData() {
        let chartSection = SectionInfo(titleForHeader: nil, heightForHeader: 1,
                                       heightForFooter: 1) { () -> ([CellInfo]) in
            let pieChartCell = CellInfo(indentifier: kPieChartCell, heightForRow: 320)
            var cells = [CellInfo]()
            cells.append(pieChartCell)
            return cells
        }
        let tableSection = SectionInfo(titleForHeader: "top.request".localized, heightForHeader: 36,
                                       heightForFooter: 36) { () -> ([CellInfo]) in
            let titleCell = CellInfo(indentifier: kTopRequestTitleCell, heightForRow: 50)
            let contentCell = CellInfo(indentifier: kTopRequestCell, heightForRow: 44)
            let contentCells = Array(repeatElement(contentCell, count: 5))
            var cells = [CellInfo]()
            cells.append(titleCell)
            cells.append(contentsOf: contentCells)                              
            return cells
        }
        tableData = [chartSection, tableSection]
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tableData.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData[section].cells.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = tableData[indexPath.section].cells[indexPath.row].indentifier ?? ""
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableData[section].titleForHeader
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableData[indexPath.section].cells[indexPath.row].heightForRow ?? 0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableData[section].heightForHeader ?? 0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return tableData[section].heightForFooter ?? 0
    }

}
