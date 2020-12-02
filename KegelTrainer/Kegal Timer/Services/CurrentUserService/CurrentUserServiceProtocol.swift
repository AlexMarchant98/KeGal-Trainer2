//
//  CurrentUserServiceProtocol.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 14/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation
import FirebaseFirestore

protocol CurrentUserServiceProtocol {
    
    var firebaseCrashlytics: FirebaseCrashlyticsServiceProtocol { get set }
    var firestoreRepository: FirestoreRepositoryServiceProtocol { get set }
    
    var user: FIRProfile? { get }
    
    func setUser(user: FIRProfile) throws
    
    func setupAccountListener(docId: String)
    
    func updateUser(_ account: FIRProfile)
    
    func logoutCurrentUser()
}
