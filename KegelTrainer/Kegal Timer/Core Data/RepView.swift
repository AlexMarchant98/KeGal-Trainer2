//
//  RepView.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 16/12/2018.
//  Copyright © 2018 Alex Marchant. All rights reserved.
//

import UIKit

class RepView: UIView {
    
    private var _rep: Int!
    private var _x: CGFloat!
    private var _y: CGFloat!
    private var _currentRep: Bool!
    private var _position: Int!
    private var _alpha: Int?
    
    convenience init(frame: CGRect, rep: Int, x: CGFloat, y: CGFloat, position: Int) {
        self.init(frame: frame)
        _rep = rep
        _x = x
        _y = y
        _currentRep = false
        _position = position
        
    }
    
    
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(arcCenter: CGPoint(x: _x, y: _y),
                                radius: 15, startAngle: -CGFloat.pi / 2, endAngle: 2 * .pi, clockwise: true)
        
        path.close()
        
        UIColor.green.setFill()
        UIColor.green.setStroke()
        path.fill()
        path.stroke()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    
}
