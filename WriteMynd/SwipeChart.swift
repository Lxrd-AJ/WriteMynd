//
//  SwipeChart.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 10/04/2016.
//  Copyright © 2016 The Leaf. All rights reserved.
//

import UIKit
import Charts

class SwipeChart: UIView {

    let lineChart = LineChartView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        lineChart.noDataText = "Swipe a post to start populating this graph"
        lineChart.infoFont = Label.font().fontWithSize(11)
        lineChart.backgroundColor = UIColor.clearColor()
        lineChart.layer.cornerRadius = 6.0
        lineChart.legend.enabled = false
        lineChart.xAxis.enabled = false
        lineChart.rightAxis.enabled = false
        lineChart.leftAxis.enabled = false
        lineChart.descriptionText = ""
        lineChart.leftAxis.axisMaxValue = 10.0
        lineChart.leftAxis.axisMinValue = -10.0
        lineChart.userInteractionEnabled = false
        
        self.addSubview(lineChart)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        lineChart.snp_makeConstraints(closure: { make in
            //make.size.equalTo(self.snp_size).inset(UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20))
            make.center.equalTo(self.snp_center)
            make.top.equalTo(self.snp_top)
            make.width.equalTo(self.snp_width).offset(-10)
            make.bottom.equalTo(self.snp_bottom)
        })
    }
    
    func renderChart( _ dataPoints:[String], values:[Double] ){
        guard values.count > 0 else{ lineChart.noDataText = "No Swipes!, yet"; return }
        //Data Entries
        var yVals = [ChartDataEntry]()
        for i in 0..<dataPoints.count {
            yVals.append(ChartDataEntry(value: values[i], xIndex: i))
        }
        
        //Date Set 
        let set = LineChartDataSet(yVals: yVals, label: "Mood over time")
        set.axisDependency = .Left
        set.setCircleColor(UIColor.wmGreenishTealColor())
        //set.setColor(UIColor.whiteColor())
        set.setColor(UIColor.wmGreenishTealColor())
        set.lineWidth = 2.0
        set.circleRadius = 3.5
        set.circleHoleColor = UIColor.whiteColor()//UIColor.wmGreenishTealColor()
        set.valueTextColor = UIColor.clearColor()
        
        //Array of Line Chart Data sets 
        let datasets = [set]
        
        //X-axis label for the datasets 
        let data = LineChartData(xVals: dataPoints, dataSets: datasets)
        
        //Limitline 
        let limitLine = ChartLimitLine(limit: 0.0)
        limitLine.lineColor = UIColor.wmGreenishTealColor()//UIColor.whiteColor()
        limitLine.lineWidth = 2.0
        self.lineChart.leftAxis.addLimitLine(limitLine)
        
        self.lineChart.data = data;
        self.lineChart.animate(xAxisDuration: 1, yAxisDuration: 1, easingOption: .EaseInOutSine)
    }
}
