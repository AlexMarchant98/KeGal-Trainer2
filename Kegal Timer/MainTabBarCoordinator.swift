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
    
    var adServer: AdServer!
    var trackWorkoutsCoordinator: TrackWorkoutsCoordinator!
    var stagesCoordinator: StagesCoordinator!
    var timerCoordinator: TimerCoordinator!
    var remindersCoordinator: RemindersCoordinator!
    var settingsCoordinator: SettingsCoordinator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.adServer = AdServer()
        
        self.trackWorkoutsCoordinator = TrackWorkoutsCoordinator(adServer)
        self.stagesCoordinator = StagesCoordinator(adServer)
        self.timerCoordinator = TimerCoordinator(adServer)
        self.remindersCoordinator = RemindersCoordinator(adServer)
        self.settingsCoordinator = SettingsCoordinator(adServer)
        
        self.tabBar.barTintColor = UIColor.white
        self.tabBar.tintColor = UIColor.workoutBackgroundColor
        
        viewControllers = [trackWorkoutsCoordinator.navigationController, stagesCoordinator.navigationController, timerCoordinator.navigationController, remindersCoordinator.navigationController, settingsCoordinator.navigationController]
        
        self.selectedIndex = 2
    }
    
}
