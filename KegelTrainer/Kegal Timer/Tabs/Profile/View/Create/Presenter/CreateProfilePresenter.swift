//
//  CreateProfilePresenter.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 14/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation

protocol CreateProfilePresenterDelegate {
    func showLogin()
    func didSetupProfile()
}

protocol CreateProfilePresenterView {
    func didGetServices(_ firebaseCloudStorageService: FirebaseCloudStorageServiceProtocol)
    func errorOccurred(message: String)
}

class CreateProfilePresenter: CreateProfilePresenterProtocol {
    
    let firestoreRepositoryService: FirestoreRepositoryServiceProtocol
    let firebaseCloudStorageService: FirebaseCloudStorageServiceProtocol
    
    let delegate: CreateProfilePresenterDelegate
    let view: CreateProfilePresenterView
    
    init(
        _ firestoreRepositoryService: FirestoreRepositoryServiceProtocol,
        _ firebaseCloudStorageService: FirebaseCloudStorageServiceProtocol,
        with view: CreateProfilePresenterView,
        delegate: CreateProfilePresenterDelegate) {
        
        self.firestoreRepositoryService = firestoreRepositoryService
        self.firebaseCloudStorageService = firebaseCloudStorageService
        self.view = view
        self.delegate = delegate
        
    }
    
    func getServices() {
        self.view.didGetServices(firebaseCloudStorageService)
    }
    
    func setupProfile(username: String, imageUrl: String?) {
        
        do {
            let ownerUid = try firestoreRepositoryService.currentUserId()
            var profile = FIRProfile(ownerUid: ownerUid, username: username, joinDate: Date())
            
            if let url = imageUrl {
                let _ = firebaseCloudStorageService.create(
                    localFileUrl: URL(string: url)!,
                    storagePath: FIRStoragePath(in: .profilePicture, ownerUid: ownerUid, named: UUID().uuidString)) { [weak self] (result, returnedUrl) in
                    
                    switch result.succeeded {
                    case true:
                        profile.profile_picture = returnedUrl
                        self?.createProfile(profile)
                    case false:
                        self?.view.errorOccurred(message: "Failed to upload your profile picture, please try again.")
                    }
                    
                }
            } else {
                createProfile(profile)
            }
        } catch {
            self.delegate.showLogin()
        }
    }
    
    func createProfile(_ profile: FIRProfile) {
        
        var uploadedProfile = profile
        
        firestoreRepositoryService.create(
            for: profile,
            in: FIRCollectionPath(in: .profiles)) { [weak self] (result, docId) in
            switch result.succeeded {
            case false:
                
                if let url = profile.profile_picture {
                    self?.firebaseCloudStorageService.delete(documentUrl: URL(string: url)!) { _ in }
                }
                
                self?.view.errorOccurred(message: "Failed to create your profile, please try again.")
            
            case true:
                uploadedProfile.id = docId
                CurrentUserService.shared.updateUser(uploadedProfile)
                self?.delegate.didSetupProfile()
            }
        }
    }
    
}
