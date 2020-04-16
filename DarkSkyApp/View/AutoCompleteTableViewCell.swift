//
//  AutoCompleteTableViewCell.swift
//  DarkSkyApp
//
//  Created by Samuel Chiang on 12/2/19.
//  Copyright © 2019 Samuel Chiang. All rights reserved.
//

import UIKit

class AutoCompleteTableViewCell: UITableViewCell {
    @IBOutlet weak var citytext: UILabel!    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
