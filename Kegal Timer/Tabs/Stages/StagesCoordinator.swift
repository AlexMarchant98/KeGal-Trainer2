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
    var admobService: AdMobDisplayer!
    
    required init(_ admobService: AdMobDisplayer) {
        self.navigationController = UINavigationController()
        
        self.admobService = admobService
        
        let viewController = StageTableViewController.instantiate()
        
        viewController.adMobDisplayer = self.admobService
        viewController.tabBarItem = UITabBarItem(title: "Stages", image: UIImage(named: "Challenges"), tag: 0)
        viewController.coordinator = self
        
        navigationController.viewControllers = [viewController]
    }}
