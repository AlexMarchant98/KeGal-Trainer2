//
//  KTHeader.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 14/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import UIKit

class KTHeader: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.font = Fonts.headerFont
        self.textColor = UIColor.appGreen
    }
    
    override var intrinsicContentSize: CGSize {
        let originContentSize = super.intrinsicContentSize
        
        let width = originContentSize.width
        let height = originContentSize.height
        
        layer.masksToBounds = true
        
        self.font = Fonts.headerFont
        
        return CGSize(width: width, height: height)
    }
    
}
