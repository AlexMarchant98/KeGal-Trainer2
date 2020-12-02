//
//  ProfileViewController.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 14/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, Storyboarded {
    
    let notificationCenter = NotificationCenter.default
    
    var didDismissInterstitialObserver: NSObjectProtocol?
    var didFailToLoadAdMobInterstitialObserver: NSObjectProtocol?
    var iapStreakProtectorPurchaseNotificationObserver: NSObjectProtocol?
    var iapSaveStreakPurchaseNotificationObserver: NSObjectProtocol?
    var iapErrorNotificationObserver: NSObjectProtocol?
    
    var profilePresenter: ProfilePresenterProtocol!
    var adServer: AdServer!
    
    @IBOutlet weak var viewLeaderboardView: ViewLeaderboardView!
    @IBOutlet weak var profileHeaderView: ProfileHeaderView!
    @IBOutlet weak var reclaimStreakView: ReclaimStreakView!
    @IBOutlet weak var dailyPointsView: DailyPointsView!
    @IBOutlet weak var currentWorkoutStreakView: CurrentWorkoutStreakView!
    @IBOutlet weak var profileTotalsView: ProfileTotalsView!
    @IBOutlet weak var earnPointsView: EarnPointsView!
    @IBOutlet weak var loadingView: LoadingView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet internal var scrollViewTopConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerForNotifications()
        
        self.view.backgroundColor = .backgroundColour
        
        viewLeaderboardView.delegate = self
        
        var statusHeight: CGFloat!
        
        if #available(iOS 13.0, *) {
             statusHeight = UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame.height
        } else {
            statusHeight = UIApplication.shared.statusBarFrame.height
        }
        
        scrollViewTopConstraint.constant = -statusHeight
        
        profileHeaderView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: profileHeaderView.bounds.height)
        profileHeaderView.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        profilePresenter.getServices()
        
        if(CurrentUserService.shared.user!.lost_streak != 0) {
            reclaimStreakView.model = ReclaimStreakViewModel(
                hasStreakToReclaim: true,
                lostStreak: CurrentUserService.shared.user!.lost_streak,
                daysLeftToReclaimStreak: CurrentUserService.shared.user!.days_left_to_reclaim_streak,
                delegate: self)
            reclaimStreakView.isHidden = false
        } else {
            reclaimStreakView.model = ReclaimStreakViewModel(
                hasStreakToReclaim: false,
                delegate: self)
            reclaimStreakView.isHidden = true
        }
        
        dailyPointsView.model = DailyPointsViewModel(CurrentUserService.shared.user!.daily_points)
        
        currentWorkoutStreakView.model = CurrentWorkoutStreakViewModel(
            CurrentUserService.shared.user!.workout_days_streak,
            CurrentUserService.shared.user!.streak_protectors,
            delegate: self)
        
        profileTotalsView.model = ProfileTotalsViewModel(
            totalWorkouts: CurrentUserService.shared.user!.total_workouts,
            totalWorkoutTime: CurrentUserService.shared.user!.total_workout_time,
            delegate: self)
        
        earnPointsView.model = EarnPointsViewModel(
            hasRatedApp: CurrentUserService.shared.user!.has_rated_app,
            hasReviewedApp: CurrentUserService.shared.user!.has_reviewed_app,
            delegate: self)
        
    }
    
    private func registerForNotifications() {
        
        didDismissInterstitialObserver = notificationCenter
            .addObserver(forName: .didDismissInterstitial,
                         object: nil,
                         queue: nil) { [weak self] (notification) in
                
                guard let self = self else {
                    return
                }
                
                if(self.tabBarController!.selectedIndex == 0) {
                    self.profilePresenter.didWatchAdvert()
                }
        }
        
        didFailToLoadAdMobInterstitialObserver = notificationCenter
            .addObserver(forName: .didFailToLoadAdMobInterstitial,
                         object: nil,
                         queue: nil) { [weak self] (notification) in
                
                guard let self = self else {
                    return
                }
                
                if(self.tabBarController!.selectedIndex == 0) {
                    self.profilePresenter.didWatchAdvert()
                }
        }
        
        iapErrorNotificationObserver = notificationCenter
            .addObserver(forName: .iapErrorNotification,
                         object: nil,
                         queue: nil) { [weak self] (notification) in
                
                guard let self = self else {
                    return
                }
                
                self.setLoading(isLoading: false)
                
            }
        
        iapStreakProtectorPurchaseNotificationObserver = notificationCenter
            .addObserver(forName: .iapStreakProtectorPurchaseNotification,
                         object: nil,
                         queue: nil) { [weak self] (notification) in
                
                guard let self = self else {
                    return
                }
                
                self.setLoading(isLoading: false)
                
                if let iapNotification = notification.userInfo?[Constants.iapNotificationUserInfoKey] as? IAPNotification {
                    
                    if(iapNotification.successful) {
                        self.profilePresenter.addStreakProtector(add: 1)
                        
                        self.currentWorkoutStreakView.model = CurrentWorkoutStreakViewModel(
                            CurrentUserService.shared.user!.workout_days_streak,
                            CurrentUserService.shared.user!.streak_protectors,
                            delegate: self)
                        
                        AlertHandlerService.shared.showCustomAlert(
                            view: self,
                            title: "Streak Protector Purchased",
                            message: iapNotification.message,
                            actionTitles: ["Perfect"],
                            actions: [
                                { (action: UIAlertAction!) in print("Do nothing") }
                            ]
                        )
                    } else {
                        AlertHandlerService.shared.showCustomAlert(
                            view: self,
                            title: "Purchase Failed",
                            message: iapNotification.message,
                            actionTitles: ["Ok"],
                            actions: [
                                { (action: UIAlertAction!) in print("Do nothing") }
                            ]
                        )
                    }
                }
        }
        
        iapSaveStreakPurchaseNotificationObserver = notificationCenter
            .addObserver(forName: .iapSaveStreakPurchaseNotification,
                         object: nil,
                         queue: nil) { [weak self] (notification) in
                
                guard let self = self else {
                    return
                }
                
                self.setLoading(isLoading: false)
                
                if let iapNotification = notification.userInfo?[Constants.iapNotificationUserInfoKey] as? IAPNotification {
                    
                    if(iapNotification.successful) {
                        self.profilePresenter.didSaveStreak()
                        
                        self.reclaimStreakView.isHidden = true
                        
                        self.reclaimStreakView.model = ReclaimStreakViewModel(
                            hasStreakToReclaim: false,
                            delegate: self)
                        
                        self.currentWorkoutStreakView.model = CurrentWorkoutStreakViewModel(
                            CurrentUserService.shared.user!.workout_days_streak,
                            CurrentUserService.shared.user!.streak_protectors,
                            delegate: self)
                        
                        AlertHandlerService.shared.showCustomAlert(
                            view: self,
                            title: "Streak Saved!",
                            message: "You have successfully saved your streak, also, we have given you a Streak Protector for free!",
                            actionTitles: ["Perfect"],
                            actions: [
                                { (action: UIAlertAction!) in print("Do nothing") }
                            ]
                        )
                    } else {
                        AlertHandlerService.shared.showCustomAlert(
                            view: self,
                            title: "Purchase Failed",
                            message: iapNotification.message,
                            actionTitles: ["Ok"],
                            actions: [
                                { (action: UIAlertAction!) in print("Do nothing") }
                            ]
                        )
                    }
                }
        }
    }
    
    private func deregisterNotifications() {
        if let didDismissInterstitialObserver = self.didDismissInterstitialObserver {
            notificationCenter.removeObserver(didDismissInterstitialObserver, name: .didDismissInterstitial, object: nil)
        }
        
        if let didFailToLoadAdMobInterstitialObserver = self.didFailToLoadAdMobInterstitialObserver {
            notificationCenter.removeObserver(didFailToLoadAdMobInterstitialObserver, name: .didFailToLoadAdMobInterstitial, object: nil)
        }
        
        if let iapStreakProtectorPurchaseNotificationObserver = self.iapStreakProtectorPurchaseNotificationObserver {
            notificationCenter.removeObserver(iapStreakProtectorPurchaseNotificationObserver, name: .iapStreakProtectorPurchaseNotification, object: nil)
        }
        
        if let iapErrorNotificationObserver = self.iapErrorNotificationObserver {
            notificationCenter.removeObserver(iapErrorNotificationObserver, name: .iapErrorNotification, object: nil)
        }
    }
    
    func setLoading(isLoading: Bool) {
        loadingView.setLoading(isLoading: isLoading)
        currentWorkoutStreakView.setLoading(isLoading)
    }

}

