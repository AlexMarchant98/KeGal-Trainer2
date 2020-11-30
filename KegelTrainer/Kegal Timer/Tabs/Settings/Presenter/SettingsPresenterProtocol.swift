//
//  SettingsPresenterProtocol.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 27/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation

protocol SettingsPresenterProtocol {
    func getAdRemovalIAPInformation()
    func purchaseAdRemoval()
    func showWalkthrough()
    func restoreIAPPurchases()
    func getSettings()
    func saveSettings(
        repsPerSet: String?,
        repLength: String?,
        restLength: String?,
        vibrateCueIsOn: Bool,
        visualCueIsOn: Bool,
        soundCueIsOn: Bool)
}
