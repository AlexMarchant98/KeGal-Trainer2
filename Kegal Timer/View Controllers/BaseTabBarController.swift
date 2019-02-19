//
//  BaseTabBarController.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 13/11/2018.
//  Copyright © 2018 Alex Marchant. All rights reserved.
//

import UIKit
import UserNotifications

class BaseTabBarController: UITabBarController {
    @IBInspectable var defaultIndex: Int = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = defaultIndex
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        if item.title == "Reminders" {
            UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                // Do not schedule notifications if not authorized.
                guard settings.authorizationStatus != .authorized else {return}
                
                let action = UIAlertAction(title: "OK", style: .default, handler: { (nil) in
                    self.selectedIndex = 1
                })
                let alert = UIAlertController(title: "Notifications Disabled", message: "You have disabled notifications for KeGal Trainer. \n\n Please go to Settings > KeGal Trainer and enable notifications to setup reminders.", preferredStyle: .alert)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
