//
//  WalkthroughViewController-ProfileWalkthrough.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 28/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation

extension WalkthroughViewController {
    
    internal func setupProfileWalkthroughViewControllers() {
        let yourProfileVc = WalkthroughPageViewController.instantiate(storyboard: "WalkthroughPage")
        
        yourProfileVc.setupScreenInformation(
            imageName: "your-profile",
            stepTitle: localizedString(forKey: "about_your_profile_title"),
            stepDescription: localizedString(forKey: "about_your_profile_description"),
            delegate: self)
        
        let earningPointsVc = WalkthroughPageViewController.instantiate(storyboard: "WalkthroughPage")
        
        earningPointsVc.setupScreenInformation(
            imageName: "earning-points",
            stepTitle: localizedString(forKey: "earning_points_title"),
            stepDescription: localizedString(forKey: "earning_points_description"),
            delegate: self)
        
        let maintainingYourStreakVc = WalkthroughPageViewController.instantiate(storyboard: "WalkthroughPage")
        
        maintainingYourStreakVc.setupScreenInformation(
            imageName: "maintaining-your-streak",
            stepTitle: localizedString(forKey: "maintaining_your_streak_title"),
            stepDescription: localizedString(forKey: "maintaining_your_streak_description"),
            delegate: self)
        
        let protectingYourStreakVc = WalkthroughPageViewController.instantiate(storyboard: "WalkthroughPage")
        
        protectingYourStreakVc.setupScreenInformation(
            imageName: "protect-your-streak",
            stepTitle: localizedString(forKey: "protecting_your_streak_title"),
            stepDescription: localizedString(forKey: "protecting_your_streak_description"),
            delegate: self)
        
        let leaderboardsVc = WalkthroughPageViewController.instantiate(storyboard: "WalkthroughPage")
        
        leaderboardsVc.setupScreenInformation(
            imageName: "the-leaderboard",
            stepTitle: localizedString(forKey: "the_leaderboards_title"),
            stepDescription: localizedString(forKey: "the_leaderboards_description"),
            buttonText: localizedString(forKey: "end_walkthrough"),
            delegate: self)
        
        orderedWalkthroughSteps = [yourProfileVc, earningPointsVc, maintainingYourStreakVc, protectingYourStreakVc, leaderboardsVc]
    }
    
}
