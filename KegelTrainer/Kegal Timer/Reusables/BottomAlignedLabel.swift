//
//  BottomAlignedLabel.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 26/01/2019.
//  Copyright © 2019 Alex Marchant. All rights reserved.
//

import UIKit

@IBDesignable class BottomAlignedLabel: UILabel {
    
    override func drawText(in rect: CGRect) {
        if let stringText = text {
            let stringTextAsNSString = stringText as NSString
            let labelStringSize = stringTextAsNSString.boundingRect(with: CGSize(width: self.frame.width,height: CGFloat.greatestFiniteMagnitude),
                                                                    options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                                    attributes: [NSAttributedString.Key.font: font],
                                                                    context: nil).size
            super.drawText(in: CGRect(x:0,y: self.frame.maxY - labelStringSize.height, width: self.frame.width, height:ceil(labelStringSize.height)))
        } else {
            super.drawText(in: rect)
        }
    }
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }

}
