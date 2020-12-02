//
//  ViewLeaderboardPresenter.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 24/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation

protocol ViewLeaderboardPresenterDelegate {
    func closeLeaderboard()
}

protocol ViewLeaderboardPresenterView {
    func didGetInitalProfileSet(_ profiles: [FIRProfile], _ firebaseCloudStorageService: FirebaseCloudStorageServiceProtocol)
    func didGetLeaderboardSet(_ profiles: [FIRProfile])
    func didGetCurrentUserRank(_ rank: Int)
    func allProfilesLoaded()
    func errorOccurred(message: String)
}

class ViewLeaderboardPresenter: ViewLeaderboardPresenterProtocol {
    
    let firestoreRepositoryService: FirestoreRepositoryServiceProtocol
    let firebaseCloudStorageService: FirebaseCloudStorageServiceProtocol
    
    let delegate: ViewLeaderboardPresenterDelegate
    let view: ViewLeaderboardPresenterView
    
    init(
        _ firestoreRepositoryService: FirestoreRepositoryServiceProtocol,
        _ firebaseCloudStorageService: FirebaseCloudStorageServiceProtocol,
        with view: ViewLeaderboardPresenterView,
        delegate: ViewLeaderboardPresenterDelegate) {
        
        self.firestoreRepositoryService = firestoreRepositoryService
        self.firebaseCloudStorageService = firebaseCloudStorageService
        self.view = view
        self.delegate = delegate
        
    }
    
    func getInitialLeaderboardSet() {
        firestoreRepositoryService.setupLeaderboardProfilesQuery() { [weak self] (result, profiles, allProfilesLoaded) in
            self?.handleReturnedProfiles(result, profiles, allProfilesLoaded, isInitialLoad: true)
        }
    }
    
    func loadNextProfileSet() {
        firestoreRepositoryService.getLeaderboardProfiles() { [weak self] (result, profiles, allProfilesLoaded) in
            self?.handleReturnedProfiles(result, profiles, allProfilesLoaded, isInitialLoad: false)
        }
    }
    
    internal func handleReturnedProfiles(
        _ result: DatabaseResult,
        _ profiles: [FIRProfile],
        _ allProfilesLoaded: Bool,
        isInitialLoad: Bool) {
        switch result.succeeded {
        case true:
            if(allProfilesLoaded) {
                self.view.allProfilesLoaded()
                return
            } else {
                if(isInitialLoad) {
                    self.view.didGetInitalProfileSet(profiles, self.firebaseCloudStorageService)
                } else {
                    self.view.didGetLeaderboardSet(profiles)
                }
            }
            
        case false:
            self.view.errorOccurred(message: "Failed to load profiles, please try again.")
        }
    }
    
    func getMyRank() {
        // I want to get my position in the leaderboard
        // It should give me my position
    }
    
    func closeLeaderboard() {
        self.delegate.closeLeaderboard()
    }
    
}
