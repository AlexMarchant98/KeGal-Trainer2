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
    func didLoadWorkoutStats(_ hasAnAccount: Bool, _ levelCompleted: String?, _ totalWorkouts: String?, _ pointsEarned: Double)
}

class WorkoutCompletePresenter: WorkoutCompletePresenterProtocol {
    
    let pointsEarned: Double
    let levelCompleted: String?
    let delegate: WorkoutCompletePresenterDelegate
    let view: WorkoutCompletePresenterView
    
    init(
        pointsEarned: Double,
        with view: WorkoutCompletePresenterView,
        delegate: WorkoutCompletePresenterDelegate,
        levelCompleted: String? = nil) {
        
        self.pointsEarned = pointsEarned
        self.delegate = delegate
        self.view = view
        self.levelCompleted = levelCompleted
        
    }
    
    func loadWorkoutStats() {
        if let currentUser = CurrentUserService.shared.user {
            self.view.didLoadWorkoutStats(true, levelCompleted, String(currentUser.total_workouts), pointsEarned)
        } else {
            self.view.didLoadWorkoutStats(false, levelCompleted, nil, pointsEarned)
        }
    }
    
    func closePopup() {
        self.delegate.closeWorkoutComplete()
    }
    
    
}
