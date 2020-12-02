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
    let walkthroughType: WalkthroughType
    
    weak var delegate: WalkthroughCoordinatorDelegate?
    
    init(
        _ navigationController: UINavigationController,
        _ walkthroughType: WalkthroughType) {
        
        self.navigationController = navigationController
        self.walkthroughType = walkthroughType
        
        self.navigationController.isNavigationBarHidden = true
    }
    
    override func start() {
        showWalkthrough(walkthroughType)
    }
    
    func showWalkthrough(_ walkthroughType: WalkthroughType) {
        let walkthroughViewController = WalkthroughViewController.instantiate(storyboard: "Walkthrough")
        
        let walkthroughPresenter = WalkthroughPresenter(
            with: walkthroughViewController,
            delegate: self)
        
        walkthroughViewController.walkthroughType = walkthroughType
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

