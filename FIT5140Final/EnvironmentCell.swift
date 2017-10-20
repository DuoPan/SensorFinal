//
//  EnvironmentCell.swift
//  FIT5140Final
//
//  Created by duo pan on 20/10/17.
//  Copyright © 2017 duo pan. All rights reserved.
//

import UIKit

class EnvironmentCell: UITableViewCell {
    @IBOutlet var attribute: UILabel!
    @IBOutlet var value: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
