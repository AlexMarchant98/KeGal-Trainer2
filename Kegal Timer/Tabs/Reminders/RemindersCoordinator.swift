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
    
    init() {
        self.navigationController = UINavigationController()
        
        let viewController = RemindersTableViewController.instantiate()
        viewController.tabBarItem = UITabBarItem(title: "Reminder", image: UIImage(named: "Reminder"), tag: 0)
        viewController.coordinator = self
        
        navigationController.viewControllers = [viewController]
    }
    
    /// Show the add reminder screen
    func showAddReminder()
    {
        let viewController = AddReminderTableViewController.instantiate()
        viewController.coordinator = self
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    /// Show the update reminder screen
    func showUpdateReminder(reminder: Reminder)
    {
        let viewController = UpdateReminderTableViewController.instantiate()
        viewController.coordinator = self
        viewController.reminder = reminder
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func didFinishWork()
    {
        navigationController.popViewController(animated: true)
        
        navigationController.dismiss(animated: true, completion: {})
    }
    
    func checkNotificationSettings()
    {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            
            /// Do not schedule notifications if not authorized.
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
