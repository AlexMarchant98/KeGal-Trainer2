//
//  StopButton.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 06/11/2018.
//  Copyright © 2018 Alex Marchant. All rights reserved.
//

import UIKit

class StopButton: UIButton {
    
    let stopIconColor = UIColor.white
    
    var shapeLayer = CAShapeLayer()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initButton()
        
    }
    
    func initButton()
    {
        squarePathShapeLayer()
        
        addTarget(self, action: #selector(StopButton.buttonPressed), for: .touchUpInside)
    }
    
    @objc func buttonPressed()
    {
        squarePathShapeLayer()
    }
    
    func squarePathShapeLayer()
    {
        shapeLayer.path = createSquarePath()
        shapeLayer.fillColor = UIColor.white.cgColor
        self.layer.addSublayer(shapeLayer)
    }
    
    func createSquarePath() -> CGPath
    {
        let path = UIBezierPath()
        path.move(to: CGPoint(
            x: 0,
            y: 0
        ))
        path.addLine(to: CGPoint (
            x: bounds.width,
            y: 0
        ))
        path.addLine(to: CGPoint (
            x: bounds.width,
            y: bounds.height
        ))
        path.addLine(to: CGPoint (
            x: 0,
            y: bounds.height
        ))
        path.addLine(to: CGPoint (
            x: 0,
            y: 0
        ))
        
        return path.cgPath
    }
}
