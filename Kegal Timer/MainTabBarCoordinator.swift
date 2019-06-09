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
    
    let trackWorkoutsCoordinator = TrackWorkoutsCoordinator()
    let stagesCoordinator = StagesCoordinator()
    let timerCoordinator = TimerCoordinator()
    let remindersCoordinator = RemindersCoordinator()
    let settingsCoordinator = SettingsCoordinator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.barTintColor = UIColor.white
        self.tabBar.tintColor = UIColor.workoutBackgroundColor
        
        viewControllers = [trackWorkoutsCoordinator.navigationController, stagesCoordinator.navigationController, timerCoordinator.navigationController, remindersCoordinator.navigationController, settingsCoordinator.navigationController]
        
        self.selectedIndex = 2
    }
}
