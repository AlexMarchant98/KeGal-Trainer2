//
//  TimerPresenterProtocol.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 18/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation

protocol TimerPresenterProtocol {
    func getWorkoutInformation()
    func completeWorkout(_ repLength: Int, _ restLength: Int, _ reps: Int)
}
