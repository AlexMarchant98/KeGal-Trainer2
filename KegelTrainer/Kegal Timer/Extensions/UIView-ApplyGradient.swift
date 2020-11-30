//
//  UIView-ApplyGradient.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 14/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    @discardableResult
    func applyGradient(colours: [UIColor]) -> CAGradientLayer {
        return self.applyGradient(colours: colours, locations: nil)
    }

    @discardableResult
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
        return gradient
    }
}

extension UIView {
    
    
    /* Usage Example
     * bgView.addBottomRoundedEdge(desiredCurve: 1.5)
     */
      func addBottomRoundedEdge(desiredCurve: CGFloat?) {
          let offset: CGFloat = self.frame.width / desiredCurve!
          let bounds: CGRect = self.bounds
          
          let rectBounds: CGRect = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.size.width, height: bounds.size.height / 2)
          let rectPath: UIBezierPath = UIBezierPath(rect: rectBounds)
          let ovalBounds: CGRect = CGRect(x: bounds.origin.x - offset / 2, y: bounds.origin.y, width: bounds.size.width + offset, height: bounds.size.height)
          let ovalPath: UIBezierPath = UIBezierPath(ovalIn: ovalBounds)
          rectPath.append(ovalPath)
          
          // Create the shape layer and set its path
          let maskLayer: CAShapeLayer = CAShapeLayer()
          maskLayer.frame = bounds
          maskLayer.path = rectPath.cgPath
          
          // Set the newly created shape layer as the mask for the view's layer
          self.layer.mask = maskLayer
      }
  }
