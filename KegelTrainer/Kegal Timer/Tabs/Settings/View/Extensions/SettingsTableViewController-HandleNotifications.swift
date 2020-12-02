//
//  SettingsTableViewController-HandleNotifications.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 27/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation
import UIKit

extension SettingsTableViewController {
    
    func registerForNotifications() {
        
        iapErrorNotificationObserver = notificationCenter
            .addObserver(forName: .iapErrorNotification,
                         object: nil,
                         queue: nil) { [weak self] (notification) in
                
                guard let self = self else {
                    return
                }
                
                self.setLoading(isLoading: false)
                
            }
        
        iapAdRemovalPurchaseNotificationObserver = notificationCenter
            .addObserver(forName: .iapAdRemovalPurchaseNotification,
                         object: nil,
                         queue: nil) { [weak self] (notification) in
                
                guard let self = self else {
                    return
                }
                
                self.setLoading(isLoading: false)
                
                if let iapNotification = notification.userInfo?[Constants.iapNotificationUserInfoKey] as? IAPNotification {
                    
                    if(iapNotification.successful) {
                        
                        AlertHandlerService.shared.showCustomAlert(
                            view: self,
                            title: "Adverts Removed",
                            message: "Thank you for purchasing removal of adverts! You may need to restart the app for it to take affect.",
                            actionTitles: ["Perfect"],
                            actions: [
                                { (action: UIAlertAction!) in print("Do nothing") }
                            ]
                        )
                        
                        self.tableView.reloadRows(at: [IndexPath(row: 0, section: 3)], with: .automatic)
                        
                    } else {
                        AlertHandlerService.shared.showCustomAlert(
                            view: self,
                            title: "Purchase Failed",
                            message: iapNotification.message,
                            actionTitles: ["Ok"],
                            actions: [
                                { (action: UIAlertAction!) in print("Do nothing") }
                            ]
                        )
                    }
                }
            }
    }
}
