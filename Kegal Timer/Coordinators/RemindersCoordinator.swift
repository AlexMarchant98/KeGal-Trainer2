//
//  RemindersCoordinator.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 06/06/2019.
//  Copyright © 2019 Alex Marchant. All rights reserved.
//

import UIKit
import UserNotifications

class RemindersCoordinator: Coordinator {
    let navigationController: UINavigationController
    
    func start() {
        let vc: RemindersTableViewController = RemindersTableViewController.instantiate()
        navigationController.tabBarItem = UITabBarItem(title: "Reminders", image: UIImage(named: "Reminders"), selectedImage: nil)
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.pushViewController(vc, animated: false)
        vc.coordinator = self
    }
    
    init() {
        navigationController = UINavigationController()
    }
    
    func checkNotificationSettings()
    {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            // Do not schedule notifications if not authorized.
            guard settings.authorizationStatus != .authorized else {return}
            
            let action = UIAlertAction(title: "OK", style: .default, handler: { (nil) in
                self.navigationController.tabBarController?.selectedIndex = 1
            })
            
            let alert = UIAlertController(title: "Notifications Disabled", message: "You have disabled notifications for KeGal Trainer. \n\n Please go to Settings > KeGal Trainer and enable notifications to setup reminders.", preferredStyle: .alert)
            alert.addAction(action)
            self.navigationController.present(alert, animated: true, completion: nil)
        }
    }
}
