//
//  PostTableViewCell.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 10/12/2015.
//  Copyright © 2015 The Leaf. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var hashTagsLabel: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
