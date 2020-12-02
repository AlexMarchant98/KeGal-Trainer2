//
//  WorkoutCompletePresenter.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 19/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation

protocol WorkoutCompletePresenterDelegate {
    func closeWorkoutComplete()
}

protocol WorkoutCompletePresenterView {
    func didLoadWorkoutStats(_ hasAnAccount: Bool, _ levelCompleted: String?, _ totalWorkouts: String?, _ pointsEarned: Double, _ maxDailyPointsEarned: Bool?)
}

class WorkoutCompletePresenter: WorkoutCompletePresenterProtocol {
    
    let pointsEarned: Double
    let maxDailyPointsEarned: Bool
    let levelCompleted: String?
    let delegate: WorkoutCompletePresenterDelegate
    let view: WorkoutCompletePresenterView
    
    init(
        pointsEarned: Double,
        maxDailyPointsEarned: Bool,
        with view: WorkoutCompletePresenterView,
        delegate: WorkoutCompletePresenterDelegate,
        levelCompleted: String? = nil) {
        
        self.pointsEarned = pointsEarned
        self.maxDailyPointsEarned = maxDailyPointsEarned
        self.delegate = delegate
        self.view = view
        self.levelCompleted = levelCompleted
        
    }
    
    func loadWorkoutStats() {
        if let currentUser = CurrentUserService.shared.user {
            self.view.didLoadWorkoutStats(true, levelCompleted, String(currentUser.total_workouts), pointsEarned, maxDailyPointsEarned)
        } else {
            self.view.didLoadWorkoutStats(false, levelCompleted, nil, pointsEarned, nil)
        }
    }
    
    func closePopup() {
        self.delegate.closeWorkoutComplete()
    }
    
    
}
