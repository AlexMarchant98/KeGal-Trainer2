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
    
    func start() {
        let vc: StageTableViewController = StageTableViewController.instantiate()
        navigationController.tabBarItem = UITabBarItem(title: "Stages", image: nil, selectedImage: nil)
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.pushViewController(vc, animated: false)
        vc.coordinator = self
    }
    
    init() {
        navigationController = UINavigationController()
    }
}
