//
//  PieChartCell.swift
//  FDMS
//
//  Created by Nguyen Quoc Tinh on 4/18/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import Charts
import UIKit

class PieChartCell: UITableViewCell {

    @IBOutlet private weak var pieChartView: PieChartView!
    private var dashboard: [Dashboard] = [Dashboard]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setValueForCell(_ dashboads: [Dashboard]) {
        self.dashboard = dashboads
        setupPieChart()
    }
    
    private func setupPieChart() {
        var pieArray = [ChartDataEntry]()
        var color = [UIColor]()
        let labelPieChart = DeviceService.shared.percentageForDashboard(self.dashboard)
        for index in 0..<self.dashboard.count {
            let data = PieChartDataEntry(value: Double(self.dashboard[index].count), label: labelPieChart[index])
            pieArray.append(data)
            if let backgroundColor = self.dashboard[index].backgroundColor {
                color.append(backgroundColor)
            }
        }
        let pieDataSet = PieChartDataSet(values: pieArray, label: "")
        pieDataSet.colors = color
        let pieData = PieChartData(dataSet: pieDataSet as IChartDataSet)
        pieChartView.data = pieData
        pieChartView.animate(xAxisDuration: 0.5, yAxisDuration: 0.5, easingOption: .easeInCirc)
        pieChartView.chartDescription?.enabled = false
        pieChartView.usePercentValuesEnabled = false
        pieChartView.data?.setValueTextColor(UIColor.clear)
    }
    
}
