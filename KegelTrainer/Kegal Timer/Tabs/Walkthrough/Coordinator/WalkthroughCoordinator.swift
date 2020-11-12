//
//  WalkthroughCoordinator.swift
//  PTFinder
//
//  Created by Alex Marchant on 28/07/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation
import UIKit

protocol WalkthroughCoordinatorDelegate: AnyObject {
    func didFinishWalkthrough(_ walkthroughCoordinator: WalkthroughCoordinator)
}

class WalkthroughCoordinator: Coordinator {
    
    let navigationController: UINavigationController
    let hasLaunchedBefore: Bool
    
    weak var delegate: WalkthroughCoordinatorDelegate?
    
    init(
        _ navigationController: UINavigationController,
        _ hasLaunchedBefore: Bool) {
        
        self.navigationController = navigationController
        self.hasLaunchedBefore = hasLaunchedBefore
        
        self.navigationController.isNavigationBarHidden = true
    }
    
    override func start() {
        showWalkthrough()
    }
    
    func showWalkthrough() {
        let walkthroughViewController = WalkthroughViewController.instantiate(storyboard: "Walkthrough")
        
        let walkthroughPresenter = WalkthroughPresenter(
            with: walkthroughViewController,
            delegate: self)
        
        walkthroughViewController.hasLaunchedBefore = hasLaunchedBefore
        walkthroughViewController.walkthroughPresenter = walkthroughPresenter
        
        walkthroughViewController.modalPresentationStyle = .overFullScreen
        
        self.navigationController.present(walkthroughViewController, animated: true, completion: nil)
    }
}

extension WalkthroughCoordinator: WalkthroughPresenterDelegate {
    func closeWalkthrough() {
        self.delegate?.didFinishWalkthrough(self)
    }
}

