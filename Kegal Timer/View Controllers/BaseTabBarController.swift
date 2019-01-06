//
//  BaseTabBarController.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 13/11/2018.
//  Copyright © 2018 Alex Marchant. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {
    @IBInspectable var defaultIndex: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = defaultIndex
    }
}
