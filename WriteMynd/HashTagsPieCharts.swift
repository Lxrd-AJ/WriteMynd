//
//  HashTagsPieCharts.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 04/04/2016.
//  Copyright © 2016 The Leaf. All rights reserved.
//

import UIKit
import Charts

class HashTagsPieCharts: UIView {

    let maxHashtagsPie = PieChartView()
    let minHashtagsPie = PieChartView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        maxHashtagsPie.noDataText = "Nothing here yet"
        //maxHashtagsPie.infoFont = Label.font().fontWithSize(11)
        minHashtagsPie.noDataText = "\tWrite a post to\nstart populating this chart"
        //minHashtagsPie.infoFont = Label.font().fontWithSize(11)

        self.addSubview(maxHashtagsPie)
        self.addSubview(minHashtagsPie)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        maxHashtagsPie.snp.makeConstraints({ make in
            make.top.equalTo(self.snp.top)
            make.width.equalTo(self.snp.width).multipliedBy(0.5)
            make.height.equalTo(self.snp.height)
            make.left.equalTo(self.snp.left)
        })

        minHashtagsPie.snp.makeConstraints({ make in
            make.size.equalTo(maxHashtagsPie)
            make.top.equalTo(self.snp.top)
            make.right.equalTo(self.snp.right)
        })
    }

    func renderChart( _ pieChart: PieChartView, dataPoints: [String], values: [Double], centerValue: Int, tag: String) {
        guard values.count > 0 else { pieChart.noDataText = "No tags yet!"; return }

        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: values[i], y: Double(i))
            dataEntries.append(dataEntry)
        }
        let pieChartDataSet = PieChartDataSet(values: dataEntries, label: "");
        let chartData = PieChartData(dataSets: [pieChartDataSet])
        pieChartDataSet.colors = [UIColor.wmSlateGreyColor(), UIColor.wmGreenishTealColor()]
        //pieChartDataSet.highlightEnabled = false
        pieChartDataSet.drawValuesEnabled = false
        //pieChartDataSet.selectionShift = 9.0
        //chartData.highlightEnabled = false
        pieChart.data = chartData
        pieChart.drawSliceTextEnabled = false
        pieChart.usePercentValuesEnabled = true
        pieChart.centerText = "\(centerValue)%\n\(tag)" //345-346
        pieChart.holeRadiusPercent = 0.6
        pieChart.centerTextRadiusPercent = 1
        pieChart.descriptionTextPosition = CGPoint.zero
        pieChart.legend.enabled = false
        pieChart.isUserInteractionEnabled = false
        pieChart.animate(xAxisDuration: 1, yAxisDuration: 1, easingOption: .easeInOutCirc)

    }

}


