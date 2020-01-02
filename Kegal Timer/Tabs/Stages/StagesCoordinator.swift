//
//  StagesCoordinator.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 06/06/2019.
//  Copyright © 2019 Alex Marchant. All rights reserved.
//

import UIKit

class StagesCoordinator: Coordinator {
    
    var navigationController: UINavigationController!
    var adMobService: AdMobService!
    
    required init(_ adMobService: AdMobService) {
        self.navigationController = UINavigationController()
        
        self.adMobService = adMobService
        
        let viewController = StageTableViewController.instantiate()
        
        viewController.adMobService = self.adMobService
        viewController.tabBarItem = UITabBarItem(title: "Stages", image: UIImage(named: "Challenges"), tag: 0)
        viewController.coordinator = self
        
        navigationController.viewControllers = [viewController]
    }}
