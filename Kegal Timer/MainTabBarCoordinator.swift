//
//  TabBarCoordinator.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 05/06/2019.
//  Copyright © 2019 Alex Marchant. All rights reserved.
//

import Foundation
import UIKit

class MainTabBarCoordinator: UITabBarController {
    
    var admobService: AdMobDisplayer!
    var trackWorkoutsCoordinator: TrackWorkoutsCoordinator!
    var stagesCoordinator: StagesCoordinator!
    var timerCoordinator: TimerCoordinator!
    var remindersCoordinator: RemindersCoordinator!
    var settingsCoordinator: SettingsCoordinator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.admobService = AdMobDisplayer()
        
        self.trackWorkoutsCoordinator = TrackWorkoutsCoordinator(admobService)
        self.stagesCoordinator = StagesCoordinator(admobService)
        self.timerCoordinator = TimerCoordinator(admobService)
        self.remindersCoordinator = RemindersCoordinator(admobService)
        self.settingsCoordinator = SettingsCoordinator(admobService)
        
        admobService.setupGadInterstitial(adUnitID: Constants.workoutCompleteAdId)
        
        self.tabBar.barTintColor = UIColor.white
        self.tabBar.tintColor = UIColor.workoutBackgroundColor
        
        viewControllers = [trackWorkoutsCoordinator.navigationController, stagesCoordinator.navigationController, timerCoordinator.navigationController, remindersCoordinator.navigationController, settingsCoordinator.navigationController]
        
        self.selectedIndex = 2
    }
    
}
