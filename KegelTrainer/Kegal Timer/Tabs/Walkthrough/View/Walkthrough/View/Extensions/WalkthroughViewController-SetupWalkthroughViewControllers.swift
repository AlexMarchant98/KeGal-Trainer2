//
//  WalkthroughViewController-SetupWalkthroughViewControllers.swift
//  PTHub
//
//  Created by Alex Marchant on 20/10/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation

extension WalkthroughViewController {
    
    internal func setupWalkthroughViewControllers() {
        
        let trackWorkoutsVc = WalkthroughPageViewController.instantiate(storyboard: "WalkthroughPage")
        
        trackWorkoutsVc.setupScreenInformation(
            imageName: "track-workouts",
            stepTitle: localizedString(forKey: "track_your_workouts_title"),
            stepDescription: localizedString(forKey: "track_your_workouts_description"),
            buttonText: localizedString(forKey: "end_walkthrough"),
            delegate: self)
        
        let stagesAndLevelsVc = WalkthroughPageViewController.instantiate(storyboard: "WalkthroughPage")
        
        stagesAndLevelsVc.setupScreenInformation(
            imageName: "stages-and-levels",
            stepTitle: localizedString(forKey: "stages_and_levels_title"),
            stepDescription: localizedString(forKey: "stages_and_levels_description"),
            delegate: self)
        
        let performWorkoutsVc = WalkthroughPageViewController.instantiate(storyboard: "WalkthroughPage")
        
        performWorkoutsVc.setupScreenInformation(
            imageName: "perform-workout",
            stepTitle: localizedString(forKey: "performing_workouts_title"),
            stepDescription: localizedString(forKey: "performing_workouts_description"),
            delegate: self)
        
        let remindersVc = WalkthroughPageViewController.instantiate(storyboard: "WalkthroughPage")
        
        remindersVc.setupScreenInformation(
            imageName: "reminders",
            stepTitle: localizedString(forKey: "settings_up_reminders_title"),
            stepDescription: localizedString(forKey: "settings_up_reminders_description"),
            delegate: self)
        
        let profileVc = WalkthroughPageViewController.instantiate(storyboard: "WalkthroughPage")
        
        profileVc.setupScreenInformation(
            imageName: "profile",
            stepTitle: localizedString(forKey: "your_profile_title"),
            stepDescription: localizedString(forKey: "your_profile_description"),
            delegate: self)
        
        let settingsVc = WalkthroughPageViewController.instantiate(storyboard: "WalkthroughPage")
        
        settingsVc.setupScreenInformation(
            imageName: "settings",
            stepTitle: localizedString(forKey: "settings_title"),
            stepDescription: localizedString(forKey: "settings_description"),
            delegate: self)
        
        orderedWalkthroughSteps = [performWorkoutsVc, stagesAndLevelsVc, remindersVc, settingsVc, profileVc, trackWorkoutsVc]
    }
    
}
