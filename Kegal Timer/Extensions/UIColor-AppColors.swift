//
//  UIColor-AppColors.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 09/06/2019.
//  Copyright © 2019 Alex Marchant. All rights reserved.
//

import UIKit

extension UIColor {
    static func rgb(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
    static let workoutBackgroundColor = UIColor.rgb(r: 18, g: 18, b: 20)
    static let trackStrokeColour = UIColor.rgb(r: 18, g: 18, b: 20)
    static let restBackgroundColor = UIColor.rgb(r: 255, g: 141, b: 10)
    static let workoutCompleteBackgroundColor = UIColor.rgb(r: 58, g: 208, b: 1)
    static let pauseColor = UIColor.rgb(r: 229, g: 228, b: 230)
    static let AlertBackgroundDim = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.30)
}
