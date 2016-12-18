//
//  MenuViewCell.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 22/12/2015.
//  Copyright © 2015 The Leaf. All rights reserved.
//

import UIKit

class MenuViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.backgroundColor = .wmCoolBlueColor()
        self.titleLabel.textColor = .white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
