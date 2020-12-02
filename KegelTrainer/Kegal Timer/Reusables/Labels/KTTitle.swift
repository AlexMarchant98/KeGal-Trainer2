//
//  KTTitle.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 14/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import UIKit

class KTTitle: UILabel {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.font = Fonts.titleFont
        self.textColor = UIColor.white
        
    }
    
}
