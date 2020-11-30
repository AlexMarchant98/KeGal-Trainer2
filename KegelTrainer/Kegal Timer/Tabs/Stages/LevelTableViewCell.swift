//
//  LevelTableViewCell.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 29/05/2019.
//  Copyright © 2019 Alex Marchant. All rights reserved.
//

import UIKit

class LevelTableViewCell: UITableViewCell {
    
    var level: Level! { 
        didSet {
            
            self.textLabel?.font = Fonts.subHeaderFont
            
            if(level.completed) {
                self.textLabel!.text = "\(level.level!) Completed"
                self.accessoryType = .none
            } else if(level.unlocked == false) {
                self.textLabel!.text = "\(level.level!) Locked"
                self.accessoryType = .none
            } else {
                self.textLabel!.text = level.level
                self.accessoryType = .disclosureIndicator
            }
        }
    }
    
    var levelDisplay: Level! {
        didSet {
            
            var userInteractionEnabled = false
            var textLabelEnabled = false
            var backgroundColor = UIColor.leaderboardGray
            var tintColor = UIColor.white
            var textColor = UIColor.white
            
            if(level.completed == true)
            {
                userInteractionEnabled = true
                textLabelEnabled = true
                backgroundColor = UIColor.appGreen
                tintColor = UIColor.appGreen
                textColor = UIColor.white
            }
            else if (level.unlocked == true)
            {
                userInteractionEnabled = true
                textLabelEnabled = true
                backgroundColor = UIColor.white
                tintColor = UIColor.white
                textColor = UIColor.workoutBackgroundColor
            }
            
            self.isUserInteractionEnabled = userInteractionEnabled
            self.textLabel!.isEnabled = textLabelEnabled
            self.contentView.backgroundColor = backgroundColor
            self.contentView.tintColor = tintColor
            self.textLabel!.textColor = textColor
        }
    }
    
    func resetDisplay()
    {
        self.isUserInteractionEnabled = false
        self.textLabel!.isEnabled = false
        self.contentView.backgroundColor = UIColor.leaderboardGray
        self.contentView.tintColor = UIColor.white
        self.textLabel!.textColor = UIColor.white
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
