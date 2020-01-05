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
    var adServer: AdServer!
    
    required init(_ adServer: AdServer) {
        self.navigationController = UINavigationController()
        self.navigationController.setNavigationBarHidden(true, animated: false)
        
        self.adServer = adServer
        
        let viewController = TimerViewController.instantiate()
        
        viewController.adServer = self.adServer
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
