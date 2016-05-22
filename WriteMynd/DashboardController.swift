//
//  DashboardController.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 20/05/2016.
//  Copyright © 2016 The Leaf. All rights reserved.
//

import UIKit
import Parse
import SwiftDate
import SnapKit
import Charts

class DashboardController: UIViewController {
    
    typealias HashTag = String
    
    var emojiHashTagDictionary: [Emoji:[HashTag:Int]] = [:]
    
    let topView = UIView()
    let middleView = UIView()
    let bottomView = UIView()

    let stackView = UIStackView()
    let scrollView = UIScrollView()
    
    let emojiPieChart = EmojiPieChart()
    let hashtagsPieCharts = HashTagsPieCharts()
    let swipeChart = SwipeChart()
    
    lazy var hashTagInfoButton: UIButton = { return self.moreInfoButton() }()
    lazy var emojiInfoButton: UIButton = { return self.moreInfoButton() }()
    lazy var swipeInfoButton: UIButton = { return self.moreInfoButton() }()
    
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

        self.automaticallyAdjustsScrollViewInsets = false
        self.scrollView.contentSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.height )
        emojiPieChart.chart.delegate = self
        stackView.axis = .Vertical
        stackView.alignment = .Fill
        stackView.distribution = .FillEqually
        
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(stackView)
    
        self.stackView.addArrangedSubview(topView)
        self.stackView.addArrangedSubview(middleView)
        self.stackView.addArrangedSubview(bottomView)

        self.topView.addSubview(myHashTagsLabel)
        self.topView.addSubview(hashTagInfoButton)
        self.topView.addSubview(hashtagsPieCharts)
        self.middleView.addSubview(myEmojisLabel)
        self.middleView.addSubview(emojiPieChart)
        self.middleView.addSubview(emojiInfoButton)
        self.bottomView.addSubview(swipeLabel)
        self.bottomView.addSubview(swipeChart)
        self.bottomView.addSubview(swipeInfoButton)
        
        _ = [topView,middleView].map({ $0.addBorder(edges: [.Bottom], colour: UIColor.wmSilverColor(), thickness: 0.9) })

        hashTagInfoButton.tag = 0
        emojiInfoButton.tag = 1
        swipeInfoButton.tag = 2
        drawCharts()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let infoButtonConstraint = { (make: ConstraintMaker, v:UIView) -> Void in
            make.top.equalTo(v.snp_top).offset(5)
            make.right.equalTo(v.snp_right).offset(-5)
        }
        let labelConstraint = { (make:ConstraintMaker,v:UIView) -> Void in
            make.top.equalTo(v.snp_top).offset(5)
            make.left.equalTo(v.snp_left).offset(5)
        }
        
        scrollView.snp_makeConstraints(closure: { make in
            make.centerX.equalTo(self.view.snp_centerX)
            make.top.equalTo(self.view.snp_top)
            make.bottom.equalTo(self.stackView.snp_bottom)
            make.size.equalTo(self.view.snp_size)
        })
        
        stackView.snp_makeConstraints(closure: { make in
            make.width.equalTo(self.view.snp_width)
            make.top.equalTo(self.scrollView.snp_top)
            make.right.equalTo(self.view.snp_right)
            make.height.equalTo(700)
        })
        
        myHashTagsLabel.snp_makeConstraints(closure: { make in labelConstraint(make,topView) })
        hashTagInfoButton.snp_makeConstraints(closure: { make in infoButtonConstraint(make,topView) })
        hashtagsPieCharts.snp_makeConstraints(closure: { make in
            make.width.equalTo(topView.snp_width)
            make.top.equalTo(hashTagInfoButton.snp_bottom)
            make.centerX.equalTo(topView.snp_centerX)
            make.bottom.equalTo(topView.snp_bottom).offset(-20)
        })
        
        myEmojisLabel.snp_makeConstraints(closure: { make in labelConstraint(make,middleView) })
        emojiInfoButton.snp_makeConstraints(closure: { make in infoButtonConstraint(make, middleView) })
        emojiPieChart.snp_makeConstraints(closure: { make in
            make.width.equalTo(middleView.snp_width)
            make.top.equalTo(emojiInfoButton.snp_bottom)
            make.centerX.equalTo(middleView.snp_centerX)
            make.bottom.equalTo(middleView.snp_bottom).offset(-20)
        })
        
        swipeLabel.snp_makeConstraints(closure: { make in labelConstraint(make,bottomView) })
        swipeInfoButton.snp_makeConstraints(closure: { make in infoButtonConstraint(make,bottomView) })
        swipeChart.snp_makeConstraints(closure: { make in
            make.width.equalTo(bottomView.snp_width)
            make.top.equalTo(swipeInfoButton.snp_bottom).offset(15)
            make.centerX.equalTo(bottomView.snp_centerX)
            make.bottom.equalTo(bottomView.snp_bottom).offset(-20)
        })
    }
    
    func moreInfoButtonTapped( sender:UIButton ){
        var infoMessage = ""
        var containerView:UIView!
        
        switch sender.tag {
        case 0:
            //My hashtags
            self.myHashTagsLabel.hidden = !self.myHashTagsLabel.hidden
            containerView = self.topView
            infoMessage = "What you’re posting about most and least according to the hashtags you’ve used"
        case 1:
            infoMessage = "How you’re feeling  and what you’re writing  about according to the emotion buttons you’ve selected"
            self.myEmojisLabel.hidden = !self.myEmojisLabel.hidden
            containerView = self.middleView
        case 2:
            infoMessage = "How positive or negative you’re feeling  over time according to the words you’ve swiped through"
            self.swipeLabel.hidden = !self.swipeLabel.hidden
            containerView = self.bottomView
        default:
            containerView = UIView()
            break;
        }
        
        if !sender.selected {
            sender.selected = true
            sender.backgroundColor = UIColor.wmCoolBlueColor()
            sender.setTitle(infoMessage, forState: .Normal)
            sender.snp_updateConstraints(closure: { make in
                make.width.equalTo(self.view.snp_width).offset(-10)
                make.height.equalTo(20)
            })
        }else{
            sender.selected = false
            sender.backgroundColor = UIColor.clearColor()
            //sender.snp_removeConstraints()
            sender.setTitle("", forState: .Normal)
            sender.snp_remakeConstraints(closure: { make in
                //make.width.equalTo(15)
                make.top.equalTo(containerView.snp_top).offset(5)
                make.right.equalTo(containerView.snp_right).offset(-5)
            })
        }
    }

}

