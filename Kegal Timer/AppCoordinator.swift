//
//  TabBarCoordinator.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 05/06/2019.
//  Copyright © 2019 Alex Marchant. All rights reserved.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    
    var adServer: AdServer!
    var trackWorkoutsCoordinator: TrackWorkoutsCoordinator!
    var stagesCoordinator: StagesCoordinator!
    var timerCoordinator: TimerCoordinator!
    var remindersCoordinator: RemindersCoordinator!
    var settingsCoordinator: SettingsCoordinator!
    
    // MARK: - Init
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.adServer = AdServer()
        
        self.trackWorkoutsCoordinator = TrackWorkoutsCoordinator(adServer)
        self.stagesCoordinator = StagesCoordinator(adServer)
        self.timerCoordinator = TimerCoordinator(adServer)
        self.remindersCoordinator = RemindersCoordinator(adServer)
        self.settingsCoordinator = SettingsCoordinator(adServer)
    }
    
    override func start() {
        
        let tabBarController = UITabBarController()
        tabBarController.tabBar.tintColor = UIColor.workoutBackgroundColor
        
        trackWorkoutsCoordinator.start()
        stagesCoordinator.start()
        timerCoordinator.start()
        remindersCoordinator.start()
        settingsCoordinator.start()
        
        tabBarController.viewControllers = [
            trackWorkoutsCoordinator.navigationController,
            stagesCoordinator.navigationController,
            timerCoordinator.navigationController,
            remindersCoordinator.navigationController,
            settingsCoordinator.navigationController]
        
        tabBarController.selectedIndex = 2
        
        self.navigationController.pushViewController(tabBarController, animated: true)
        
        self.navigationController.hideKeyboardWhenTappedAround()
        
    }
    
    func showWalkthroughOnStartup() {
        let launchedBefore = UserDefaults.standard.bool(forKey: Constants.launchedBefore)
//        if(!launchedBefore) {
            self.showWalkthrough()
//        }
    }
    
    private func showWalkthrough() {
        
        let launchedBefore = UserDefaults.standard.bool(forKey: Constants.launchedBefore)
        
        let walkthroughCoordinator = WalkthroughCoordinator(
            self.navigationController,
            launchedBefore)
        
        walkthroughCoordinator.delegate = self
            
        self.addChildCoordinator(walkthroughCoordinator)
        
        walkthroughCoordinator.start()
    }
    
}

extension AppCoordinator: WalkthroughCoordinatorDelegate {
    func didFinishWalkthrough(_ walkthroughCoordinator: WalkthroughCoordinator) {
        walkthroughCoordinator.navigationController.dismiss(animated: true)
        self.removeChildCoordinator(walkthroughCoordinator)
    }
}
