//
//  KTPrimaryButtonInverted.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 24/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialButtons

class KTPrimaryButtonInverted: MDCRaisedButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setTitleColor(.appGreen, for: .normal)
        self.setTitleFont(Fonts.buttonFont, for: .normal)
        self.setBackgroundColor(.workoutBackgroundColor)
        self.layer.cornerRadius = Constants.cornerRadius
        
        self.isUppercaseTitle = false
        
        self.setShadowColor(UIColor.clear, for: .normal)
        
        self.adjustsFontForContentSizeCategoryWhenScaledFontIsUnavailable = true
        
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.titleLabel?.minimumScaleFactor = 0.5
        self.titleLabel?.lineBreakMode = .byWordWrapping
    }

}
