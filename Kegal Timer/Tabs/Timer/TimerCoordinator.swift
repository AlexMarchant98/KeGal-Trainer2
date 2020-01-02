//
//  TimerCoordinator.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 06/06/2019.
//  Copyright © 2019 Alex Marchant. All rights reserved.
//

import UIKit
import SwiftEntryKit

class TimerCoordinator: Coordinator {
    
    var navigationController: UINavigationController!
    var admobService: AdMobDisplayer!
    
    required init(_ admobService: AdMobDisplayer) {
        self.navigationController = UINavigationController()
        self.navigationController.setNavigationBarHidden(true, animated: false)
        
        self.admobService = admobService
        
        let viewController = TimerViewController.instantiate()
        
        viewController.adMobDisplayer = self.admobService
        viewController.tabBarItem = UITabBarItem(title: "Timer", image: UIImage(named: "Timer"), tag: 0)
        viewController.coordinator = self
        
        navigationController.viewControllers = [viewController]
    }
    
    func showWorkoutComplete()
    {
        let viewController = WorkoutCompleteViewController.instantiate()
        viewController.coordinator = self
        viewController.presentAsAlert()
    }
    
    func didFinishWorkout()
    {
        didFinishWork()
        
        self.navigationController.tabBarController?.selectedIndex = 1
    }
    
    func didFinishWork()
    {
        navigationController.popViewController(animated: true)
        
        navigationController.dismiss(animated: true, completion: {})
    }
}