extension DashboardController {
    func drawCharts(){
        func createHashTagMap( hashtags:[String], map:[HashTag:Int] ) -> [HashTag:Int] {
            var _map = map;
            for hashtag in hashtags {
                if let freq = _map[hashtag] { _map[hashtag] = freq + 1 }
                else{ _map[hashtag] = 1 }
            }
            return _map
        }
        
        ParseService.fetchPostsForUser(PFUser.currentUser()!, callback: { posts in
            guard posts.count != 0 else{ return }
            
            // Emoji - HashTag - Count
            self.emojiHashTagDictionary = posts.reduce([:], combine: { map,post in
                var _map = map;
                if let hashTags = _map[post.emoji] {
                    _map[post.emoji] = createHashTagMap(post.hashTags, map: hashTags)
                }else{
                    _map[post.emoji] = createHashTagMap(post.hashTags, map: [:])
                }
                return _map;
            })
            
            //Retrieve the hash tags data
            let postHashTags = posts.reduce([], combine: { return $0 + $1.hashTags })
            let hashTagMap: [HashTag:Int] = createHashTagMap(postHashTags, map: [:])
            
            //Retrieve the Emoji Data
            let emojiCountDictionary: [Emoji:Int] = self.emojiHashTagDictionary.keys.reduce([:], combine: {map, emoji in
                var _map = map;
                _map[emoji] = self.emojiHashTagDictionary[emoji]!.values.reduce(0, combine: +)
                return _map;
            })
            
            self.setupMaxHashTagsPieChart(hashTagMap)
            self.setupMinHashTagsPieChart(hashTagMap)
            self.setupEmojiPieChart(emojiCountDictionary)
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
    
    /**
     Draws the second pie chart. The pie chart with the second most used hashtag, if there isn't enough data
     It displays the least used hashtag instead
     - todo: Needs refactoring as this method is not elegant enough
     - parameter hashTagMap: a dictionary of the hashtags to their frequency
     */
    func setupMinHashTagsPieChart( hashTagMap:[String:Int] ){
        //Least Used HashTag
        let tags = hashTagMap.keys().sort({ s1,s2 in return hashTagMap[s1]! > hashTagMap[s2]! })
        let total = hashTagMap.values.reduce(0, combine: +)
        let minTuple: (lowest:Int, total:Int) = hashTagMap.minTuple()
        var tag = hashTagMap.min()
        var count = minTuple.lowest
        
        if tags.count >= 2 {
            tag = tags[1]
            count = Int((Float(hashTagMap[tag]!) / Float(total)) * Float(100))
        }
        
        print(tag)
        print(count)
        
        let leastTags = ["Others", tag]
        let leastTagsData = [ Double(total - count), Double(count)]
        
        hashtagsPieCharts.renderChart(hashtagsPieCharts.minHashtagsPie, dataPoints: leastTags, values: leastTagsData, centerValue: count, tag: tag)
    }
    
    func averageScoreFor( swipes:[Swipe] ) -> Double {
        let total = swipes.reduce(0, combine: { (total,cur) in
            return total + cur.value
        })
        return (Double(total)/Double(swipes.count))
    }
    
    func moreInfoButton() -> UIButton {
        let button = UIButton(type: .Custom);
        button.setImage(UIImage(named: "info"), forState: .Normal)
        button.addTarget(self, action: .infoButtonTapped, forControlEvents: .TouchUpInside)
        button.titleLabel?.font = Label.font().fontWithSize(9)
        button.setTitleColor(.whiteColor(), forState: .Normal)
        button.titleLabel?.numberOfLines = 0
        button.layer.cornerRadius = 5.0
        return button;
    }

}

extension DashboardController: ChartViewDelegate {
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        let emoji = Emoji.toEnum(entry.data! as! String)
        let detailVC = EmojiChartDetailViewController()
        detailVC.emoji = emoji
        detailVC.hashTags = self.emojiHashTagDictionary[emoji]
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

private extension Selector {
    static let infoButtonTapped = #selector(DashboardController.moreInfoButtonTapped(_:))
}