//
//  EmojiChartDetailViewController.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 21/05/2016.
//  Copyright © 2016 The Leaf. All rights reserved.
//

import UIKit

class EmojiChartDetailViewController: UITableViewController {
    
    var emoji: Emoji!
    var hashTags: [String:Int]!
    lazy var contentKey: [String] = {
        return self.hashTags.keys().sort{ s1,s2 in return self.hashTags[s1]! > self.hashTags[s2]! }
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(DetailTableViewCell.self , forCellReuseIdentifier: "EMOJI_DETAIL_CELL")
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorColor = UIColor.wmPaleGreyTwoColor()
        self.tableView.bounces = false
        Analytics.trackUserViewed(self)
    }

    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int { return 1 }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = EmojiDetailHeaderView()
        view.header.text = self.emoji.value().name
        view.header.backgroundColor = self.emoji.value().color
        return view
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.hashTags.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("EMOJI_DETAIL_CELL", forIndexPath: indexPath) as! DetailTableViewCell
        let key = self.contentKey[ indexPath.row ]
        cell.countLabel.text = String(self.hashTags[key]!)
        cell.hashtagLabel.text = key
        cell.countLabel.textColor = self.emoji.value().color
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let hashtags = self.contentKey[ indexPath.row ]
        let searchController = SearchViewController()
        searchController.shouldSearchPrivatePosts = true
        searchController.searchParameters = [hashtags]
        self.navigationController?.pushViewController(searchController, animated: true)
    }
    
}
