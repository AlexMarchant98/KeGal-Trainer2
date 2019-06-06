//
//  TimerCoordinator.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 06/06/2019.
//  Copyright © 2019 Alex Marchant. All rights reserved.
//

import UIKit

class TimerCoordinator: Coordinator {
    let navigationController: UINavigationController
    
    func start() {
        let vc: TimerViewController = TimerViewController.instantiate()
        navigationController.tabBarItem = UITabBarItem(title: "Timer", image: UIImage(named: "Timer"), selectedImage: nil)
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.pushViewController(vc, animated: false)
        vc.coordinator = self
    }
    
    init() {
        navigationController = UINavigationController()
    }
}
