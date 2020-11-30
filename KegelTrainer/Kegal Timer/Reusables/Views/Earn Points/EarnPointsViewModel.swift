//
//  EarnPointsViewModel.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 14/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation

class EarnPointsViewModel {
    
    let hasRatedApp: Bool
    let hasReviewedApp: Bool
    let delegate: EarnPointsViewDelegate
    
    init(hasRatedApp: Bool, hasReviewedApp: Bool, delegate: EarnPointsViewDelegate) {
        self.hasRatedApp = hasRatedApp
        self.hasReviewedApp = hasReviewedApp
        self.delegate = delegate
    }
    
}
