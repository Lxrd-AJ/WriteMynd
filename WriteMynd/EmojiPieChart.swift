//
//  EmojiPieChart.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 05/04/2016.
//  Copyright © 2016 The Leaf. All rights reserved.
//

import UIKit
import Charts

class EmojiPieChart: UIView {

    let chart = PieChartView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        chart.noDataText = "Write a post to start populating this chart";
        //chart.noDataFont = chart.entryLabelFont = Label.font().withSize(11);
        self.addSubview(chart)
        
        chart.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init not implemented bruh")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        chart.snp.makeConstraints({ make in
            make.size.equalTo(self.snp.size).inset(UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
            make.center.equalTo(self.snp.center)
        })
    }
    
    func renderChart( _ chart:PieChartView, dataPoints:[String], values:[Int], colors:[UIColor] ){
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(values[i]), y: Double(i))
            dataEntry.data = dataPoints[i] as AnyObject?
            dataEntries.append(dataEntry)
        }
        let pieChartDataSet = PieChartDataSet(values: dataEntries, label: "");
        let chartData = PieChartData(dataSets: [pieChartDataSet])//PieChartData(xVals: dataPoints, dataSets: [pieChartDataSet])
        pieChartDataSet.colors = colors
        pieChartDataSet.highlightEnabled = false
        pieChartDataSet.drawValuesEnabled = false
        pieChartDataSet.selectionShift = 9.0
        chartData.highlightEnabled = true
        chart.drawSliceTextEnabled = false
        chart.usePercentValuesEnabled = true
        chart.holeRadiusPercent = 0.7
//        chart.centerTextRadiusPercent = 1
        chart.descriptionTextPosition = CGPoint.zero
        chart.legend.enabled = true
        chart.legend.position = .rightOfChartCenter
        
        chart.legend.form = .circle
        chart.legend.font = Label.font()
        chart.legend.xOffset = 30.0
        //chart.legend.yOffset = 60.0
        //chart.legend.yEntrySpace = -50
        //chart.legend.maxSizePercent = 0.3
        chart.data = chartData
        
        chart.animate(xAxisDuration: 1, yAxisDuration: 1, easingOption: .easeInOutCirc)
    }

}
