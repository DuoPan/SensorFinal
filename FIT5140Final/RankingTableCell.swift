//
//  RankingTableCell.swift
//  FIT5140Final
//
//  Created by duo pan on 21/10/17.
//  Copyright © 2017 duo pan. All rights reserved.
//

import UIKit

class RankingTableCell: UITableViewCell {

    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var rank: UILabel!
    @IBOutlet var username: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
