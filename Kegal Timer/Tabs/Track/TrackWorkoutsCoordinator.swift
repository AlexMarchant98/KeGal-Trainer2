//
//  TrackWorkoutsCoordinator.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 06/06/2019.
//  Copyright © 2019 Alex Marchant. All rights reserved.
//

import Foundation
import UIKit

class TrackWorkoutsCoordinator: Coordinator {
    let navigationController: UINavigationController
    
    init() {
        self.navigationController = UINavigationController()
        self.navigationController.setNavigationBarHidden(true, animated: false)
        
        let viewController = TrackWorkoutsViewController.instantiate()
        viewController.tabBarItem = UITabBarItem(title: "Track", image: UIImage(named: "Calendar"), tag: 0)
        viewController.coordinator = self
        
        navigationController.viewControllers = [viewController]
    }
}
