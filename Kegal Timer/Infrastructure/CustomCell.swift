//
//  CustomCell.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 06/01/2019.
//  Copyright © 2019 Alex Marchant. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CustomCell: JTAppleCell {
    @IBOutlet var dateLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.contentView.addSubview(self.dateLabel)
        self.dateLabel.textAlignment = .center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
