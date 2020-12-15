//
//  SettingsTableViewController-UITabBarControllerDelegate.swift.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 27/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation
import UIKit

extension SettingsTableViewController: UITabBarControllerDelegate {
    
    func setupTabBarDelegate() {
        self.tabBarController?.delegate = self
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if(dirtyInput) {
            
            AlertHandlerService.shared.showCustomAlert(
                view: self,
                title: localizedString(forKey: "unsaved_changes"),
                message: localizedString(forKey: "unsaved_changes_message"),
                actionTitles: [localizedString(forKey: "cancel"), localizedString(forKey: "continue")],
                actions: [
                    { (action: UIAlertAction!) in
                        print("Do nothing")
                    },
                    { (action: UIAlertAction!) in
                        self.dirtyInput = false;
                        tabBarController.selectedViewController = viewController
                    }
                ]
            )

            return false
        } else {
            return true
        }
    }
}