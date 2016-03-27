//
//  MetricTableViewCell.swift
//  Pocket Judge
//
//  Created by Carlos Arcenas on 3/23/16.
//  Copyright © 2016 Carlos Arcenas. All rights reserved.
//

import UIKit

class MetricTableViewCell: UITableViewCell {

    @IBOutlet weak var metricCategoryLabel: UILabel!
    @IBOutlet weak var metricNameLabel: UILabel!
    @IBOutlet weak var informationButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected == true {
            metricCategoryLabel.textColor = UIColor.whiteColor()
            metricNameLabel.textColor = UIColor.whiteColor()
            informationButton.hidden = false
            backgroundColor = UIColor.blackColor()
            selectedBackgroundView = UIView()
            selectedBackgroundView?.backgroundColor = UIColor.blackColor()
        } else {
            metricCategoryLabel.textColor = UIColor(hex: "886e57")
            metricNameLabel.textColor = UIColor.blackColor()
            informationButton.hidden = true
            backgroundColor = UIColor(hex: "f3e4cc")
            selectedBackgroundView = nil
        }
        
        // Configure the view for the selected state
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        if highlighted == true {
            metricCategoryLabel.textColor = UIColor.whiteColor()
            metricNameLabel.textColor = UIColor.whiteColor()
            informationButton.hidden = false
            backgroundColor = UIColor.blackColor()
        } else {
            metricCategoryLabel.textColor = UIColor(hex: "886e57")
            metricNameLabel.textColor = UIColor.blackColor()
            informationButton.hidden = true
            backgroundColor = UIColor(hex: "f3e4cc")
        }
    }

}
