//
//  TimerPresenter.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 18/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation
import CoreData
import UIKit

protocol TimerPresenterDelegate {
    func didCompleteWorkout(_ pointsEarned: Double, _ levelCompleted: String?)
}

protocol TimerPresenterView {
    func didGetWorkoutInformation(_ repsPerSet: Int, _ repLength: Int, _ restLength: Int)
    func errorOccurred(message: String)
}

class TimerPresenter: TimerPresenterProtocol {
    
    let delegate: TimerPresenterDelegate
    let view: TimerPresenterView
    
    let userPreferences = UserDefaults.standard
    
    let container: NSPersistentContainer?
    
    lazy var _stage = userPreferences.integer(forKey: Constants.stage)
    lazy var _level = userPreferences.string(forKey: Constants.level)
    lazy var _levelOrder = userPreferences.integer(forKey: Constants.levelOrder)
    
    init(
        with view: TimerPresenterView,
        delegate: TimerPresenterDelegate) {
        
        container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
        
        self.view = view
        self.delegate = delegate
        
    }
    func getWorkoutInformation() {
        let repsPerSet = userPreferences.integer(forKey: Constants.repsPerSet)
        let repLength = userPreferences.integer(forKey: Constants.repLength)
        let restLength = userPreferences.integer(forKey: Constants.restLength)
        
        _stage = userPreferences.integer(forKey: Constants.stage)
        _level = userPreferences.string(forKey: Constants.level) ?? ""
        _levelOrder = userPreferences.integer(forKey: Constants.levelOrder)
        
        self.view.didGetWorkoutInformation(repsPerSet, repLength, restLength)
    }
    
    func completeWorkout(_ repLength: Int, _ restLength: Int, _ reps: Int) {
        
        let today = Date()
        addWorkout(today, Int32(repLength), Int32(restLength), Int32(reps))
        completeLevel()
        
        let totalWorkoutTime = round(Double(repLength * reps))
        
        var pointsEarned = totalWorkoutTime
        
        if let level = Double(_level ?? "1") {
            pointsEarned = round((pointsEarned * level))
        }
        
        if pointsEarned > 750 { pointsEarned = 750 }
        
        if var currentUser = CurrentUserService.shared.user {
            
            if(!currentUser.has_exercised_today) {
                currentUser.workout_days_streak += 1
                currentUser.has_exercised_today = true
            }
            
            var streakMultiplier = 0.65
            
            if(currentUser.workout_days_streak > 0) {
                streakMultiplier = round(0.65 * Double(currentUser.workout_days_streak))
            }
            
            pointsEarned = pointsEarned * streakMultiplier
            
            if((currentUser.daily_points + Int(pointsEarned)) >= Constants.maxDailyPoints) {
                
                let remainingDailyPoints = Constants.maxDailyPoints - currentUser.daily_points
                
                currentUser.daily_points += remainingDailyPoints
                currentUser.total_points += Int64(remainingDailyPoints)
                
            } else {
                
                currentUser.daily_points += Int(pointsEarned)
                currentUser.total_points += Int64(pointsEarned)
                
            }

            currentUser.total_workout_time = currentUser.total_workout_time + Int64(totalWorkoutTime)
            currentUser.total_workouts += 1
            currentUser.total_rest_time += Int64((reps - 1) * restLength)
            currentUser.total_number_of_reps += Int64(reps)
            
            CurrentUserService.shared.updateUser(currentUser)
        }
        
        self.delegate.didCompleteWorkout(pointsEarned, _level)
        
    }
    
    internal func completeLevel() {
        if(!_level!.isEmpty)
        {
            if let context = container?.viewContext {
                Level.completeLevel(context, _level!)
                
                if(Level.unlockNextLevel(context, Int32(_stage), currentLevelOrder: Int32(_levelOrder)) == nil)
                {
                    let stage = Stage.unlockNextStage(context, Int32(_stage))
                    
                    do {
                        try Level.unlockFirstLevelOfStage(context, stage!.stage)
                    } catch {
                        // Show an error
                    }
                }
            }
            userPreferences.set(nil, forKey: Constants.stage)
            userPreferences.set(nil, forKey: Constants.level)
            userPreferences.set(nil, forKey: Constants.levelOrder)
        }
    }
    
    func addWorkout(_ date: Date, _ repCount: Int32, _ repLength: Int32, _ restLength: Int32) {
        if let context = container?.viewContext {
            do
            {
                if let existingWorkoutDate = try WorkoutDate.getWorkoutDate(context, date)
                {
                    Workout.addWorkout(context, existingWorkoutDate, repCount, repLength, restLength)
                } else {
                    WorkoutDate.addWorkoutDate(context, date)
                    if let addedWorkoutDate = try WorkoutDate.getWorkoutDate(context, date)
                    {
                        Workout.addWorkout(context, addedWorkoutDate, repCount, repLength, restLength)
                    } else {
                        self.view.errorOccurred(message: "Something went wrong whilst adding your workout to the tracker, please close the app and try again.")
                    }
                }
            } catch {
                self.view.errorOccurred(message: "Something went wrong whilst adding your workout to the tracker, please close the app and try again.")
            }
        }
    }
}
