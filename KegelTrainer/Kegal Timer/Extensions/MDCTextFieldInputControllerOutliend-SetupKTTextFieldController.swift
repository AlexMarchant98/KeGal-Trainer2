//
//  MDCTextFieldInputControllerOutliend-SetupKTTextFieldController.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 24/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialTextFields

extension MDCTextInputControllerOutlined {
    
    func setupKTTextFieldController() {
        self.activeColor = UIColor.appGreen
        self.normalColor = .white
        self.inlinePlaceholderColor = .white
        self.floatingPlaceholderActiveColor = .appGreen
        self.floatingPlaceholderNormalColor = .white
        self.textInputClearButtonTintColor = .appGreen
        self.inlinePlaceholderColor = .white
        self.leadingUnderlineLabelTextColor = .white
        self.trailingUnderlineLabelTextColor = .white
    }
}
