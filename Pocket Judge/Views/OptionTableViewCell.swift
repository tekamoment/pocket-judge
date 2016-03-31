//
//  OptionTableViewCell.swift
//  Pocket Judge
//
//  Created by Carlos Arcenas on 3/21/16.
//  Copyright © 2016 Carlos Arcenas. All rights reserved.
//

import UIKit

class OptionTableViewCell: UITableViewCell {

    @IBOutlet weak var optionTitleLabel: UILabel!
    @IBOutlet weak var editNameButton: UIButton!
    var decisionState: DecisionState? {
        didSet {
            if decisionState == .ExistingDecisionsState {
                contentView.backgroundColor = UIColor(hex: "f6b783")
                optionTitleLabel.textColor = UIColor.whiteColor()
                editNameButton.hidden = true
            } else {
                contentView.backgroundColor = UIColor(hex: "f3e4cc")
                optionTitleLabel.textColor = UIColor.blackColor()
                editNameButton.hidden = false
            }
        }
    }
    
    var cellIndex: Int?
    var delegate: OptionTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        optionTitleLabel.font = UIFont(name: "BrandonGrotesque-Bold", size: 26)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func trashButtonTapped(sender: AnyObject) {
        delegate?.trashButtonTapped(cellIndex!)
    }
    
    @IBAction func editNameButtonTapped(sender: AnyObject) {
        delegate?.editNameButtonTapped(cellIndex!)
    }
    
    
    // edit name button to be implemented

}


protocol OptionTableViewCellDelegate {
    func trashButtonTapped(cellIndex: Int)
    func editNameButtonTapped(cellIndex: Int)
}