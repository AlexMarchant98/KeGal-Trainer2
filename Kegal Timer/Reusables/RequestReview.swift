//
//  RequestReview.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 21/02/2019.
//  Copyright © 2019 Alex Marchant. All rights reserved.
//

import UIKit
import StoreKit

struct RequestReview {
    
    static func incrementLaunchCount() {
        let launchCount = UserDefaults.standard.integer(forKey: Constants.appLaunchCount)
        
        UserDefaults.standard.set((launchCount + 1), forKey: Constants.appLaunchCount)
    }
    
    static func requestReview() {
        let minimumLaunchCount = 5
        let launchCount = UserDefaults.standard.integer(forKey: Constants.appLaunchCount)
        
        if launchCount >= minimumLaunchCount {
            UserDefaults.standard.set((0), forKey: Constants.appLaunchCount)
            SKStoreReviewController.requestReview()
        }
    }
    
    static func stagesRequestReview() {
        SKStoreReviewController.requestReview()
    }
    
    static func levelsRequestReview() {
        let minimumLevelsCompletedCount = 2
        let levelsCompletedCount = UserDefaults.standard.integer(forKey: Constants.levelsCompleted)
        
        if levelsCompletedCount >= minimumLevelsCompletedCount {
            UserDefaults.standard.set((0), forKey: Constants.levelsCompleted)
            SKStoreReviewController.requestReview()
        } else {
            incrementLevelsCompletedCount()
        }
    }
    
    static func incrementLevelsCompletedCount() {
        let levelsCompletedCount = UserDefaults.standard.integer(forKey: Constants.levelsCompleted)
        
        UserDefaults.standard.set((levelsCompletedCount + 1), forKey: Constants.levelsCompleted)
    }

}
