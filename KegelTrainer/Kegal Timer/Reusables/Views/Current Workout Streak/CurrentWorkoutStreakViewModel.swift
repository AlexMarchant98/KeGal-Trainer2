//
//  DailyStreakViewModel.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 14/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation

class CurrentWorkoutStreakViewModel {
    
    let streak: Int
    let streakProtectors: Int
    let delegate: DailyStreakViewDelegate
    
    init(_ streak: Int, _ streakProtectors: Int, delegate: DailyStreakViewDelegate) {
        
        self.streak = streak
        self.streakProtectors = streakProtectors
        self.delegate = delegate
        
    }
    
}
