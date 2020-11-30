//
//  SettingsPresenter.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 27/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation

protocol SettingsPresenterDelegate {
    func showWalkthrough()
}

protocol SettingsPresenterView {
    func errorOccurred(message: String)
    func didLoadIAPInformation(title: String, description: String, localPrice: String)
    func didGetSettings(
        repsPerSet: Int,
        repLength: Int,
        restLength: Int,
        vibrateCueIsOn: Bool,
        visualCueIsOn: Bool,
        soundCueIsOn: Bool)
    func settingsSaved()
}

class SettingsPresenter: SettingsPresenterProtocol {
    
    let userPreferences = UserDefaults.standard
    
    let iapService: IAPServiceProtocol
    
    let view: SettingsPresenterView
    let delegate: SettingsPresenterDelegate
    
    init(
        _ iapService: IAPServiceProtocol,
        with view: SettingsPresenterView,
        delegate: SettingsPresenterDelegate) {
        
        self.iapService = iapService
        self.view = view
        self.delegate = delegate
        
    }
    
    func showWalkthrough() {
        self.delegate.showWalkthrough()
    }
    
    func getAdRemovalIAPInformation() {
        if let product = iapService.getLoadedIAPProduct(with: IAPProducts.MidTierAdRemoval) {
            self.view.didLoadIAPInformation(
                title: product.localizedTitle,
                description: product.localizedDescription,
                localPrice: "\(product.priceLocale.currencySymbol ?? "")\(product.price)")
        } else {
            purchaseAdRemoval()
        }
    }
    
    func getSettings() {
        let repsPerSet = userPreferences.integer(forKey: Constants.repsPerSet)
        let repLength = userPreferences.integer(forKey: Constants.repLength)
        let restLength = userPreferences.integer(forKey: Constants.restLength)
        
        let vibrateCueIsOn = userPreferences.bool(forKey: Constants.vibrationCue)
        let visualCueIsOn = userPreferences.bool(forKey: Constants.visualCue)
        let soundCueIsOn = userPreferences.bool(forKey: Constants.soundCue)
        
        self.view.didGetSettings(
            repsPerSet: repsPerSet,
            repLength: repLength,
            restLength: restLength,
            vibrateCueIsOn: vibrateCueIsOn,
            visualCueIsOn: visualCueIsOn,
            soundCueIsOn: soundCueIsOn)
    }
    
    func saveSettings(
        repsPerSet: String?,
        repLength: String?,
        restLength: String?,
        vibrateCueIsOn: Bool,
        visualCueIsOn: Bool,
        soundCueIsOn: Bool) {
        
        guard let repsPerSet = repsPerSet,
              let repLength = repLength,
              let restLength = restLength else {
            self.view.errorOccurred(message: "Please enter a value for all workout settings")
            return
        }
        
        if(!checkWorkoutValueIsValid(setting: repsPerSet)) {
            self.view.errorOccurred(message: "Please enter a number greater than 0 for reps per set in a workout")
            return
        }
        
        if(!checkWorkoutValueIsValid(setting: repLength)) {
            self.view.errorOccurred(message: "Please enter a number greater than 0 for your workout rep length")
            return
        }
        
        if(!checkWorkoutValueIsValid(setting: restLength)) {
            self.view.errorOccurred(message: "Please enter a number greater than 0 for your workout rest length")
            return
        }
        
        userPreferences.set(Int(repsPerSet), forKey: Constants.repsPerSet)
        userPreferences.set(Int(repLength), forKey: Constants.repLength)
        userPreferences.set(Int(restLength), forKey: Constants.restLength)
        
        userPreferences.set(0, forKey: Constants.stage)
        userPreferences.set("", forKey: Constants.level)
        userPreferences.set(0, forKey: Constants.levelOrder)
        
        userPreferences.set(vibrateCueIsOn, forKey: Constants.vibrationCue)
        userPreferences.set(visualCueIsOn, forKey: Constants.visualCue)
        userPreferences.set(soundCueIsOn, forKey: Constants.soundCue)
        
        self.view.settingsSaved()
    }
    
    func purchaseAdRemoval() {
        iapService.purchaseAdRemoval()
    }
    
    func restoreIAPPurchases() {
        iapService.restoreIAPPurchases()
    }
    
    
    private func checkWorkoutValueIsValid(setting: String) -> Bool
    {
        let convertedSetting = Int(setting)
        
        if convertedSetting == nil {
            return false
        }
        
        if(convertedSetting == 0) {
            return false
        }
        
        return true
    }
    
}
