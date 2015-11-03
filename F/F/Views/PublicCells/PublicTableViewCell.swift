//
//  PublicTableViewCell.swift
//  F
//
//  Created by huchunbo on 15/11/4.
//  Copyright © 2015年 TIDELAB. All rights reserved.
//

import UIKit

class PublicTableViewCell: UITableViewCell {
    
    var delegate: PublicTableViewController?
    var id: String?
    var action: String?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
