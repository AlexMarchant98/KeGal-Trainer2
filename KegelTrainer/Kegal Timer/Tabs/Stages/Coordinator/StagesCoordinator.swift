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
    
    init(_ adServer: AdServer) {
        self.navigationController = UINavigationController()
        
        self.adServer = adServer
    }
    
    override func start() {
        showStages()
    }
    
    func showStages() {
        
        let viewController = StageTableViewController.instantiate(storyboard: "Stages")
        
        viewController.adServer = self.adServer
        viewController.tabBarItem = UITabBarItem(title: localizedString(forKey: "stages"), image: UIImage(named: "Challenges"), tag: 0)
        viewController.coordinator = self
        
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
}
