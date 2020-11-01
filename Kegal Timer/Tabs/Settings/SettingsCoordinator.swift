//
//  SettingsCoordinator.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 06/06/2019.
//  Copyright © 2019 Alex Marchant. All rights reserved.
//

import UIKit

protocol SettingsCoordinatorDelegate {
    func showAppWalkthrough()
}

class SettingsCoordinator: Coordinator {
    
    var navigationController: UINavigationController!
    var adServer: AdServer!
    
    let delegate: SettingsCoordinatorDelegate
    
    init(
        _ adServer: AdServer,
        delegate: SettingsCoordinatorDelegate) {
        self.navigationController = UINavigationController()
        
        self.adServer = adServer
        self.delegate = delegate
        
        self.navigationController.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(named: "Settings"), tag: 0)

    }
    
    override func start() {
        showSettings()
    }
    
    func showSettings() {
        let viewController = SettingsTableViewController.instantiate()
        
        viewController.adServer = self.adServer
        viewController.coordinator = self
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showWalkthrough() {
        self.delegate.showAppWalkthrough()
    }
}
