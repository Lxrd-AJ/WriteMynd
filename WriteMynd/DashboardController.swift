//
//  DashboardController.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 23/12/2015.
//  Copyright © 2015 The Leaf. All rights reserved.
//

import UIKit
import MMDrawerController
import Parse
import SwiftDate
import SnapKit

/**
 My Mynd Section. 
 - note
    Consider switching to ~~https://github.com/i-schuetz/SwiftCharts~~ especially for the line charts or
    use https://www.codebeaulieu.com/57/How-to-create-a-Line-Chart-using-ios-charts for the line charts | *http://www.appcoda.com/ios-charts-api-tutorial/
 */
class DashboardController: UIViewController {
    
    let topView = UIView()
    let middleView = UIView()
    let bottomView = UIView()
    
    let emojiPieChart = EmojiPieChart()
    let hashtagsPieCharts = HashTagsPieCharts()
    
    lazy var myHashTagsLabel: Label = {
        let label = Label()
        label.text = "My Hashtags"
        label.textColor = UIColor.wmCoolBlueColor()
        return label
    }()
    
    lazy var myEmojisLabel: Label = {
        let label = Label()
        label.text = "My Emojis"
        label.textColor = UIColor.wmCoolBlueColor()
        return label
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.wmBackgroundColor()
        
        self.view.addSubview(topView)
        self.view.addSubview(middleView)
        self.view.addSubview(bottomView)
        
        _ = [topView,middleView,bottomView].map({ $0.addBorder(edges: [.Bottom], colour: UIColor.wmSilverColor(), thickness: 0.9) })
        
        //MARK: - Top level view constraints
        topView.snp_makeConstraints(closure: { make in
            make.top.equalTo(self.view.snp_top)
            make.width.equalTo(self.view.snp_width)
            make.height.equalTo(200)
        })
        self.topView.addSubview(myHashTagsLabel)
        myHashTagsLabel.snp_makeConstraints(closure: { make in
            make.top.equalTo(topView.snp_top).offset(5)
            make.left.equalTo(topView.snp_left).offset(5)
        })
        self.topView.addSubview(hashtagsPieCharts)
        hashtagsPieCharts.snp_makeConstraints(closure: { make in
            make.width.equalTo(topView.snp_width)
            make.top.equalTo(myHashTagsLabel.snp_bottom)
            make.centerX.equalTo(topView.snp_centerX)
            make.height.equalTo(topView.snp_height).offset(-25)
        })
        //hashtagsPieCharts.backgroundColor = UIColor.wmSilverColor()
        //END MARK
        
        //MARK: Middle View Constraintse
        middleView.snp_makeConstraints(closure: { make in
            make.top.equalTo(topView.snp_bottom).offset(10)
            make.size.equalTo(topView.snp_size)
        })
        self.view.addSubview(myEmojisLabel)
        myEmojisLabel.snp_makeConstraints(closure: { make in
            make.top.equalTo(middleView.snp_top)
            make.left.equalTo(middleView.snp_left).offset(5)
        })
        self.view.addSubview(emojiPieChart)
        emojiPieChart.snp_makeConstraints(closure: { make in
            make.width.equalTo(middleView.snp_width)
            make.top.equalTo(myEmojisLabel.snp_bottom)
            make.centerX.equalTo(middleView.snp_centerX)
            make.height.equalTo(middleView.snp_height).offset(-25)
        })
        //emojiPieChart.backgroundColor = .wmSilverColor()
        //END MARK
        
        drawCharts()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func drawCharts(){
        ParseService.fetchPostsForUser(PFUser.currentUser()!, callback: { posts in
            guard posts.count != 0 else{ return }
            
            //Retrieve the hash tags data
            let hashTags = posts.reduce([], combine: { return $0 + $1.hashTags })
            var hashTagMap: [String:Int] = [:]
            for hashtag in hashTags {
                if let freq = hashTagMap[hashtag] { hashTagMap[hashtag] = freq + 1 }
                else{ hashTagMap[hashtag] = 1 }
            }
            
            //Retrieve the Emoji Data
            let emojiDictionary: [Emoji:Int] = posts.reduce([:], combine: { map,post in
                var _map = map
                if let count = map[post.emoji] { _map[post.emoji] = (count + 1)
                }else{ _map[post.emoji] = 1 }
                return _map
            });
            print(emojiDictionary)
            
            self.setupMaxHashTagsPieChart(hashTagMap)
            self.setupMinHashTagsPieChart(hashTagMap)
            self.setupEmojiPieChart(emojiDictionary)
        })
    }
}

extension DashboardController {
    func setupEmojiPieChart( dictionary:[Emoji:Int] ) {
        let dataKeys:[String] = dictionary.keys.map({ emoji in emoji.value().name })
        let dataValues:[Int] = dictionary.keys.map({ emoji in dictionary[emoji]! });
        let colors:[UIColor] = dictionary.keys.map({ emoji in emoji.value().color })
        emojiPieChart.renderChart(emojiPieChart.chart, dataPoints: dataKeys, values: dataValues, colors: colors)
    }
    
