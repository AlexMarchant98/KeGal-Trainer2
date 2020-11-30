//
//  ProfilePresenter.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 14/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation

protocol ProfilePresenterView {
    func didGetServices(_ firebaseCloudStorageService: FirebaseCloudStorageServiceProtocol)
    func didLoadIAPInformation(title: String, description: String, localPrice: String)
}

protocol ProfilePresenterDelegate {
    func showWorkoutTracker()
    func editProfile()
    func didEarnPoints(_ pointsEarned: Double)
    func displayLeaderboard()
}

class ProfilePresenter: ProfilePresenterProtocol {
    
    let iAPService: IAPServiceProtocol
    let firebaseCloudStorageService: FirebaseCloudStorageServiceProtocol
    
    let view: ProfilePresenterView
    let delegate: ProfilePresenterDelegate
    
    init(
        _ iAPService: IAPServiceProtocol,
        _ firebaseCloudStorageService: FirebaseCloudStorageServiceProtocol,
        with view: ProfilePresenterView,
        delegate: ProfilePresenterDelegate) {
        
        self.iAPService = iAPService
        self.firebaseCloudStorageService = firebaseCloudStorageService
        self.view = view
        self.delegate = delegate
        
    }
    
    func getServices() {
        self.view.didGetServices(firebaseCloudStorageService)
    }
    
    func showWorkoutTracker() {
        self.delegate.showWorkoutTracker()
    }
    
    func editProfile() {
        self.delegate.editProfile()
    }
    
    func didWatchAdvert() {
        
        if var currentUser = CurrentUserService.shared.user {
            
            if((currentUser.daily_points + Constants.pointsForWatchingAnAdvert) >= Constants.maxDailyPoints) {
                
                
                let remainingDailyPoints = Constants.maxDailyPoints - Constants.pointsForWatchingAnAdvert
                
                currentUser.daily_points += remainingDailyPoints
                currentUser.total_points += Int64(remainingDailyPoints)
                
            } else {
                
                currentUser.daily_points += Int(Constants.pointsForWatchingAnAdvert)
                currentUser.total_points += Int64(Constants.pointsForWatchingAnAdvert)
                
            }
            
            CurrentUserService.shared.updateUser(currentUser)
            
            self.delegate.didEarnPoints(Double(Constants.pointsForWatchingAnAdvert))
        }
    }
    
    func ratedApp() {
        if var currentUser = CurrentUserService.shared.user {
            
            if(currentUser.has_rated_app) {
                return
            }
            
            currentUser.total_points += Int64(Constants.pointsForRatingApp)
            currentUser.has_rated_app = true
            
            CurrentUserService.shared.updateUser(currentUser)
            
            self.delegate.didEarnPoints(Double(Constants.pointsForRatingApp))
        }
    }
    
    func reviewedApp() {
        if var currentUser = CurrentUserService.shared.user {
            
            if(currentUser.has_reviewed_app) {
                return
            }
            
            currentUser.total_points += Int64(Constants.pointsForReviewingApp)
            currentUser.has_reviewed_app = true
            
            CurrentUserService.shared.updateUser(currentUser)
            
            self.delegate.didEarnPoints(Double(Constants.pointsForReviewingApp))
        }
    }
    
    func showLeaderboard() {
        self.delegate.displayLeaderboard()
    }
    
    func getStreakProtectorIAPInformation() {
        if let product = iAPService.getLoadedIAPProduct(with: IAPProducts.streakProtector) {
            self.view.didLoadIAPInformation(
                title: product.localizedTitle,
                description: product.localizedDescription,
                localPrice: "\(product.priceLocale.currencySymbol ?? "")\(product.price)")
        } else {
            purchaseStreakProtector()
        }
    }
    
    func purchaseStreakProtector() {
        iAPService.purchaseStreakProtector()
    }
    
    func addStreakProtector(add streakProtectors: Int) {
        var currentUser = CurrentUserService.shared.user!
        
        currentUser.streak_protectors += streakProtectors
        
        CurrentUserService.shared.updateUser(currentUser)
    }
}
