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
            stepTitle: localizedString(forKey: "welcome_to_kegel_trainer"),
            stepDescription: localizedString(forKey: "welcome_to_kegel_trainer_message"),
            delegate: self)
        
        orderedWalkthroughSteps.insert(welcomeVc, at: 0)
        
    }
    
}
