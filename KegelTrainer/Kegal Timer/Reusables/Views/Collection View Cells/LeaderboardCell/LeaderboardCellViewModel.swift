//
//  LeaderboardCellViewModel.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 24/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation

class LeaderboardCellViewModel {
    
    let rank: Int?
    let profilePictureUrl: URL?
    let points: Int64
    let username: String
    let firebaseCloudStorageSerivce: FirebaseCloudStorageServiceProtocol
    
    init(
        rank: Int? = nil,
        points: Int64,
        username: String,
        _ firebaseCloudStorageSerivce: FirebaseCloudStorageServiceProtocol,
        profilePictureUrl: String? = nil) {
        
        self.rank = rank
        self.points = points
        self.username = username
        self.firebaseCloudStorageSerivce = firebaseCloudStorageSerivce
        
        if let url = profilePictureUrl {
            self.profilePictureUrl = URL(string: url)!
        } else {
            self.profilePictureUrl = nil
        }
    }
    
}
