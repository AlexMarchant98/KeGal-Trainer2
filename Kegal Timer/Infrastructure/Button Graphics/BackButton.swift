//
//  MenuButton.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 05/11/2018.
//  Copyright © 2018 Alex Marchant. All rights reserved.
//

import UIKit

@IBDesignable

class BackButton: UIButton {
    
    let menuIconColor = UIColor.white
    
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
        horizontalPathShapeLayer()
        
        addTarget(self, action: #selector(BackButton.buttonPressed), for: .touchUpInside)
    }
    
    @objc func buttonPressed()
    {
        horizontalPathShapeLayer()
    }
    
    func horizontalPathShapeLayer()
    {
        shapeLayer.path = createBackButtonPath()
        shapeLayer.fillColor = UIColor.pauseColor.cgColor
        self.layer.addSublayer(shapeLayer)
    }
    
    func createBackButtonPath() -> CGPath
    {
        let path = UIBezierPath()
        path.move(to: CGPoint(
            x: 0,
            y: 0
        ))
        path.addLine(to: CGPoint (
            x: (bounds.width / 5) * 1,
            y: 0
        ))
        path.addLine(to: CGPoint (
            x: (bounds.width / 5) * 1,
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
        
        path.move(to: CGPoint(
            x: 0,
            y: (bounds.height / 2)
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
            y: (bounds.height / 2)
        ))
        
        return path.cgPath
    }
}
