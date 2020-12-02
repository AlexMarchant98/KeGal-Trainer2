//
//  Fonts.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 14/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation
import UIKit

struct Fonts {
    
    static var timeLabelFont: UIFont {
        guard let titleFont = UIFont(name: "Quicksand-Regular", size: 90) else {
            fatalError("""
                Failed to load the "Quicksand-Bold" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        
        let metrics = UIFontMetrics(forTextStyle: .headline)
        return metrics.scaledFont(for: titleFont)
    }
    
    static var titleFont : UIFont {
        guard let titleFont = UIFont(name: "Quicksand-Bold", size: 26) else {
            fatalError("""
                Failed to load the "Quicksand-Bold" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        
        let metrics = UIFontMetrics(forTextStyle: .headline)
        return metrics.scaledFont(for: titleFont)
    }
    
    static var subTitle : UIFont {
        guard let subTitle = UIFont(name: "Quicksand-Bold", size: 22) else {
            fatalError("""
                Failed to load the "Quicksand-Bold" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        
        let metrics = UIFontMetrics(forTextStyle: .headline)
        return metrics.scaledFont(for: subTitle)
    }
    
    static var headerFont : UIFont {
        guard let headerFont = UIFont(name: "Quicksand-Bold", size: 18) else {
            fatalError("""
                Failed to load the "Quicksand-Bold" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        let metrics = UIFontMetrics(forTextStyle: .headline)
        return metrics.scaledFont(for: headerFont)
    }
    
    static var subHeaderFont : UIFont {
        guard let subHeaderFont = UIFont(name: "Quicksand-SemiBold", size: 16) else {
            fatalError("""
                Failed to load the "Quicksand-SemiBold" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        let metrics = UIFontMetrics(forTextStyle: .subheadline)
        return metrics.scaledFont(for: subHeaderFont)
    }
    
    static var buttonFont : UIFont {
        guard let buttonFont = UIFont(name: "Quicksand-Bold", size: 18) else {
            fatalError("""
                Failed to load the "Quicksand-Bold" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        let metrics = UIFontMetrics(forTextStyle: .title1)
        return metrics.scaledFont(for: buttonFont)
    }
    
    static var bodyFont: UIFont {
        guard let bodyFont = UIFont(name: "Quicksand-Medium", size: 16) else {
            fatalError("""
                Failed to load the "Quicksand-Medium" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        let metrics = UIFontMetrics(forTextStyle: .body)
        return metrics.scaledFont(for: bodyFont)
    }
    
    static var captionFont: UIFont {
        guard let captionFont = UIFont(name: "Quicksand-Regular", size: 14) else {
            fatalError("""
                Failed to load the "Quicksand-Medium" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        let metrics = UIFontMetrics(forTextStyle: .caption1)
        return metrics.scaledFont(for: captionFont)
    }
}
