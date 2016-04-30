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
 */
class DashboardController: UIViewController {
    
    let topView = UIView()
    let middleView = UIView()
    let bottomView = UIView()
    
    let emojiPieChart = EmojiPieChart()
    let hashtagsPieCharts = HashTagsPieCharts()
    let swipeChart = SwipeChart()
    
    lazy var myHashTagsLabel: Label = {
        let label = Label()
        label.text = "My Themes"
        label.textColor = UIColor.wmCoolBlueColor()
        return label
    }()
    
    lazy var myEmojisLabel: Label = {
        let label = Label()
        label.text = "My Emotions"
        label.textColor = UIColor.wmCoolBlueColor()
        return label
    }()
    
    lazy var swipeLabel: Label = {
        let label = Label()
        label.text = "My moods"
        label.textColor = UIColor.wmCoolBlueColor()
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.wmBackgroundColor()
        self.view.userInteractionEnabled = true 
        
        self.view.addSubview(topView)
        self.view.addSubview(middleView)
        self.view.addSubview(bottomView)
        
        _ = [topView,middleView].map({ $0.addBorder(edges: [.Bottom], colour: UIColor.wmSilverColor(), thickness: 0.9) })
        middleView.userInteractionEnabled = true
        
        drawCharts()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.view.setNeedsLayout()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**
     - todo:
        [ ] Refactor to use UIStackViews 🔨
     */
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
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
        let hashTagInfoButton = self.moreInfoButton()
        //self.topView.addSubview(hashTagInfoButton)
        hashTagInfoButton.tag = 0
//        hashTagInfoButton.snp_makeConstraints(closure: {make in
//            make.top.equalTo(myHashTagsLabel.snp_top)
//            make.right.equalTo(topView.snp_right).offset(-5)
//        })
        //END MARK
        
        //MARK: Middle View Constraints
        middleView.userInteractionEnabled = true
        middleView.snp_makeConstraints(closure: { make in
            make.top.equalTo(topView.snp_bottom).offset(10)
            make.size.equalTo(topView.snp_size)
        })
        middleView.addSubview(myEmojisLabel)
        myEmojisLabel.snp_makeConstraints(closure: { make in
            make.top.equalTo(middleView.snp_top)
            make.left.equalTo(middleView.snp_left).offset(5)
        })
        middleView.addSubview(emojiPieChart)
        emojiPieChart.snp_makeConstraints(closure: { make in
            make.width.equalTo(middleView.snp_width)
            make.top.equalTo(myEmojisLabel.snp_bottom)
            make.centerX.equalTo(middleView.snp_centerX)
            make.height.equalTo(middleView.snp_height).offset(-25)
        })
        let pieChartInfoButton = self.moreInfoButton()
        pieChartInfoButton.tag = 1
        //self.middleView.addSubview(pieChartInfoButton)
//        pieChartInfoButton.snp_makeConstraints(closure: { make in
//            make.top.equalTo(myEmojisLabel.snp_top)
//            make.right.equalTo(middleView.snp_right).offset(-5)
//        })
        //END MARK
        
        //MARK: Bottom View Constraints
        bottomView.snp_makeConstraints(closure: { make in
            make.top.equalTo(middleView.snp_bottom).offset(10)
            make.size.equalTo(middleView.snp_size)
            make.centerX.equalTo(self.view.snp_centerX)
        })
        bottomView.addSubview(swipeLabel)
        swipeLabel.snp_makeConstraints(closure: { make in
            make.top.equalTo(bottomView.snp_top)
            make.left.equalTo(bottomView.snp_left).offset(5)
        })
        bottomView.addSubview(swipeChart)
        swipeChart.snp_makeConstraints(closure: { make in
            make.width.equalTo(bottomView.snp_width)
            make.top.equalTo(swipeLabel.snp_bottom).offset(15)
            make.centerX.equalTo(bottomView.snp_centerX)
            make.height.equalTo(bottomView.snp_height).offset(-25)
        })
        let swipeInfoButton = self.moreInfoButton()
        swipeInfoButton.tag = 2
        //self.bottomView.addSubview(swipeInfoButton)
//        swipeInfoButton.snp_makeConstraints(closure: { make in
//            make.top.equalTo(swipeLabel.snp_top)
//            make.right.equalTo(bottomView.snp_right).offset(-5)
//        })
        //END MARK
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
            //print(emojiDictionary)
            
            self.setupMaxHashTagsPieChart(hashTagMap)
            self.setupMinHashTagsPieChart(hashTagMap)
            self.setupEmojiPieChart(emojiDictionary)
        })
        
        //Line Graph for Swipes
        ParseService.getSwipesForUser(PFUser.currentUser()!, callback: { swipes in
            guard swipes.count != 0 else{ return }
            
            let dateFormat = DateFormat.Custom("dd/MM/yyyy")
            let swipeDictionary: [NSDate:[Swipe]] = swipes.reduce([:], combine: { map, swipe in
                var _map = map
                let key = swipe.createdAt.toString(dateFormat)!.toDate(dateFormat)!
                if let swipes = map[key] {
                    _map[key] = swipes + [swipe]
                }else{
                    _map[key] = [swipe]
                }
                return _map
            })
         
            self.setupSwipeChart(swipeDictionary)
        })
    }
}

extension DashboardController {
    
    func setupSwipeChart( dictionary:[NSDate:[Swipe]] ){
        //- note: Reversing the dictionary keys & values because the sortBy on the query isn't working
        let dataKeys: [String] = dictionary.keys.map({ $0.toString()! }).reverse()
        let dataValues: [Double] = dictionary.keys.map({ self.averageScoreFor(dictionary[$0]!) }).reverse()
        swipeChart.renderChart(dataKeys, values: dataValues)
    }
    
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

extension DashboardController {
    func moreInfoButtonTapped( sender:UIButton ){
        print("Button Touched")
        print("Button tapped \(sender.tag)")
    }
}

/**
 Utility functions
 */
extension DashboardController {
    func moreInfoButton() -> UIButton {
        let button = UIButton(type: .Custom);
        button.setImage(UIImage(named: "info"), forState: .Normal)
        //button.backgroundColor = .redColor()
        //button.setTitle("Info", forState: .Normal)
        button.setTitleColor(.redColor(), forState: .Normal)
        button.imageView?.userInteractionEnabled = false
        button.userInteractionEnabled = true
        button.addTarget(self, action: .infoButtonTapped, forControlEvents: .TouchUpInside)
        button.snp_makeConstraints(closure: {make in
            make.width.equalTo(20)
            make.height.equalTo(20)
        })
        return button;
    }
    
    func averageScoreFor( swipes:[Swipe] ) -> Double {
        let total = swipes.reduce(0, combine: { (total,cur) in
            return total + cur.value
        })
        return (Double(total)/Double(swipes.count))
    }
}

private extension Selector {
    static let infoButtonTapped = #selector(DashboardController.moreInfoButtonTapped(_:))
}