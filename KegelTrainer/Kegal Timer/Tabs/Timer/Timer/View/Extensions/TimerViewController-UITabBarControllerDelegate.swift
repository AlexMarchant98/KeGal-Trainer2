//
//  TimerViewController-UITabBarControllerDelegate.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 01/12/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation
import UIKit

extension TimerViewController: UITabBarControllerDelegate {
    
    func setupTabBarDelegate() {
        self.tabBarController?.delegate = self
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        self.resetTimer()
        
        return true
    }
}

