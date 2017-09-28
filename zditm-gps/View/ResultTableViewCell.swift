//
//  ResultTableViewCell.swift
//  zditm-gps
//
//  Created by Jakub Pomykała on 9/24/17.
//  Copyright © 2017 Jakub Pomykała. All rights reserved.
//

import UIKit

class ResultTableViewCell: UITableViewCell {

    @IBOutlet var minutesLabel: UILabel!
    @IBOutlet var delayTextLabel: UILabel!
    @IBOutlet var toLabel: UILabel!
    @IBOutlet var fromLabel: UILabel!
    @IBOutlet var delayLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