extension ProfileViewController: ProfilePresenterView {
    func didGetServices(_ firebaseCloudStorageService: FirebaseCloudStorageServiceProtocol) {
        profileHeaderView.model = ProfileHeaderViewModel(
            CurrentUserService.shared.user!.username,
            CurrentUserService.shared.user!.total_points,
            CurrentUserService.shared.user!.join_date,
            profilePictureUrl: CurrentUserService.shared.user!.profile_picture,
            firebaseCloudStorageService,
            delegate: self)
    }
    
    func didLoadIAPInformation(title: String, description: String, localPrice: String, product: String) {
        AlertHandlerService.shared.showCustomAlert(
            view: self,
            title: "\(title) for \(localPrice)",
            message: description,
            actionTitles: ["Cancel", "Purchase"],
            actions: [
                { (action: UIAlertAction!) in
                    self.setLoading(isLoading: false)
                },
                { (action: UIAlertAction!) in
                    
                    if(product == IAPProducts.saveLostStreak) {
                        self.profilePresenter.purchaseSaveStreak()
                    } else {
                        self.profilePresenter.purchaseStreakProtector()
                    }
                }
            ]
        )
    }
}

extension ProfileViewController: ProfileHeaderViewDelegate {
    func editProfile() {
        profilePresenter.editProfile()
    }
}

extension ProfileViewController: DailyStreakViewDelegate {
    func buyStreakProtector() {
        profilePresenter.getStreakProtectorIAPInformation()
        self.setLoading(isLoading: true)
    }
}

extension ProfileViewController: ProfileTotalsViewDelegate {
    func showWorkoutTracker() {
        self.profilePresenter.showWorkoutTracker()
    }
}

extension ProfileViewController: EarnPointsViewDelegate {
    
    func showAdvert() {
        adServer.displayInterstitialAd(viewController: self, userWantsToViewAd: true)
        
        adServer.reloadAds()
    }
    
    func ratedApp() {
        self.profilePresenter.ratedApp()
        
        earnPointsView.model = EarnPointsViewModel(
            hasRatedApp: true,
            hasReviewedApp: CurrentUserService.shared.user!.has_reviewed_app,
            delegate: self)
    }
    
    func reviewedApp() {
        self.profilePresenter.reviewedApp()
        
        earnPointsView.model = EarnPointsViewModel(
            hasRatedApp: CurrentUserService.shared.user!.has_rated_app,
            hasReviewedApp: true,
            delegate: self)
    }
    
}

extension ProfileViewController: ViewLeaderboardViewDelegate {
    func viewLeaderboard() {
        self.profilePresenter.showLeaderboard()
    }
}

extension ProfileViewController: ReclaimStreakViewDelegate {
    func reclaimStreak() {
        profilePresenter.getSaveStreakIAPInformation()
        self.setLoading(isLoading: true)
    }
}
