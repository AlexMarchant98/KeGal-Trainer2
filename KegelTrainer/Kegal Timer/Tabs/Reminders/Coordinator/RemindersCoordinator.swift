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
    var adServer: AdServer!
    
    init(_ adServer: AdServer) {
        self.navigationController = UINavigationController()
        
        self.adServer = adServer
        
        self.navigationController.tabBarItem = UITabBarItem(title: "Reminder", image: UIImage(named: "Reminder"), tag: 0)
    }
    
    override func start() {
        showReminders()
    }
    
    func showReminders() {
        let viewController = RemindersTableViewController.instantiate(storyboard: "Reminders")
        
        viewController.adServer = self.adServer
        viewController.delegate = self
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showAddReminder()
    {
        let viewController = AddReminderTableViewController.instantiate(storyboard: "AddReminder")
        viewController.delegate = self
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showUpdateReminder(reminder: Reminder)
    {
        let viewController = UpdateReminderTableViewController.instantiate(storyboard: "UpdateReminder")
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
