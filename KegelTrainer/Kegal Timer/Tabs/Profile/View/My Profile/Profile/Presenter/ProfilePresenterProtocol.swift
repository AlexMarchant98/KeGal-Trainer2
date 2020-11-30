//
//  ProfilePresenterProtocol.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 14/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation

protocol ProfilePresenterProtocol {
    func getServices()
    func showWorkoutTracker()
    func editProfile()
    func didWatchAdvert()
    func ratedApp()
    func reviewedApp()
    func showLeaderboard()
    func getStreakProtectorIAPInformation()
    func purchaseStreakProtector()
    func addStreakProtector(add streakProtectors: Int)
}
