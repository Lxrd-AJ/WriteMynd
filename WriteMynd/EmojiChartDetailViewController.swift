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
        return self.hashTags.keys().sorted{ s1,s2 in return self.hashTags[s1]! > self.hashTags[s2]! }
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(DetailTableViewCell.self , forCellReuseIdentifier: "EMOJI_DETAIL_CELL")
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorColor = UIColor.wmPaleGreyTwoColor()
        self.tableView.bounces = false
        Analytics.trackUserViewed(self)
    }

    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }

    override func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = EmojiDetailHeaderView()
        view.header.text = self.emoji.value().name
        view.header.backgroundColor = self.emoji.value().color
        return view
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.hashTags.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EMOJI_DETAIL_CELL", for: indexPath) as! DetailTableViewCell
        let key = self.contentKey[ (indexPath as NSIndexPath).row ]
        cell.countLabel.text = String(self.hashTags[key]!)
        cell.hashtagLabel.text = key
        cell.countLabel.textColor = self.emoji.value().color
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let hashtags = self.contentKey[ (indexPath as NSIndexPath).row ]
        let searchController = SearchViewController()
        searchController.shouldSearchPrivatePosts = true
        searchController.searchParameters = [hashtags]
        self.navigationController?.pushViewController(searchController, animated: true)
    }
    
}
