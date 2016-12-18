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

/// - todo [ ]: Consider using a table view instead of dividing it into 3 tier sections
class DashboardController: ViewController {

    typealias HashTag = String

    var emojiHashTagDictionary: [Emoji: [HashTag: Int]] = [:]

    lazy var topView: UIView = {
        let view: UIView = UIView()
        return view;
    }()
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
        label.text = "My Mood"
        label.textColor = UIColor.wmCoolBlueColor()
        return label
    }()
    lazy var positiveLabel: Label = { return self.createLabel("Positive", color: UIColor.wmSilverColor(), size: 11) }()
    lazy var negativeLabel: Label = { return self.createLabel("Negative", color: UIColor.wmSilverColor(), size: 11) }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = UIColor.wmBackgroundColor()
        self.scrollView.contentSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.height)
        emojiPieChart.chart.delegate = self
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually

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
        self.bottomView.addSubview(positiveLabel)
        self.bottomView.addSubview(negativeLabel)
        self.bottomView.addSubview(swipeChart)
        self.bottomView.addSubview(swipeInfoButton)

        _ = [topView, middleView].map({ $0.addBorder(edges: [.bottom], colour: UIColor.wmSilverColor(), thickness: 0.9) })

        hashTagInfoButton.tag = 0
        emojiInfoButton.tag = 1
        swipeInfoButton.tag = 2
        drawCharts()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Analytics.timeUserEntered(self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Analytics.timeUserExit(self, properties: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        let infoButtonConstraint = { (make: ConstraintMaker, v: UIView) -> Void in
            make.top.equalTo(v.snp.top).offset(5)
            make.right.equalTo(v.snp.right).offset(-5)
        }
        let labelConstraint = { (make: ConstraintMaker, v: UIView) -> Void in
            make.top.equalTo(v.snp.top).offset(5)
            make.left.equalTo(v.snp.left).offset(10)
        }

        scrollView.snp.makeConstraints({ make in
            make.centerX.equalTo(self.view.snp.centerX)
            make.top.equalTo(self.view.snp.topMargin)
            make.size.equalTo(self.view.snp.size)
            make.bottom.equalTo(self.stackView.snp.bottom).offset(100)
        })

        stackView.snp.makeConstraints({ make in
            make.width.equalTo(self.view.snp.width)
            make.top.equalTo(self.scrollView.snp.top)
            make.right.equalTo(self.view.snp.right)
            make.height.equalTo(800)
        })

        myHashTagsLabel.snp.makeConstraints({ make in labelConstraint(make, topView) })
        hashTagInfoButton.snp.makeConstraints({ make in infoButtonConstraint(make, topView) })
        hashtagsPieCharts.snp.makeConstraints({ make in
            make.width.equalTo(topView.snp.width)
            make.top.equalTo(hashTagInfoButton.snp.bottom)
            make.centerX.equalTo(topView.snp.centerX)
            make.bottom.equalTo(topView.snp.bottom).offset(-20)
        })

        myEmojisLabel.snp.makeConstraints({ make in labelConstraint(make, middleView) })
        emojiInfoButton.snp.makeConstraints({ make in infoButtonConstraint(make, middleView) })
        emojiPieChart.snp.makeConstraints({ make in
            make.width.equalTo(middleView.snp.width)
            make.top.equalTo(emojiInfoButton.snp.bottom)
            make.centerX.equalTo(middleView.snp.centerX)
            make.bottom.equalTo(middleView.snp.bottom).offset(-20)
        })

        swipeLabel.snp.makeConstraints({ make in labelConstraint(make, bottomView) })
        swipeInfoButton.snp.makeConstraints({ make in infoButtonConstraint(make, bottomView) })
        positiveLabel.snp.makeConstraints({ make in
            make.top.equalTo(self.swipeInfoButton.snp.bottom).offset(10)
            make.left.equalTo(self.swipeLabel.snp.left)
        })
        swipeChart.snp.makeConstraints({ make in
            make.width.equalTo(bottomView.snp.width)
            make.top.equalTo(swipeInfoButton.snp.bottom).offset(15)
            make.centerX.equalTo(bottomView.snp.centerX)
            //make.bottom.equalTo(bottomView.snp.bottom).offset(-20)
            make.bottom.equalTo(negativeLabel.snp.top).offset(-5)
        })
        negativeLabel.snp.makeConstraints({ make in
            make.bottom.equalTo(bottomView.snp.bottom).offset(-5)
            make.left.equalTo(self.positiveLabel.snp.left)
        })
    }

    func moreInfoButtonTapped( _ sender: UIButton) {
        var infoMessage = ""
        var containerView: UIView!

        switch sender.tag {
        case 0:
            //My hashtags
            self.myHashTagsLabel.isHidden = !self.myHashTagsLabel.isHidden
            containerView = self.topView
            infoMessage = "These are your most popular themes based on how you've categorised your posts"
        case 1: //My Emotions
            infoMessage = "This chart maps the emotions you have expressed when writing. Click through to see the posts that are connected to each of them."
            self.myEmojisLabel.isHidden = !self.myEmojisLabel.isHidden
            containerView = self.middleView
        case 2: //My Mood
            infoMessage = "This graph tracks your mood based on your swiping. Anything above the line represents positive emotions, anything below the line represents negative emotions."
            self.swipeLabel.isHidden = !self.swipeLabel.isHidden
            containerView = self.bottomView
        default:
            containerView = UIView()
            break;
        }

        if !sender.isSelected {
            sender.isSelected = true
            sender.backgroundColor = UIColor.wmCoolBlueColor()
            sender.setTitle(infoMessage, for: UIControlState())
            sender.snp.updateConstraints({ make in
                make.width.equalTo(self.view.snp.width).offset(-10)
                make.height.equalTo(35)
            })
        } else {
            sender.isSelected = false
            sender.backgroundColor = UIColor.clear
            //sender.snp.removeConstraints()
            sender.setTitle("", for: UIControlState())
            sender.snp.remakeConstraints({ make in
                //make.width.equalTo(15)
                make.top.equalTo(containerView.snp.top).offset(5)
                make.right.equalTo(containerView.snp.right).offset(-5)
            })
        }
    }

}

