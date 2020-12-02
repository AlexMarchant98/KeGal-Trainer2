//
//  ReclaimStreakViewModel.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 02/12/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation

class ReclaimStreakViewModel {
    
    let hasStreakToReclaim: Bool
    let lostStreak: Int?
    let daysLeftToReclaimStreak: Int?
    let delegate: ReclaimStreakViewDelegate
    
    init(
        hasStreakToReclaim: Bool,
        lostStreak: Int? = nil,
        daysLeftToReclaimStreak: Int? = nil,
        delegate: ReclaimStreakViewDelegate) {
        
        self.hasStreakToReclaim = hasStreakToReclaim
        self.lostStreak = lostStreak
        self.daysLeftToReclaimStreak = daysLeftToReclaimStreak
        self.delegate = delegate
        
    }
    
}
