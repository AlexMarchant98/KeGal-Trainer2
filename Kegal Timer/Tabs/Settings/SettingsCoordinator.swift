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
    var adServer: AdServer!
    
    required init(_ adServer: AdServer) {
        self.navigationController = UINavigationController()
        
        self.adServer = adServer
        
        self.navigationController.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(named: "Settings"), tag: 0)
        
        showSettings()
    }
    
    func showSettings() {
        let viewController = SettingsTableViewController.instantiate()
        
        viewController.adServer = self.adServer
        viewController.coordinator = self
        
        navigationController.pushViewController(viewController, animated: true)
    }
}
