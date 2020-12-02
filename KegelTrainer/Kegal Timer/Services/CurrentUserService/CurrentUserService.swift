//
//  CurrentUserService.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 14/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation
import FirebaseFirestore

enum CurrentUserServiceError: Error {
    case invalidUserId
}

class CurrentUserService: CurrentUserServiceProtocol {
    
    var firebaseCrashlytics: FirebaseCrashlyticsServiceProtocol
    var firestoreRepository: FirestoreRepositoryServiceProtocol
    
    private (set) var listenerId: String?
    
    private (set) var user: FIRProfile?
    
    static let shared = CurrentUserService()
    
    init() {
        self.firebaseCrashlytics = FirebaseCrashlyticsService()
        self.firestoreRepository = FirestoreRepositoryService(firebaseCrashlytics)
    }
    
    func setUser(user: FIRProfile) throws {
        guard let userId = user.id else {
            throw CurrentUserServiceError.invalidUserId
        }
        
        self.user = user
        setupAccountListener(docId: userId)
    }
    
    func setupAccountListener(docId: String) {
        
        if let id = listenerId {
            firestoreRepository.removeListener(with: id)
        }
        
        listenerId = self.firestoreRepository.readById(
            docId: docId,
            from: FIRCollectionPath(in: FIRCollectionReference.profiles),
            returning: FIRProfile.self,
            withSnapshotListener: true) { (result, profile) in
                
                switch result.succeeded {
                case false:
                    self.firebaseCrashlytics.writeLog(message: "ERROR: Failed to get latest account updates")
                case true:
                    if let profile = profile {
                        self.user = profile
                    } else {
                        self.firebaseCrashlytics.writeLog(message: "ERROR: Latest account updates returned an account object that was nil")
                    }
                }
        }
    }
    
    func updateUser(_ profile: FIRProfile) {
        
        self.user = profile
        
        self.firestoreRepository.update(
            for: profile,
            in: FIRCollectionPath(in: FIRCollectionReference.profiles)) { result in
            switch result.succeeded {
            case false:
                self.firebaseCrashlytics.writeLog(message: "ERROR: Failed to update user account object")
            case true:
                print("Updated user profile object")
            }
        }
    }
    
    func logoutCurrentUser() {
        if let listenerId = listenerId {
            firestoreRepository.removeListener(with: listenerId)
        }
        
        self.user = nil
        
        self.listenerId = nil
    }
    
}

extension CurrentUserService {
    func setMockUserData(
        _ profile: FIRProfile,
        _ firestoreRepository: FirestoreRepositoryService,
        _ firebaseCrashlyticsService: FirebaseCrashlyticsServiceProtocol) {
        
        self.user = profile
        self.firestoreRepository = firestoreRepository
        self.firebaseCrashlytics = firebaseCrashlyticsService
    }
}
