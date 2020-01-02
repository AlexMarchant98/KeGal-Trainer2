//
//  SettingsCoordinator.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 06/06/2019.
//  Copyright © 2019 Alex Marchant. All rights reserved.
//

import UIKit

class SettingsCoordinator: Coordinator {
    
    var navigationController: UINavigationController!
    var admobService: AdMobDisplayer!
    
    required init(_ admobService: AdMobDisplayer) {
        self.navigationController = UINavigationController()
        
        self.admobService = admobService
        
        self.navigationController.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(named: "Settings"), tag: 0)
        
        showSettings()
    }
    
    func showSettings() {
        let viewController = SettingsTableViewController.instantiate()
        
        viewController.adMobDisplayer = self.admobService
        viewController.coordinator = self
        
        navigationController.pushViewController(viewController, animated: true)
    }
}