extension DashboardController {
    func drawCharts() {
        func createHashTagMap( _ hashtags: [String], map: [HashTag: Int]) -> [HashTag: Int] {
            var _map = map;
            for hashtag in hashtags {
                if let freq = _map[hashtag] { _map[hashtag] = freq + 1 }
                    else { _map[hashtag] = 1 }
            }
            return _map
        }

        ParseService.fetchPostsForUser(PFUser.current()!, callback: { posts in
            guard posts.count != 0 else { return }

            // Emoji - HashTag - Count
            self.emojiHashTagDictionary = posts.reduce([:], { map, post in
                var _map = map;
                if let hashTags = _map[post.emoji] {
                    _map[post.emoji] = createHashTagMap(post.hashTags, map: hashTags)
                } else {
                    _map[post.emoji] = createHashTagMap(post.hashTags, map: [:])
                }
                return _map;
            })

            //Retrieve the hash tags data
            let postHashTags = posts.reduce([], { return $0 + $1.hashTags })
            let hashTagMap: [HashTag: Int] = createHashTagMap(postHashTags, map: [:])

            //Retrieve the Emoji Data
            let emojiCountDictionary: [Emoji: Int] = self.emojiHashTagDictionary.keys.reduce([:], { map, emoji in
                var _map = map;
                _map[emoji] = self.emojiHashTagDictionary[emoji]!.values.reduce(0, +)
                return _map;
            })

            self.setupMaxHashTagsPieChart(hashTagMap)
            self.setupMinHashTagsPieChart(hashTagMap)
            self.setupEmojiPieChart(emojiCountDictionary)
        })

        //Line Graph for Swipes
        ParseService.getSwipesForUser(PFUser.current()!, callback: { swipes in
            guard swipes.count != 0 else { return }

            let dateFormat = DateFormat.custom("dd/MM/yyyy")
            let swipeDictionary: [Date: [Swipe]] = swipes.reduce([:], { map, swipe in
                var _map = map
                let dateString = swipe.createdAt.string(format: dateFormat)
                let key = try! DateInRegion(string: dateString, format: .custom("dd/MM/yyyy")).absoluteDate //.toDate(dateFormat)!
                if let swipes = map[key] {
                    _map[key] = swipes + [swipe]
                } else {
                    _map[key] = [swipe]
                }
                return _map
            })

            self.setupSwipeChart(swipeDictionary)
        })
    }

