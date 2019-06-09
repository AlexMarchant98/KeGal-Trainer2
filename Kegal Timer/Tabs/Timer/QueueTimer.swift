//
//  QueueTimer.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 04/12/2018.
//  Copyright © 2018 Alex Marchant. All rights reserved.
//

import UIKit

class QueueTimer {
    
    private enum State {
        case paused
        case resumed
    }
    private var state: State = .paused
    
    private var timer : DispatchSourceTimer!
    private var d : Date!
    private var diff : TimeInterval!
    private var f : (()->Void)!
    
    public var timeRemaining : TimeInterval!
    
    func configAndStart(delayTime: TimeInterval) {
        timeRemaining = delayTime
        timer = DispatchSource.makeTimerSource()
        timer.schedule(deadline: DispatchTime.now() + timeRemaining, repeating: .never)
        timer.setEventHandler(handler: f)
        d = Date()
        timer.resume()
        state = .resumed
    }
    
    func pause() {
        if state == .paused {
            return
        }
        
        timer.cancel()
        diff = Date().timeIntervalSince(d)
        state = .paused
    }
    
    func resume() {
        if state == .resumed {
            return
        } else {
            timeRemaining = timeRemaining - diff
            
            timer = DispatchSource.makeTimerSource()
            timer.schedule(deadline: DispatchTime.now() + timeRemaining, repeating: .never)
            timer.setEventHandler(handler: f)
            d = Date()
            state = .resumed
            
            timer.resume()
            
        }
    }
}
