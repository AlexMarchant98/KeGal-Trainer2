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
    var adServer: AdServer!
    
    required init(_ adServer: AdServer) {
        self.navigationController = UINavigationController()
        
        self.adServer = adServer
        
        let viewController = StageTableViewController.instantiate()
        
        viewController.adServer = self.adServer
        viewController.tabBarItem = UITabBarItem(title: "Stages", image: UIImage(named: "Challenges"), tag: 0)
        viewController.coordinator = self
        
        navigationController.viewControllers = [viewController]
    }}
