//
//  EditProfilePresenter.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 20/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation

protocol EditProfilePresenterDelegate {
    func didFinishUpdatingProfile()
}

protocol EditProfilePresenterView {
    func didGetServices(_ firebaseCloudStorageService: FirebaseCloudStorageServiceProtocol)
    func errorOccurred(message: String)
}

class EditProfilePresenter: EditProfilePresenterProtocol {
    
    let firestoreRepositoryService: FirestoreRepositoryServiceProtocol
    let firebaseCloudStorageService: FirebaseCloudStorageServiceProtocol
    
    let view: EditProfilePresenterView
    let delegate: EditProfilePresenterDelegate
    
    init(
        _ firestoreRepositoryService: FirestoreRepositoryServiceProtocol,
        _ firebaseCloudStorageService: FirebaseCloudStorageServiceProtocol,
        with view: EditProfilePresenterView,
        delegate: EditProfilePresenterDelegate) {
        
        self.firestoreRepositoryService = firestoreRepositoryService
        self.firebaseCloudStorageService = firebaseCloudStorageService
        self.view = view
        self.delegate = delegate
        
    }
    
    func getServices() {
        self.view.didGetServices(firebaseCloudStorageService)
    }

    func updateProfile(imageUrl: String) {
        
        guard let _ = CurrentUserService.shared.user else {
            self.view.errorOccurred(message: "Something went wrong, please restart the app")
            return
        }
        
        if let oldUrl = CurrentUserService.shared.user!.profile_picture {
            firebaseCloudStorageService.delete(
                documentUrl: URL(string: oldUrl)!,
                completion: { result in
                    if(!result.succeeded) {
                        if var currentProfile = CurrentUserService.shared.user {
                            currentProfile.images_to_delete.append(oldUrl)
                            CurrentUserService.shared.updateUser(currentProfile)
                        }
                    }
                })
        }
        
        let _ = firebaseCloudStorageService.create(
            localFileUrl: URL(string: imageUrl)!,
            storagePath: FIRStoragePath(
                in: .profilePicture,
                ownerUid: CurrentUserService.shared.user!.owner_uid,
                named: UUID().uuidString)) { [weak self] (result, returnedUrl) in
            
            switch result.succeeded {
            case true:
                if var currentProfile = CurrentUserService.shared.user {
                    currentProfile.profile_picture = returnedUrl
                    CurrentUserService.shared.updateUser(currentProfile)
                    self?.delegate.didFinishUpdatingProfile()
                }
            case false:
                self?.view.errorOccurred(message: "Failed to upload your profile picture, please try again.")
            }
        }
    }

    func cancel() {
        self.delegate.didFinishUpdatingProfile()
    }
    
}
