//
//  ErrorPagesCoordinator.swift
//  PTFinder
//
//  Created by Alex Marchant on 22/04/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import UIKit

protocol ErrorScreensCoordinatorDelegate {
    func didTapSignup()
    func didTapLogin()
    func didTapDiscoverOthers()
    func didTapViewProfile()
}

extension ErrorScreensCoordinatorDelegate {
    func didTapSignup() { }
    func didTapLogin() { }
    func didTapDiscoverOthers() { }
    func didTapViewProfile() { }
}

class ErrorScreensCoordinator: Coordinator {
    
    static let shared = ErrorScreensCoordinator()
    
    var delegate: ErrorScreensCoordinatorDelegate?
    var navigationController: UINavigationController!
    
    override init() { }
    
    override func start() {
        // Don't do anything
    }
    
    func showEnablePhotoAccess() {
        let viewController = EnablePhotoAccessViewController.instantiate(storyboard: "EnablePhotoAccess")
        
        let enablePhotoAccessPresenter = EnablePhotoAccessPresenter(
            UIApplicationHelperService(),
            with: viewController,
            delegate: self)

        viewController.enablePhotoAccessPresenter = enablePhotoAccessPresenter
        
        DispatchQueue.main.async {
            self.navigationController.pushViewController(viewController, animated: true)
        }
    }
    
    func showConnectionRequired(_ networkManagerService: NetworkManagerService) {
        if let _ = CurrentUserService.shared.user {
            let viewController = ConnectionRequiredViewController.instantiate(storyboard: "ConnectionRequired")
            
            let connectionRequiredPresenter = ConnectionRequiredPresenter(
                    networkManagerService,
                    with: viewController,
                    delegate: self)

            viewController.connectionRequiredPresenter = connectionRequiredPresenter
            
            DispatchQueue.main.async {
                self.navigationController.pushViewController(viewController, animated: true)
            }
        }
    }
    
}

extension ErrorScreensCoordinator: EnablePhotoAccessPresenterDelegate {
    func didTapClose() {
        self.navigationController.popViewController(animated: true)
    }
}

extension ErrorScreensCoordinator: ConnectionRequiredPresenterDelegate {
    func connectionFound() {
        self.navigationController.popViewController(animated: true)
    }
}
