//
//  SettingsCoordinator.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 06/06/2019.
//  Copyright © 2019 Alex Marchant. All rights reserved.
//

import UIKit

class SettingsCoordinator: Coordinator {
    let navigationController: UINavigationController
    
    init() {
        self.navigationController = UINavigationController()
        
        let viewController = SettingsTableViewController.instantiate()
        viewController.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(named: "Settings"), tag: 0)
        viewController.coordinator = self
        
        navigationController.viewControllers = [viewController]
    }
}
