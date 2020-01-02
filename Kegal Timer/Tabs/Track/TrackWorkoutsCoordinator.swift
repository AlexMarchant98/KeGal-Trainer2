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
    
    var navigationController: UINavigationController!
    var admobService: AdMobDisplayer!
    
    required init(_ admobService: AdMobDisplayer) {
        self.navigationController = UINavigationController()
        self.navigationController.setNavigationBarHidden(true, animated: false)
        
        self.admobService = admobService
        
        let viewController = TrackWorkoutsViewController.instantiate()
        
        viewController.admobService = self.admobService
        viewController.tabBarItem = UITabBarItem(title: "Track", image: UIImage(named: "Calendar"), tag: 0)
        viewController.coordinator = self
        
        navigationController.viewControllers = [viewController]
    }
}
