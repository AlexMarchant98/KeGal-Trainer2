//
//  KTDestructiveButton.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 20/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialButtons

class KTDestructiveButton: MDCRaisedButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setTitleColor(.white, for: .normal)
        self.setTitleFont(Fonts.buttonFont, for: .normal)
        self.setBackgroundColor(.appRed)
        self.layer.cornerRadius = Constants.cornerRadius
        
        self.isUppercaseTitle = false
        
        self.setShadowColor(UIColor.clear, for: .normal)
        
        self.adjustsFontForContentSizeCategoryWhenScaledFontIsUnavailable = true
        
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.titleLabel?.minimumScaleFactor = 0.75
    }

}
