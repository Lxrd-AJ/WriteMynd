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
        self.tableView.registerClass(UITableViewCell.self , forCellReuseIdentifier: "EMOJI_DETAIL_CELL")
        self.tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int { return 1 }
    
//    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool { return false }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Stuff that made me \(self.emoji.value().name)"
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.hashTags.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("EMOJI_DETAIL_CELL", forIndexPath: indexPath)
        let key = self.contentKey[ indexPath.row ]
        cell.textLabel?.text = "\(key)\t\(String(self.hashTags[key]!))"
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
