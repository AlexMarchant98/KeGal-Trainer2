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
    
    let navigationController: UINavigationController!
    let adServer: AdServer!
    let iapService: IAPServiceProtocol!
    
    let delegate: SettingsCoordinatorDelegate
    
    init(
        _ adServer: AdServer,
        _ iapService: IAPServiceProtocol,
        delegate: SettingsCoordinatorDelegate) {
        self.navigationController = UINavigationController()
        
        self.adServer = adServer
        self.iapService = iapService
        self.delegate = delegate
        
        self.navigationController.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(named: "Settings"), tag: 0)

    }
    
    override func start() {
        showSettings()
    }
    
    func showSettings() {
        let viewController = SettingsTableViewController.instantiate(storyboard: "Settings")
        
        let settingsPresenter = SettingsPresenter(
            iapService,
            with: viewController,
            delegate: self)
        
        viewController.adServer = self.adServer
        viewController.settingsPresenter = settingsPresenter
        
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension SettingsCoordinator: SettingsPresenterDelegate {
    func showWalkthrough() {
        self.delegate.showAppWalkthrough()
    }
}
