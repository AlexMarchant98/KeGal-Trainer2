//
//  Coordinator.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 04/06/2019.
//  Copyright © 2019 Alex Marchant. All rights reserved.
//

import Foundation
import UIKit

protocol CoordinatorProtocol: class {
    func start()
}

class Coordinator: CoordinatorProtocol {
    
    private(set) var childCoordinators: [Coordinator] = []
    
    func start() {
        preconditionFailure("This method needs to be overriden by a concrete subclass.")
    }
    
    func addChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func removeChildCoordinator(_ coordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(of: coordinator) {
            childCoordinators.remove(at: index)
        } else {
            print("Couldn't remove coordinator: \(coordinator). It's not a child coordinator.")
        }
    }
    
    func removeAllChildCoordinatorsWith<T>(type: T.Type) {
        childCoordinators = childCoordinators.filter { $0 is T  == false }
    }
    
    func removeAllChildCoordinators() {
        childCoordinators.removeAll()
    }
    
    func removeLastChildCoordinators() {
        if let lastCoordinator = childCoordinators.last {
            removeChildCoordinator(lastCoordinator)
        }
    }
}

extension Coordinator: Equatable {
    static func == (lhs: Coordinator, rhs: Coordinator) -> Bool {
        return lhs === rhs
    }
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
