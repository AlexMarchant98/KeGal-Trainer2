//
//  Coordinator.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 04/06/2019.
//  Copyright © 2019 Alex Marchant. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    
    var navigationController: UINavigationController! { get set }
    var adServer: AdServer! { get }
    
    init(_ adServer: AdServer)
}

extension Coordinator {
    func getAlertStyle() -> UIAlertController.Style {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            return UIAlertController.Style.actionSheet
        default:
            return UIAlertController.Style.alert
        }
    }
}
