//
//  UIBezierPath-Tick.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 09/06/2019.
//  Copyright © 2019 Alex Marchant. All rights reserved.
//

import UIKit

extension UIBezierPath {
    static var tick: UIBezierPath {
        let tick = UIBezierPath()
        tick.addArc(withCenter: CGPoint(x: 0.5, y:0.5), radius: 0.4, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        tick.move(to: CGPoint(x: 0.22, y: 0.52))
        tick.addLine(to: CGPoint(x: 0.38, y: 0.68))
        tick.addLine(to: CGPoint(x: 0.76, y: 0.30))
        return tick
    }
}
