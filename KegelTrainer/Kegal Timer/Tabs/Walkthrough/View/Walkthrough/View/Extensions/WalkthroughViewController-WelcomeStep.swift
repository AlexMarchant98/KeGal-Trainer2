//
//  WalkthroughViewController-WelcomeStep.swift
//  PTHub
//
//  Created by Alex Marchant on 20/10/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation
import UIKit

extension WalkthroughViewController {
    
    func addWelcomeViewController() {
        
        let welcomeVc = WalkthroughPageViewController.instantiate(storyboard: "WalkthroughPage")
        
        welcomeVc.setupScreenInformation(
            imageName: "welcome-inverted",
            stepTitle: "Welcome to Kegel Trainer",
            stepDescription: "Here is a quick overview of how to use the app.",
            delegate: self)
        
        orderedWalkthroughSteps.insert(welcomeVc, at: 0)
        
    }
    
}
