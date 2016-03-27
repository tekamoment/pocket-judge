//
//  ResultSliderTableViewCell.swift
//  Pocket Judge
//
//  Created by Carlos Arcenas on 3/23/16.
//  Copyright © 2016 Carlos Arcenas. All rights reserved.
//

import UIKit

class ResultSliderTableViewCell: UITableViewCell {

    @IBOutlet weak var optionNameLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var percentageSlider: UISlider!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
