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
    
    static func requestReview(forceReview: Bool = false) {
        
        if(forceReview) {
            SKStoreReviewController.requestReview()
        } else {
            let minimumLaunchCount = 20
            let launchCount = UserDefaults.standard.integer(forKey: Constants.appLaunchCount)
            
            if launchCount >= minimumLaunchCount {
                UserDefaults.standard.set((0), forKey: Constants.appLaunchCount)
                SKStoreReviewController.requestReview()
            } else {
                UserDefaults.standard.set((launchCount + 1), forKey: Constants.appLaunchCount)
            }
        }
    }
    
    static func stagesRequestReview() {
        SKStoreReviewController.requestReview()
    }
    
    static func levelsRequestReview() {
        let minimumLevelsCompletedCount = 10
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
    
    static func requestWrittenReview() {
        let appStoreUrl = URL(string: "https://apps.apple.com/app/id1451350209?action=write-review")!
        UIApplication.shared.open(appStoreUrl)
    }

}
