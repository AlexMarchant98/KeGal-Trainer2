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
            imageName: "welcome",
            stepTitle: "Welcome to Kegel Trainer",
            stepDescription: "We are extremely happy you are apart of our community! Here's a quick overview of how to use PTFinder.",
            delegate: self)
        
        orderedWalkthroughSteps.insert(welcomeVc, at: 0)
        
    }
    
}
