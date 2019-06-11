//
//  StagesCoordinator.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 06/06/2019.
//  Copyright © 2019 Alex Marchant. All rights reserved.
//

import UIKit

class StagesCoordinator: Coordinator {
    let navigationController: UINavigationController
    
    init() {
        self.navigationController = UINavigationController()
        
        let viewController = StageTableViewController.instantiate()
        viewController.tabBarItem = UITabBarItem(title: "Stages", image: UIImage(named: "Challenges"), tag: 0)
        viewController.coordinator = self
        
        navigationController.viewControllers = [viewController]
    }}
