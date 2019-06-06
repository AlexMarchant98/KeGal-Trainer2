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
    
    func start() {
        let vc: TrackWorkoutsViewController = TrackWorkoutsViewController.instantiate()
        navigationController.tabBarItem = UITabBarItem(title: "Track", image: UIImage(named: "Track"), selectedImage: nil)
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.pushViewController(vc, animated: false)
        vc.coordinator = self
    }
    
    init() {
        navigationController = UINavigationController()
    }
}
