//
//  UIApplicationHelperService.swift
//  PTHub
//
//  Created by Alex Marchant on 18/10/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation
import UIKit

class UIApplicationHelperService: UIApplicationHelperServiceProtocol {
    
    init() { }
    
    func openSettingsUrl() {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
    }
}
