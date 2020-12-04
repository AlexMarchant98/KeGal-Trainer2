//
//  ViewLeaderboardPresenterProtocol.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 24/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation

protocol ViewLeaderboardPresenterProtocol {
    func getInitialLeaderboardSet()
    func loadNextProfileSet()
    func closeLeaderboard()
}
