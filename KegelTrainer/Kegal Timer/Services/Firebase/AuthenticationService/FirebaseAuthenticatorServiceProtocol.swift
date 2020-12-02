//
//  FirebaseAuthenticatorProtocol.swift
//  PTFinder
//
//  Created by Alex Marchant on 26/01/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation

protocol FirebaseAuthenticatorServiceProtocol {
    
    func signUpWithEmail(
        withEmail email: String,
        password: String,
        completion: @escaping (FirestoreAuthenticatorResult) -> Void)
    
    func signInWithEmail(
        withEmail email: String,
        password: String,
        completion: @escaping (FirestoreAuthenticatorResult) -> Void)
    
    func authenticateWithAppleId(
        idToken: String,
        nonce: String,
        completion: @escaping (FirestoreAuthenticatorResult) -> Void)
    
    func resetPassword(
        email: String,
        completion: @escaping (FirestoreAuthenticatorResult) -> Void)
    
    func logout()
}
