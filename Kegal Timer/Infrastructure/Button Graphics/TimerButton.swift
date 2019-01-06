//
//  TimerButton.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 06/11/2018.
//  Copyright © 2018 Alex Marchant. All rights reserved.
//

import UIKit

@IBDesignable
class TimerButton: UIButton {
    
    private let shapeLayer = CAShapeLayer()
    private let backgroundTrackLayer = CAShapeLayer()
    
    let animateableTrackLayer = CAShapeLayer()
    let userPreferences = UserDefaults.standard
    let startTriangleColor = UIColor.green
    
    lazy var _restLength = userPreferences.integer(forKey: "RestLength")
    
    var isTimerOn = false
    var isWorkoutComplete = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initButton()
        
    }
    
    private func initButton()
    {
        startTriangleShapeLayer()
        defineTrackLayers()
        
        addTarget(self, action: #selector(TimerButton.buttonPressed), for: .touchUpInside)
    }
    
    @objc func buttonPressed() {
        if(isTimerOn == true)
        {
            if(isWorkoutComplete)
            {
                checkMarkShapeLayer()
            } else {
                pauseShapeLayer()
            }
        }
        else
        {
            startTriangleShapeLayer()
        }
    }
    
    func startTriangleShapeLayer()
    {
        shapeLayer.path = createStartTriangle()
        shapeLayer.fillColor = UIColor.green.cgColor
        self.layer.addSublayer(shapeLayer)
        
        isTimerOn = true
    }
    
    private func createStartTriangle() -> CGPath
    {
        let startTrianglePath = UIBezierPath()
        
        startTrianglePath.move(to: CGPoint(
            x: bounds.width / 3 ,
            y: bounds.height / 3))
        startTrianglePath.addLine(to: CGPoint(
            x: (bounds.width / 3) * 2,
            y: bounds.height / 2))
        startTrianglePath.addLine(to: CGPoint(
            x: bounds.width / 3,
            y: (bounds.height / 3) * 2))
        startTrianglePath.addLine(to: CGPoint(
            x: bounds.width / 3,
            y: bounds.height / 3))
        
        startTrianglePath.close()
        
        return startTrianglePath.cgPath
    }
    
    private func pauseShapeLayer()
    {
        shapeLayer.path = createPausePath()
        shapeLayer.fillColor = UIColor.pauseColor.cgColor
        self.layer.addSublayer(shapeLayer)
        
        isTimerOn = false
    }
    
    private func createPausePath() -> CGPath
    {
        let pausePath = UIBezierPath()
        pausePath.move(to: CGPoint(
            x: (bounds.width / 9) * 3,
            y: (bounds.height / 7) * 2
        ))
        pausePath.addLine(to: CGPoint(
            x: (bounds.width / 9) * 4,
            y: (bounds.height / 7) * 2
        ))
        pausePath.addLine(to: CGPoint(
            x: (bounds.width / 9) * 4,
            y: (bounds.height / 7) * 5
        ))
        pausePath.addLine(to: CGPoint(
            x: (bounds.width / 9) * 3,
            y: (bounds.height / 7) * 5
        ))
        pausePath.addLine(to: CGPoint(
            x: (bounds.width / 9) * 3,
            y: (bounds.height / 7) * 2
        ))
        pausePath.move(to: CGPoint(
            x: (bounds.width / 9) * 5,
            y: (bounds.height / 7) * 2
        ))
        pausePath.addLine(to: CGPoint(
            x: (bounds.width / 9) * 6,
            y: (bounds.height / 7) * 2
        ))
        pausePath.addLine(to: CGPoint(
            x: (bounds.width / 9) * 6,
            y: (bounds.height / 7) * 5
        ))
        pausePath.addLine(to: CGPoint(
            x: (bounds.width / 9) * 5,
            y: (bounds.height / 7) * 5
        ))
        pausePath.addLine(to: CGPoint(
            x: (bounds.width / 9) * 5,
            y: (bounds.height / 7) * 2
        ))
        
        pausePath.close()
        
        return pausePath.cgPath
    }
    
    public func checkMarkShapeLayer()
    {
        shapeLayer.path = createCheckMarkPath()
        shapeLayer.fillColor = UIColor.white.cgColor
        
        self.layer.addSublayer(shapeLayer)
        
        isTimerOn = false
        isWorkoutComplete = false
    }
    
    private func createCheckMarkPath() -> CGPath
    {
        let checkMarkPath = UIBezierPath()
        
        checkMarkPath.move(to: CGPoint(
            x: (bounds.width / 24) * 5,
            y: (bounds.height / 24) * 8.5
        ))
        checkMarkPath.addLine(to: CGPoint(
            x: (bounds.width / 24) * 9.25,
            y: (bounds.height / 24) * 13.07
        ))
        checkMarkPath.addLine(to: CGPoint(
            x: (bounds.width / 24) * 20,
            y: (bounds.height / 24) * 2
        ))
        checkMarkPath.addLine(to: CGPoint(
            x: (bounds.width / 24) * 24,
            y: (bounds.height / 24) * 6.5
        ))
        checkMarkPath.addLine(to: CGPoint(
            x: (bounds.width / 24) * 9.25,
            y: (bounds.height / 24) * 21
        ))
        checkMarkPath.addLine(to: CGPoint(
            x: (bounds.width / 24) * 1,
            y: (bounds.height / 24) * 12.5
        ))
        checkMarkPath.addLine(to: CGPoint(
            x: (bounds.width / 24) * 5,
            y: (bounds.height / 24) * 8.5
        ))
        
        checkMarkPath.close()
        
        return checkMarkPath.cgPath
    }
    
    private func defineTrackLayers()
    {
        let trackLayerPath = UIBezierPath(arcCenter: CGPoint(
            x: (bounds.width / 2),
            y: (bounds.height / 2)),
            radius: (bounds.maxX / 5) * 4, startAngle: -CGFloat.pi / 2, endAngle: 2 * .pi, clockwise: true)
        
        backgroundTrackLayer.path = trackLayerPath.cgPath
        backgroundTrackLayer.strokeColor = UIColor.white.cgColor
        backgroundTrackLayer.lineWidth = 2
        backgroundTrackLayer.fillColor = UIColor.clear.cgColor
        backgroundTrackLayer.lineCap = CAShapeLayerLineCap.round
        
        animateableTrackLayer.path = trackLayerPath.cgPath
        animateableTrackLayer.strokeColor = UIColor.trackStrokeColour.cgColor
        animateableTrackLayer.lineWidth = 2
        animateableTrackLayer.fillColor = UIColor.clear.cgColor
        animateableTrackLayer.lineCap = CAShapeLayerLineCap.round
        animateableTrackLayer.strokeEnd = 0
        
        self.layer.addSublayer(backgroundTrackLayer)
        self.layer.addSublayer(animateableTrackLayer)
    }
    
    public func animateCircle()
    {
        animateableTrackLayer.strokeStart = 0.0
        animateableTrackLayer.strokeEnd = 0.0
        animateableTrackLayer.speed = 1.0
        
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        strokeEndAnimation.duration = Double(_restLength)
        strokeEndAnimation.fillMode = CAMediaTimingFillMode.forwards
        strokeEndAnimation.toValue = 1
        strokeEndAnimation.isRemovedOnCompletion = true
        
        animateableTrackLayer.add(strokeEndAnimation, forKey: "strokeEndAnimation")
    }
    
    public func pauseLayer() {
        let pausedTime: CFTimeInterval = animateableTrackLayer.convertTime(CACurrentMediaTime(), from: nil)
        animateableTrackLayer.speed = 0.0
        animateableTrackLayer.timeOffset = pausedTime
    }
    
    public func resumeLayer() {
        let pausedTime: CFTimeInterval = animateableTrackLayer.timeOffset
        animateableTrackLayer.speed = 1.0
        animateableTrackLayer.timeOffset = 0.0
        animateableTrackLayer.beginTime = 0.0
        let timeSincePause: CFTimeInterval = animateableTrackLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        animateableTrackLayer.beginTime = timeSincePause
    }
}
