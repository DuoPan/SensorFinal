//
//  HistoryCell.swift
//  FIT5140Final
//
//  Created by duo pan on 17/10/17.
//  Copyright © 2017 duo pan. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {

    @IBOutlet var number: UILabel!
    @IBOutlet var name: UILabel!
    @IBOutlet var valueChange: UILabel!
    @IBOutlet var totalScore: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
