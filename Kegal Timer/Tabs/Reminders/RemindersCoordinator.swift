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
    
    var navigationController: UINavigationController!
    var adMobService: AdMobService!
    
    required init(_ adMobService: AdMobService) {
        self.navigationController = UINavigationController()
        
        self.adMobService = adMobService
        
        self.navigationController.tabBarItem = UITabBarItem(title: "Reminder", image: UIImage(named: "Reminder"), tag: 0)
        
        showReminders()
    }
    
    func showReminders() {
        let viewController = RemindersTableViewController.instantiate()
        
        viewController.adMobService = self.adMobService
        viewController.delegate = self
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showAddReminder()
    {
        let viewController = AddReminderTableViewController.instantiate()
        viewController.delegate = self
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showUpdateReminder(reminder: Reminder)
    {
        let viewController = UpdateReminderTableViewController.instantiate()
        viewController.delegate = self
        viewController.reminder = reminder
        
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension RemindersCoordinator: RemindersTableViewControllerDelegate {
    func didTapAddReminder() {
        self.showAddReminder()
    }
    
    func didTapUpdateReminder(_ reminder: Reminder) {
        self.showUpdateReminder(reminder: reminder)
    }
}

extension RemindersCoordinator: AddReminderTableViewControllerDelegate {
    func didAddReminder(_ addReminderTableViewController: AddReminderTableViewController) {
        self.navigationController.popViewController(animated: true)
    }
}

extension RemindersCoordinator: UpdateReminderTableViewControllerDelegate {
    func didFinishUpdatingReminder(_ updateReminderTableViewController: UpdateReminderTableViewController) {
        self.navigationController.popViewController(animated: true)
    }
}
