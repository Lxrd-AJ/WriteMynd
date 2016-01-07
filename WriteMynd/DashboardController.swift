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
import Parse
import SwiftDate

class DashboardController: UIViewController {
    
    @IBOutlet weak var maxPieChartCanvas: UIView!
    @IBOutlet weak var maxHashTag: UILabel!
    @IBOutlet weak var minPieChartCanvas: UIView!
    @IBOutlet weak var minHashTag: UILabel!
    @IBOutlet weak var lineGraphCanvas: UIView!
    @IBOutlet weak var mostUsedHashTag: UILabel!
    @IBOutlet weak var leastUsedHashTag: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Hide the layering colors from storyboard
        maxPieChartCanvas.backgroundColor = UIColor.whiteColor()
        minPieChartCanvas.backgroundColor = UIColor.whiteColor()
        mostUsedHashTag.text = "-"
        leastUsedHashTag.text = "-"
        
        //Charts Customization
        let maxPieChart: PieChartView = PieChartView(frame: CGRect(x:maxPieChartCanvas.frame.origin.x, y: maxPieChartCanvas.frame.origin.y, width: 200, height: 200 ))
        let minPieChart: PieChartView = PieChartView(frame: CGRect(x:minPieChartCanvas.bounds.origin.x, y: minPieChartCanvas.frame.origin.y, width: 200, height: 200 ))
        maxPieChartCanvas.addSubview(maxPieChart)
        minPieChartCanvas.addSubview(minPieChart)
        maxPieChart.noDataText = "Thinking...."
        minPieChart.noDataText = "Be together, not the same"
        
        ParseService.fetchPostsForUser(PFUser.currentUser()!, callback: { (posts:[Post]) -> Void in
            let hashTags = posts.reduce([], combine: { return $0 + $1.hashTags })
            var hashTagMap: [String:Int] = [:]
            for hashtag in hashTags {
                if let freq = hashTagMap[hashtag] { hashTagMap[hashtag] = freq + 1 }
                else{ hashTagMap[hashtag] = 1 }
            }
            
            //Draw the Pie Charts for most used hashTags and LeastUsedHashTags
            //Most Used HashTag
            let mostTags = ["Others", hashTagMap.max()]
            let maxTuple: (highest:Int, total:Int) = hashTagMap.maxTuple()
            let mostTagsData = [ Double((maxTuple.total - maxTuple.highest)), Double(maxTuple.highest)]
            self.setPieChart(dataPoints: mostTags, values: mostTagsData, pieChart: maxPieChart, centerValue: hashTagMap.maxPercent())
            self.maxHashTag.text = hashTagMap.max()
            
            //Least Used HashTag
            let leastTags = ["Others", hashTagMap.min()]
            let minTuple: (lowest:Int, total:Int) = hashTagMap.minTuple()
            let leastTagsData = [ Double(minTuple.total - minTuple.lowest), Double(minTuple.lowest)]
            self.setPieChart(dataPoints: leastTags, values: leastTagsData, pieChart: minPieChart, centerValue: hashTagMap.minPercent())
            self.minHashTag.text = hashTagMap.min()
            
            
            //Draw the Line Chart for the emoji used over time
            let _ = self.makeEmojiToDateCountDictionary(posts)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func makeEmojiToDateCountDictionary( posts:[Post] ) -> [Character: [NSDate:Int]] {
        var emojiToDirtyDatesCount: [Character: [NSDate]] = [:]
        for post in posts {
            let key = post.emoji.characters.first!
            if var arr = emojiToDirtyDatesCount[key] { arr.append(post.createdAt!); emojiToDirtyDatesCount[key] = arr; }
            else { emojiToDirtyDatesCount[key] = [post.createdAt!] }
        }
        print(emojiToDirtyDatesCount)
        return [:] //DELETE
    }
    
//    func makeDatesToCountDict( dates:[NSDate] ) -> [NSDate:Int] {
//        let dateFormat = DateFormat.Custom("dd/MM/yyyy")
//        var result: [NSDate:Int] = dates.reduce([:], combine: { ( dict:[NSDate:Int], date ) in
//            //let key = Date
//        })
//    }
    
    func setPieChart( dataPoints dataPoints: [String], values: [Double], pieChart: PieChartView, centerValue: Int ) {
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
        pieChart.centerText = "\(centerValue)%" //345-346
        pieChart.holeRadiusPercent = 0.8
        pieChart.centerTextRadiusPercent = 1
        pieChart.descriptionTextPosition = CGPointZero
        pieChart.legend.enabled = false
        pieChart.userInteractionEnabled = false
        pieChart.animate(xAxisDuration: 1, yAxisDuration: 1, easingOption: .EaseInOutCirc)
    }
    
    @IBAction func showMenu( sender: UIBarButtonItem ){
        self.mm_drawerController.toggleDrawerSide(.Left, animated: true, completion: nil)
    }
    
}
