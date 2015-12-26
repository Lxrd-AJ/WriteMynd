//
//  DashboardController.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 23/12/2015.
//  Copyright © 2015 The Leaf. All rights reserved.
//

import UIKit
import MMDrawerController
import Charts

class DashboardController: UIViewController {
    
    @IBOutlet weak var maxPieChartCanvas: UIView!
    @IBOutlet weak var maxHashTag: UILabel!
    @IBOutlet weak var minPieChartCanvas: UIView!
    @IBOutlet weak var minHashTag: UILabel!
    @IBOutlet weak var lineGraphCanvas: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Hide the layering colors from storyboard
        maxPieChartCanvas.backgroundColor = UIColor.whiteColor()
        minPieChartCanvas.backgroundColor = UIColor.whiteColor()
        
        //Charts Customization
        let maxPieChart: PieChartView = PieChartView(frame: CGRect(x:maxPieChartCanvas.frame.origin.x, y: maxPieChartCanvas.frame.origin.y, width: 200, height: 200 ))
        let minPieChart: PieChartView = PieChartView(frame: CGRect(x:minPieChartCanvas.bounds.origin.x, y: minPieChartCanvas.frame.origin.y, width: 200, height: 200 ))
        maxPieChartCanvas.addSubview(maxPieChart)
        minPieChartCanvas.addSubview(minPieChart)
        maxPieChart.noDataText = "Make lots of similar tags"
        minPieChart.noDataText = "Be together, not the same"
        
        //Test
        let maxTag = ["Others","Family"]
        let maxTagsData = [4.0,6.0]
        setPieChart(dataPoints: maxTag, values: maxTagsData, pieChart: maxPieChart)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setPieChart( dataPoints dataPoints: [String], values: [Double], pieChart: PieChartView ) {
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries)
        let chartData = PieChartData(xVals: dataPoints, dataSets: [pieChartDataSet])
        pieChartDataSet.colors = [UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1),UIColor(red: 99/255, green: 60/255, blue: 134/255, alpha: 1)]
        //pieChartDataSet.highlightEnabled = false
        pieChartDataSet.drawValuesEnabled = false
        //pieChartDataSet.selectionShift = 9.0
        //chartData.highlightEnabled = false
        pieChart.data = chartData
        pieChart.drawSliceTextEnabled = false
        pieChart.usePercentValuesEnabled = true
        pieChart.centerText = "69%" //345-346
        pieChart.holeRadiusPercent = 0.8
        pieChart.centerTextRadiusPercent = 1
        pieChart.descriptionTextPosition = CGPointZero
        pieChart.legend.enabled = false
        pieChart.userInteractionEnabled = false
    }
    
    @IBAction func showMenu( sender: UIBarButtonItem ){
        self.mm_drawerController.toggleDrawerSide(.Left, animated: true, completion: nil)
    }
    
}
