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
            self.textLabel!.text = level.level
        }
    }
    
    var levelDisplay: Level! {
        didSet {
            var userInteractionEnabled = false
            var textLabelEnabled = false
            var backgroundColor = UIColor.white
            var tintColor = UIColor.white
            var textColor = UIColor.gray
            
            if(level.completed == true)
            {
                userInteractionEnabled = true
                textLabelEnabled = true
                backgroundColor = UIColor.workoutCompleteBackgroundColor
                tintColor = UIColor.workoutCompleteBackgroundColor
                textColor = UIColor.white
            }
            else if (level.unlocked == true)
            {
                userInteractionEnabled = true
                textLabelEnabled = true
                backgroundColor = UIColor.white
                tintColor = UIColor.white
                textColor = UIColor.black
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
        self.contentView.backgroundColor = UIColor.white
        self.contentView.tintColor = UIColor.white
        self.textLabel!.textColor = UIColor.gray
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
