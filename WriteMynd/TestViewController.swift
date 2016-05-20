//
//  TestViewController.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 20/05/2016.
//  Copyright © 2016 The Leaf. All rights reserved.
//

import UIKit
import Parse
import SwiftDate
import SnapKit

class TestViewController: UIViewController {
    
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


//        print("Scroll View = \(scrollView.frame)")
//        print("Stack view = \(stackView.frame)")
    }
    
    func moreInfoButtonTapped( sender:UIButton ){
        print("Button Touched")
        print("Button tapped \(sender.tag)")
    }

}

extension TestViewController {
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
        return button;
    }

}

private extension Selector {
    static let infoButtonTapped = #selector(TestViewController.moreInfoButtonTapped(_:))
}