    func setupMaxHashTagsPieChart( hashTagMap:[String:Int] ){
        //Most Used HashTag
        let mostTags = ["Others", hashTagMap.max()]
        let maxTuple: (highest:Int, total:Int) = hashTagMap.maxTuple()
        let mostTagsData = [ Double((maxTuple.total - maxTuple.highest)), Double(maxTuple.highest)]
        hashtagsPieCharts.renderChart(hashtagsPieCharts.maxHashtagsPie, dataPoints: mostTags, values: mostTagsData, centerValue: hashTagMap.maxPercent(), tag: hashTagMap.max())
    }
    
    func setupMinHashTagsPieChart( hashTagMap:[String:Int] ){
        //Least Used HashTag
        let leastTags = ["Others", hashTagMap.min()]
        let minTuple: (lowest:Int, total:Int) = hashTagMap.minTuple()
        let leastTagsData = [ Double(minTuple.total - minTuple.lowest), Double(minTuple.lowest)]
        hashtagsPieCharts.renderChart(hashtagsPieCharts.minHashtagsPie, dataPoints: leastTags, values: leastTagsData, centerValue: hashTagMap.minPercent(), tag: hashTagMap.min())
    }
}

////            //Customise the Line Graph Section
////            self.emojiSegmentedControl.removeAllSegments()
////            //customise the line graph
////            self.lineChartView.backgroundColor = UIColor(red: 133/255, green: 97/255, blue: 166/255, alpha: 1.0)
////            self.lineChartView.drawGridBackgroundEnabled = false
////            self.lineChartView.scaleXEnabled = false; self.lineChartView.scaleYEnabled = false
////            self.lineChartView.pinchZoomEnabled = false
////            self.lineChartView.xAxis.valueFormatter = LineXAxis()
////            self.lineChartView.xAxis.drawGridLinesEnabled = false
////
////            //Draw the Line Chart for the emoji used over time
////            self.emojiMap = self.makeEmojiToDateCountDictionary(posts)
////            var i = 0;
////            for (emoji,_) in self.emojiMap! {
////                self.emojiSegmentedControl.insertSegmentWithTitle(String(emoji), atIndex: i, animated: false);
////                self.emojiSegmentedControl.setWidth(50.0, forSegmentAtIndex: i)
////                i++
////            }
////            self.emojiSegmentedControl.hidden = false
////            self.emojiSegmentedControl.selectedSegmentIndex = 0
////            self.emojiSegmentedControl.addTarget(self, action: #selector(DashboardController.emojiSegmentControlTapped(_:)), forControlEvents: .ValueChanged)
////            //print( self.emojiMap )
////            self.drawLineGraph((self.emojiMap?.keys.first!)!, map: self.emojiMap!)
////            print(self.lineGraphCanvas.frame.width)
////        })
//    }
//    

//    func drawLineGraph( emoji:Character, map:[Character: [NSDate:Int]] ){
//        var dataPoints:[String] = []; var values:[Double] = []
//        let data = map[emoji]
//        let dateFormat = DateFormat.Custom("dd/MM/yyyy")
//        for (date,count) in data! {
//            dataPoints.append(date.toString(dateFormat)!)
//            values.append( Double(count) )
//        }
//        setLineChart(dataPoints, values: values)
//    }
//    
//    func setLineChart( dataPoints:[String], values:[Double] ){
////        var dataEntries: [ChartDataEntry] = []
////        for i in 0..<dataPoints.count {
////            dataEntries.append( ChartDataEntry(value: values[i], xIndex: i) )
////        }
////        let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: "")
////        let lineChartData = LineChartData(xVals: dataPoints, dataSet: lineChartDataSet)
////        lineChartData.setValueFont(UIFont(name: "Avenir", size: 9))
////        lineChartView.data = lineChartData
//    }
//
//    
//    func makeEmojiToDateCountDictionary( posts:[Post] ) -> [Character: [NSDate:Int]] {
//        var emojiToDirtyDatesCount: [Character: [NSDate]] = [:]
//        for post in posts {
//            if let key = post.emoji.value().name.characters.first {
//                if emojiToDirtyDatesCount[key] != nil{ emojiToDirtyDatesCount[key]!.append(post.createdAt!) }
//                else { emojiToDirtyDatesCount[key] = [post.createdAt!] }
//            }
//        }
//        //print(emojiToDirtyDatesCount)
//        var emojiMap: [Character:[NSDate:Int]] = [:]
//        for (emoji,dates) in emojiToDirtyDatesCount { emojiMap[emoji] = makeDatesToCountDict(dates) }
//        return emojiMap
//    }
//    
//    func makeDatesToCountDict( dates:[NSDate] ) -> [NSDate:Int] {
//        let dateFormat = DateFormat.Custom("dd/MM/yyyy")
//        let result: [NSDate:Int] = dates.sort({ return $0 < $1 }).reduce([:], combine: { ( var dict:[NSDate:Int], date ) in
//            let key = date.toString(dateFormat)!.toDate(dateFormat)!
//            if dict[key] != nil { dict[key]! += 1 }
//            else{ dict[key] = 1 }
//            return dict
//        })
//        return result
//    }


