//
//  Extensions.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 26/11/2018.
//  Copyright © 2018 Alex Marchant. All rights reserved.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIColor {
    static func rgb(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
    //static let workoutBackgroundColor = UIColor.rgb(r: 9, g: 31, b: 165) - Blue
    //static let trackStrokeColour = UIColor.rgb(r: 9, g: 31, b: 165) - Blue
    static let workoutBackgroundColor = UIColor.rgb(r: 18, g: 18, b: 20)
    static let trackStrokeColour = UIColor.rgb(r: 18, g: 18, b: 20)
    static let restBackgroundColor = UIColor.rgb(r: 255, g: 141, b: 10)
    static let workoutCompleteBackgroundColor = UIColor.rgb(r: 58, g: 208, b: 1)
    static let pauseColor = UIColor.rgb(r: 229, g: 228, b: 230)
}

extension Date {
    
    func stripTime() -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        let date = Calendar.current.date(from: components)
        return date!
    }
    
}
