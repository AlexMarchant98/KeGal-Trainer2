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
        tick.move(to: CGPoint(x: 0.22, y: 0.52))
        tick.addLine(to: CGPoint(x: 0.38, y: 0.68))
        tick.addLine(to: CGPoint(x: 0.76, y: 0.30))
        return tick
    }
}
