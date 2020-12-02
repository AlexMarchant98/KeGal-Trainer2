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
            stepTitle: "Your profile",
            stepDescription: "Now you have a profile all your workouts are tracked and earn you points.\n\nYou can see all the information associated with your profile by clicking the profile tab and logging in.",
            delegate: self)
        
        let earningPointsVc = WalkthroughPageViewController.instantiate(storyboard: "WalkthroughPage")
        
        earningPointsVc.setupScreenInformation(
            imageName: "earning-points",
            stepTitle: "Earning Points",
            stepDescription: "You earn points by completing your kegel workouts in the app. Every workout will earn you points, which are added to your profile.\n\nYou can earn a maximum of 5000 points per day and you can see your progression to this number on your profile.\n\nUnder the 'Earn Points' section of your profile, you can find quick tasks that will earn you points without the need to complete a workout.",
            delegate: self)
        
        let maintainingYourStreakVc = WalkthroughPageViewController.instantiate(storyboard: "WalkthroughPage")
        
        maintainingYourStreakVc.setupScreenInformation(
            imageName: "maintaining-your-streak",
            stepTitle: "Maintaining Your Streak",
            stepDescription: "You need to complete a workout every day so that you continue to make progress, that's why you have a 'Current Workout Streak' on your profile.\n\nEvery day that you complete a workout, you increment your current workout streak by 1. If you do not complete a workout one day, you will lose your current workout streak and have to start again.\n\nBy increasing your workout streak, you will earn more points per workout,  resulting in higher rankings on the leaderboard.",
            delegate: self)
        
        let protectingYourStreakVc = WalkthroughPageViewController.instantiate(storyboard: "WalkthroughPage")
        
        protectingYourStreakVc.setupScreenInformation(
            imageName: "protect-your-streak",
            stepTitle: "Protecting Your Streak",
            stepDescription: "To ensure you don't lose your workout streak if you forget to exercise one day, you can get a 'Streak Protector'.\n\nA 'Streak Protector' will protect your streak if you forget to workout on a day, so you can continue earning more points.\n\nA 'Streak Protector' will protect your streak one time, once it has been used you will have to get another one. The number of 'Streak Protectors' you have left can be seen on your profile page.",
            delegate: self)
        
        let leaderboardsVc = WalkthroughPageViewController.instantiate(storyboard: "WalkthroughPage")
        
        leaderboardsVc.setupScreenInformation(
            imageName: "the-leaderboard",
            stepTitle: "The Leaderboards",
            stepDescription: "The leaderboard shows you how you rank in comparison to all other users on the app by the total number of points.\n\nYou can always see your profile at the bottom of the screen, alongside your rank.\n\nRanks are updated once a day, so, the points you earn will affect your rank for the next day.",
            buttonText: "End Walkthrough",
            delegate: self)
        
        orderedWalkthroughSteps = [yourProfileVc, earningPointsVc, maintainingYourStreakVc, protectingYourStreakVc, leaderboardsVc]
    }
    
}