    func setupSwipeChart( _ dictionary: [Date: [Swipe]]) {
        //- note: Reversing the dictionary keys & values because the sortBy on the query isn't working
        let dataKeys: [String] = dictionary.keys.map({ $0.string() }).reversed()
        let dataValues: [Double] = dictionary.keys.map({ self.averageScoreFor(dictionary[$0]!) }).reversed()
        swipeChart.renderChart(dataKeys, values: dataValues)
    }

    func setupEmojiPieChart( _ dictionary: [Emoji: Int]) {
        let dataKeys: [String] = dictionary.keys.map({ emoji in emoji.value().name })
        let dataValues: [Int] = dictionary.keys.map({ emoji in dictionary[emoji]! });
        let colors: [UIColor] = dictionary.keys.map({ emoji in emoji.value().color })
        emojiPieChart.renderChart(emojiPieChart.chart, dataPoints: dataKeys, values: dataValues, colors: colors)
    }

    func setupMaxHashTagsPieChart( _ hashTagMap: [String: Int]) {
        //Most Used HashTag
        let mostTags = ["Others", hashTagMap.max()]
        let maxTuple: (highest: Int, total: Int) = hashTagMap.maxTuple()
        let mostTagsData = [ Double((maxTuple.total - maxTuple.highest)), Double(maxTuple.highest)]
        hashtagsPieCharts.renderChart(hashtagsPieCharts.maxHashtagsPie, dataPoints: mostTags, values: mostTagsData, centerValue: hashTagMap.maxPercent(), tag: hashTagMap.max())
    }

    /**
     Draws the second pie chart. The pie chart with the second most used hashtag, if there isn't enough data
     It displays the least used hashtag instead
     - todo: Needs refactoring as this method is not elegant enough
     - parameter hashTagMap: a dictionary of the hashtags to their frequency
     */
    func setupMinHashTagsPieChart( _ hashTagMap: [String: Int]) {
        //Least Used HashTag
        let tags = hashTagMap.keys().sorted(by: { s1, s2 in return hashTagMap[s1]! > hashTagMap[s2]! })
        let total = hashTagMap.values.reduce(0, +)
        let minTuple: (lowest: Int, total: Int) = hashTagMap.minTuple()
        var tag = hashTagMap.min()
        var count = minTuple.lowest

        if tags.count >= 2 {
            tag = tags[1]
            count = Int((Float(hashTagMap[tag]!) / Float(total)) * Float(100))
        }

        print(tag)
        print(count)

        let leastTags = ["Others", tag]
        let leastTagsData = [ Double(100 - count), Double(count)] //Double(total - count)

//        print("\n\(leastTags)")
//        print("\(leastTagsData)")
//        print("Total: \(total)")
//        print("\(hashTagMap.values)")

        hashtagsPieCharts.renderChart(hashtagsPieCharts.minHashtagsPie, dataPoints: leastTags, values: leastTagsData, centerValue: count, tag: tag)
    }

    func averageScoreFor( _ swipes: [Swipe]) -> Double {
        let total = swipes.reduce(0, { (total, cur) in
            return total + cur.value
        })
        return (Double(total) / Double(swipes.count))
    }

    func moreInfoButton() -> UIButton {
        let button = UIButton(type: .custom);
        button.setImage(UIImage(named: "info"), for: UIControlState())
        button.addTarget(self, action: .infoButtonTapped, for: .touchUpInside)
        button.titleLabel?.font = Label.font().withSize(9)
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.titleLabel?.numberOfLines = 0
        button.layer.cornerRadius = 5.0
        return button;
    }

    func createLabel( _ title: String, color: UIColor = UIColor.black, size: CGFloat = 13.0) -> Label {
        let label = Label()
        label.text = title;
        label.textColor = color;
        label.setFontSize(size)
        return label
    }

}

extension DashboardController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: Highlight) {
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
