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
        
        maxHashtagsPie.noDataText = "Max.."
        minHashtagsPie.noDataText = "Min.."
        
        self.addSubview(maxHashtagsPie)
        self.addSubview(minHashtagsPie)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        maxHashtagsPie.snp_makeConstraints(closure: { make in
            make.top.equalTo(self.snp_top)
            make.width.equalTo(self.snp_width).multipliedBy(0.5)
            make.height.equalTo(self.snp_height)
            make.left.equalTo(self.snp_left)
        })
        
        minHashtagsPie.snp_makeConstraints(closure: { make in
            make.size.equalTo(maxHashtagsPie)
            make.top.equalTo(self.snp_top)
            make.right.equalTo(self.snp_right)
        })
    }
    
    func renderChart( pieChart:PieChartView, dataPoints:[String], values:[Double],centerValue:Int, tag:String ){
        guard values.count > 0 else{ pieChart.noDataText = "No tags yet!"; return }
        
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "");
        let chartData = PieChartData(xVals: dataPoints, dataSets: [pieChartDataSet])
        pieChartDataSet.colors = [UIColor.wmSlateGreyColor(),UIColor.wmGreenishTealColor()]
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
        pieChart.descriptionTextPosition = CGPointZero
        pieChart.legend.enabled = false
        pieChart.userInteractionEnabled = false
        pieChart.animate(xAxisDuration: 1, yAxisDuration: 1, easingOption: .EaseInOutCirc)

    }

}


