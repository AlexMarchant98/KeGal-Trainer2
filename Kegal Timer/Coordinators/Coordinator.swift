//
//  Coordinator.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 04/06/2019.
//  Copyright © 2019 Alex Marchant. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get }
    func start()
}
