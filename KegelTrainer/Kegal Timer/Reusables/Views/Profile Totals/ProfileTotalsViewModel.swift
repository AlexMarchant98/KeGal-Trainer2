//
//  ProfileTotalsViewModel.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 14/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation

class ProfileTotalsViewModel {
    
    let totalWorkouts: Int
    let totalWorkoutTime: Int64
    let delegate: ProfileTotalsViewDelegate
    
    init(totalWorkouts: Int, totalWorkoutTime: Int64, delegate: ProfileTotalsViewDelegate) {
        self.totalWorkouts = totalWorkouts
        self.totalWorkoutTime = totalWorkoutTime
        self.delegate = delegate
    }
    
}
