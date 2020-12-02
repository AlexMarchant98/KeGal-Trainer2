//
//  TabBarCoordinator.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 05/06/2019.
//  Copyright © 2019 Alex Marchant. All rights reserved.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    
    let notificationCenter = NotificationCenter.default
    
    var iapErrorNotificationObserver: NSObjectProtocol?
    
    let iapService: IAPServiceProtocol
    let firestoreRepositoryService: FirestoreRepositoryServiceProtocol
    let firebaseCloudStorageService: FirebaseCloudStorageServiceProtocol
    let firebaseCrashlyticsService: FirebaseCrashlyticsServiceProtocol
    let firebaseAuthenticatorService: FirebaseAuthenticatorServiceProtocol
    
    let userPreferences = UserDefaults.standard
    
    var adServer: AdServer!
    var profileCoordinator: ProfileCoordinator!
    var stagesCoordinator: StagesCoordinator!
    var timerCoordinator: TimerCoordinator!
    var remindersCoordinator: RemindersCoordinator!
    var settingsCoordinator: SettingsCoordinator!
    
    // MARK: - Init
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        self.iapService = IAPService()
        self.adServer = AdServer()
        
        self.firebaseCrashlyticsService = FirebaseCrashlyticsService()
        self.firebaseAuthenticatorService = FirebaseAuthenticatorService(firebaseCrashlyticsService)
        self.firebaseCloudStorageService = FirebaseCloudStorageService(firebaseCrashlyticsService)
        self.firestoreRepositoryService = FirestoreRepositoryService(firebaseCrashlyticsService)
        
        super.init()
        
        self.profileCoordinator = ProfileCoordinator(
            adServer,
            iapService,
            firestoreRepositoryService,
            firebaseCloudStorageService,
            firebaseAuthenticatorService,
            delegate: self)
        self.stagesCoordinator = StagesCoordinator(adServer)
        self.timerCoordinator = TimerCoordinator(adServer)
        self.remindersCoordinator = RemindersCoordinator(adServer)
        self.settingsCoordinator = SettingsCoordinator(adServer, iapService, delegate: self)
        
        ErrorScreensCoordinator.shared.navigationController = self.navigationController
        ErrorScreensCoordinator.shared.delegate = self
    }
    
    override func start() {
        
        let tabBarController = UITabBarController()
        
        
        if #available(iOS 12.0, *) {
            if tabBarController.traitCollection.userInterfaceStyle == .dark {
                tabBarController.tabBar.unselectedItemTintColor = .leaderboardGray
                tabBarController.tabBar.tintColor = UIColor.white
            } else {
                tabBarController.tabBar.tintColor = UIColor.workoutBackgroundColor
            }
        } else {
            tabBarController.tabBar.tintColor = UIColor.workoutBackgroundColor
        }
        
        profileCoordinator.start()
        stagesCoordinator.start()
        timerCoordinator.start()
        remindersCoordinator.start()
        settingsCoordinator.start()
        
        tabBarController.viewControllers = [
            profileCoordinator.navigationController,
            stagesCoordinator.navigationController,
            timerCoordinator.navigationController,
            remindersCoordinator.navigationController,
            settingsCoordinator.navigationController]
        
        tabBarController.selectedIndex = 0
        
        self.navigationController.pushViewController(tabBarController, animated: true)
        
        self.navigationController.hideKeyboardWhenTappedAround()
        
        iapErrorNotificationObserver = notificationCenter
            .addObserver(forName: .iapErrorNotification,
                         object: nil,
                         queue: nil) { [weak self] (notification) in
                
                guard let self = self else {
                    return
                }
                
                if let iapNotification = notification.userInfo?[Constants.iapNotificationUserInfoKey] as? IAPNotification {
                    AlertHandlerService.shared.showWarningAlert(
                        view: self.navigationController,
                        message: iapNotification.message)
                }
        }
        
    }
    
    func showWalkthroughOnStartup() {
        self.showWalkthrough(walkthroughType: .firstLaunchAppWalkthrough)
    }
    
    private func showWalkthrough(walkthroughType: WalkthroughType) {
        
        let walkthroughCoordinator = WalkthroughCoordinator(
            self.navigationController,
            walkthroughType)
        
        walkthroughCoordinator.delegate = self
            
        self.addChildCoordinator(walkthroughCoordinator)
        
        walkthroughCoordinator.start()
    }
    
}

extension AppCoordinator: WalkthroughCoordinatorDelegate {
    func didFinishWalkthrough(_ walkthroughCoordinator: WalkthroughCoordinator) {
        walkthroughCoordinator.navigationController.dismiss(animated: true)
        self.removeChildCoordinator(walkthroughCoordinator)
    }
}

extension AppCoordinator: ProfileCoordinatorDelegate {
    func showProfileWalkthrough(walkthroughType: WalkthroughType) {
        showWalkthrough(walkthroughType: walkthroughType)
    }
}

extension AppCoordinator: SettingsCoordinatorDelegate {
    func showWalkthrough(_ walkthroughType: WalkthroughType) {
        self.showWalkthrough(walkthroughType: walkthroughType)
    }
}

extension AppCoordinator: ErrorScreensCoordinatorDelegate {
}
