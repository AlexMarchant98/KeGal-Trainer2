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
    
    var adMobService: AdMobService!
    var trackWorkoutsCoordinator: TrackWorkoutsCoordinator!
    var stagesCoordinator: StagesCoordinator!
    var timerCoordinator: TimerCoordinator!
    var remindersCoordinator: RemindersCoordinator!
    var settingsCoordinator: SettingsCoordinator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.adMobService = AdMobService(Constants.workoutCompleteAdId)
        
        self.trackWorkoutsCoordinator = TrackWorkoutsCoordinator(adMobService)
        self.stagesCoordinator = StagesCoordinator(adMobService)
        self.timerCoordinator = TimerCoordinator(adMobService)
        self.remindersCoordinator = RemindersCoordinator(adMobService)
        self.settingsCoordinator = SettingsCoordinator(adMobService)
        
        self.tabBar.barTintColor = UIColor.white
        self.tabBar.tintColor = UIColor.workoutBackgroundColor
        
        viewControllers = [trackWorkoutsCoordinator.navigationController, stagesCoordinator.navigationController, timerCoordinator.navigationController, remindersCoordinator.navigationController, settingsCoordinator.navigationController]
        
        self.selectedIndex = 2
    }
    
}
