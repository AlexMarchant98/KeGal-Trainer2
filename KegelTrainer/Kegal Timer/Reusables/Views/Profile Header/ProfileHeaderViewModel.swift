//
//  ProfileHeaderViewModel.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 14/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation

class ProfileHeaderViewModel {
    
    let username: String
    let totalPoints: Int64
    let joinDate: String
    let profilePictureUrl: URL?
    let firebaseCloudStorageService: FirebaseCloudStorageServiceProtocol
    let delegate: ProfileHeaderViewDelegate
    
    init(
        _ username: String,
        _ totalPoints: Int64,
        _ joinDate: Date,
        profilePictureUrl: String?,
        _ firebaseCloudStorageService: FirebaseCloudStorageServiceProtocol,
        delegate: ProfileHeaderViewDelegate) {
        
        self.username = username
        self.totalPoints = totalPoints
        self.firebaseCloudStorageService = firebaseCloudStorageService
        self.delegate = delegate
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        self.joinDate = dateFormatter.string(from: joinDate)
        
        if let url = profilePictureUrl {
            self.profilePictureUrl = URL(string: url)!
        } else {
            self.profilePictureUrl = nil
        }
        
    }
    
}
