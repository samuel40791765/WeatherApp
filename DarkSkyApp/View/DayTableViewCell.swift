//
//  DayTableViewCell.swift
//  DarkSkyApp
//
//  Created by Samuel Chiang on 11/26/19.
//  Copyright © 2019 Samuel Chiang. All rights reserved.
//

import UIKit

class DayTableViewCell: UITableViewCell {
    @IBOutlet weak var DayDate: UILabel!
    @IBOutlet weak var DayIcon: UIImageView!
    @IBOutlet weak var DaySunriseTime: UILabel!
    @IBOutlet weak var DaySunsetTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
