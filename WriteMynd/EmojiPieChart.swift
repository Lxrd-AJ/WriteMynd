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
        
        chart.noDataText = "Thinking"
        self.addSubview(chart)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init not implemented bruh")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        chart.snp_makeConstraints(closure: { make in
            make.size.equalTo(self.snp_size).inset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
            make.center.equalTo(self.snp_center)
        })
    }
    
    func renderChart( chart:PieChartView, dataPoints:[String], values:[Int], colors:[UIColor] ){
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: Double(values[i]), xIndex: i)
            dataEntries.append(dataEntry)
        }
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "");
        let chartData = PieChartData(xVals: dataPoints, dataSets: [pieChartDataSet])
        pieChartDataSet.colors = colors
        //pieChartDataSet.highlightEnabled = false
        pieChartDataSet.drawValuesEnabled = false
        //pieChartDataSet.selectionShift = 9.0
        //chartData.highlightEnabled = false
        chart.data = chartData
        chart.drawSliceTextEnabled = false
        chart.usePercentValuesEnabled = true
        chart.holeRadiusPercent = 0.7
//        chart.centerTextRadiusPercent = 1
        chart.descriptionTextPosition = CGPointZero
        chart.legend.enabled = true
        chart.legend.position = .RightOfChartCenter
        chart.legend.form = .Circle
        chart.legend.font = Label.font()
        chart.legend.xOffset = 20.0
        chart.legend.maxSizePercent = 0.3
        
        chart.userInteractionEnabled = false
        chart.animate(xAxisDuration: 1, yAxisDuration: 1, easingOption: .EaseInOutCirc)
        
    }

}
