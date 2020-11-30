//
//  ProfileCoordinator.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 14/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation
import UIKit

protocol ProfileCoordinatorDelegate {
    func showProfileWalkthrough(walkthroughType: WalkthroughType)
}

class ProfileCoordinator: Coordinator {
    
    let navigationController: UINavigationController
    let firestoreRepositoryService: FirestoreRepositoryServiceProtocol
    let firebaseCloudStorageService: FirebaseCloudStorageServiceProtocol
    let firebaseAuthenticatorService: FirebaseAuthenticatorServiceProtocol
    let adServer: AdServer
    let iapService: IAPServiceProtocol
    
    let delegate: ProfileCoordinatorDelegate
    
    init(
        _ adServer: AdServer,
        _ iapService: IAPServiceProtocol,
        _ firestoreRepositoryService: FirestoreRepositoryServiceProtocol,
        _ firebaseCloudStorageService: FirebaseCloudStorageServiceProtocol,
        _ firebaseAuthenticatorService: FirebaseAuthenticatorServiceProtocol,
        delegate: ProfileCoordinatorDelegate) {
        
        self.navigationController = UINavigationController()
        
        self.adServer = adServer
        self.iapService = iapService
        self.firestoreRepositoryService = firestoreRepositoryService
        self.firebaseCloudStorageService = firebaseCloudStorageService
        self.firebaseAuthenticatorService = firebaseAuthenticatorService
        self.delegate = delegate
        
        self.navigationController.isNavigationBarHidden = true
        self.navigationController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "profile-icon"), tag: 0)
    }
    
    override func start() {
        showLogin()
    }
    
    func showLogin() {
        let loginViewController = LoginViewController.instantiate(storyboard: "Login")
        
        let loginPresenter = LoginPresenter(
            firebaseAuthenticatorService,
            firestoreRepositoryService,
            with: loginViewController,
            delegate: self)
        
        loginViewController.loginPresenter = loginPresenter
        
        self.navigationController.pushViewController(loginViewController, animated: true)
    }
    
    func showSignup() {
        let signupViewController = SignupViewController.instantiate(storyboard: "Signup")
        
        let signupPresenter = SignupPresenter(
            firebaseAuthenticatorService,
            with: signupViewController,
            delegate: self)
        
        signupViewController.signupPresenter = signupPresenter
        
        self.navigationController.pushViewController(signupViewController, animated: true)
    }
    
    func showCreateProfile() {
        let createProfileViewController = CreateProfileViewController.instantiate(storyboard: "CreateProfile")
        
        let createProfilePresenter = CreateProfilePresenter(
            firestoreRepositoryService,
            firebaseCloudStorageService,
            with: createProfileViewController,
            delegate: self)
        
        createProfileViewController.createProfilePresenter = createProfilePresenter
        
        self.navigationController.pushViewController(createProfileViewController, animated: true)
    }
    
    func showProfile() {
        let profileViewController = ProfileViewController.instantiate(storyboard: "Profile")
        
        let profilePresenter = ProfilePresenter(
            iapService,
            firebaseCloudStorageService,
            with: profileViewController,
            delegate: self)
        
        profileViewController.adServer = adServer
        profileViewController.profilePresenter = profilePresenter
        
        self.navigationController.pushViewController(profileViewController, animated: true)
    }
    
    func showEditProfile() {
        let editProfileViewController = EditProfileViewController.instantiate(storyboard: "EditProfile")
        
        let editProfilePresenter = EditProfilePresenter(
            firestoreRepositoryService,
            firebaseCloudStorageService,
            with: editProfileViewController,
            delegate: self)
        
        editProfileViewController.editProfilePresenter = editProfilePresenter
        
        self.navigationController.pushViewController(editProfileViewController, animated: true)
    }
    
    func showTracker() {
        let viewController = TrackWorkoutsViewController.instantiate(storyboard: "TrackWorkouts")
        
        viewController.adServer = self.adServer
        
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    func showPointsEarnedPopup(_ pointsEarned: Double) {
        let viewController = WorkoutCompleteViewController.instantiate(storyboard: "WorkoutComplete")
        
        let presenter = WorkoutCompletePresenter(
            pointsEarned: pointsEarned,
            with: viewController,
            delegate: self,
            levelCompleted: nil)
        
        viewController.workoutCompletePresenter = presenter
        viewController.presentAsAlert()
        viewController.setupEarnPoints()
    }
    
    func showLeaderboard() {
        let viewLeaderboardViewController = ViewLeaderboardViewController.instantiate(storyboard: "ViewLeaderboard")
        
        let viewLeaderboardPresenter = ViewLeaderboardPresenter(
            firestoreRepositoryService,
            firebaseCloudStorageService,
            with: viewLeaderboardViewController,
            delegate: self)
        
        viewLeaderboardViewController.viewLeaderboardPresenter = viewLeaderboardPresenter
        
        self.navigationController.pushViewController(viewLeaderboardViewController, animated: true)
    }
    
    func showResetPassword() {
        let viewController = ResetPasswordViewController.instantiate(storyboard: "ResetPassword")
        
        let resetPasswordPresenter = ResetPasswordPresenter(
            self.firebaseAuthenticatorService,
            with: viewController,
            delegate: self)
        
        viewController.resetPasswordPresenter = resetPasswordPresenter
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showResetPasswordEmailSent() {
        let viewController = ResetPasswordEmailSentViewController.instantiate(storyboard: "ResetPasswordEmailSent")
        
        let resetPasswordEmailSentPresenter = ResetPasswordEmailSentPresenter(
            with: viewController,
            delegate: self)
        
        viewController.resetPasswordEmailSentPresenter = resetPasswordEmailSentPresenter
        
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension ProfileCoordinator: ProfilePresenterDelegate {
    func showWorkoutTracker() {
        self.showTracker()
    }
    
    func editProfile() {
        self.showEditProfile()
    }
    
    func didEarnPoints(_ pointsEarned: Double) {
        showPointsEarnedPopup(pointsEarned)
    }
    
    func displayLeaderboard() {
        showLeaderboard()
    }
}

extension ProfileCoordinator: LoginPresenterDelegate {
    
    func displaySignup() {
        showSignup()
    }
    
    func didTapForgotPassword() {
        self.showResetPassword()
    }
    
    func createProfile() {
        showCreateProfile()
        self.navigationController.viewControllers.removeAll(where: { $0 is LoginViewController })
    }
    
    func didGetProfile() {
        showProfile()
        self.navigationController.viewControllers.removeAll(where: { $0 is LoginViewController })
    }
}

extension ProfileCoordinator: SignupPresenterDelegate {
    
    func didSignup() {
        showCreateProfile()
    }
    
    func displayLogin() {
        self.navigationController.popToRootViewController(animated: true)
    }
    
}

extension ProfileCoordinator: CreateProfilePresenterDelegate {
    func didSetupProfile() {
        showProfile()
        self.navigationController.viewControllers.removeAll(where: { $0 is CreateProfileViewController })
        self.delegate.showProfileWalkthrough(walkthroughType: .profileCreatedWalkthrough)
    }
}

extension ProfileCoordinator: EditProfilePresenterDelegate {
    func didFinishUpdatingProfile() {
        self.navigationController.viewControllers.removeAll(where: { $0 is EditProfileViewController })
    }
}

extension ProfileCoordinator: WorkoutCompletePresenterDelegate {
    func closeWorkoutComplete() {
        // do something
    }
}

extension ProfileCoordinator: ViewLeaderboardPresenterDelegate {
    func closeLeaderboard() {
        self.navigationController.popToRootViewController(animated: true)
    }
}

extension ProfileCoordinator: ResetPasswordPresenterDelegate {
    func didTapShowLogin() {
        self.showLogin()
    }
    
    func emailSent() {
        self.showResetPasswordEmailSent()
    }
}

extension ProfileCoordinator: ResetPasswordEmailSentPresenterDelegate { }
