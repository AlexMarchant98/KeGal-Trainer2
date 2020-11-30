//
//  FirestoreAuthenticator.swift
//  PTFinder
//
//  Created by Alex Marchant on 06/01/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Firebase
import FirebaseAuth

class FirebaseAuthenticatorService: FirebaseAuthenticatorServiceProtocol {
    
    let firebaseCrashlyticsService: FirebaseCrashlyticsServiceProtocol
    
    init(_ firebaseCrashlyticsService: FirebaseCrashlyticsServiceProtocol) {
        self.firebaseCrashlyticsService = firebaseCrashlyticsService
    }
    
    func signUpWithEmail(
        withEmail email: String,
        password: String,
        completion: @escaping (FirestoreAuthenticatorResult) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            
            if let e = error {
                print(e.localizedDescription)
                return completion(FirestoreAuthenticatorResult.failure(e))
            } else {
                return completion(FirestoreAuthenticatorResult.success)
            }
        }
    }
    
    func signInWithEmail(
        withEmail email: String,
        password: String,
        completion: @escaping (FirestoreAuthenticatorResult) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let e = error {
                print(e.localizedDescription)
                return completion(FirestoreAuthenticatorResult.failure(e))
            } else {
                return completion(FirestoreAuthenticatorResult.success)
            }
        }
    }
    
    func authenticateWithAppleId(
        idToken: String,
        nonce: String,
        completion: @escaping (FirestoreAuthenticatorResult) -> Void) {
        
        let credential = OAuthProvider.credential(
            withProviderID: "apple.com",
            idToken: idToken,
            rawNonce: nonce)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                return completion(FirestoreAuthenticatorResult.failure(error))
            }
        
            return completion(FirestoreAuthenticatorResult.success)
        }
    }
    
    func resetPassword(email: String, completion: @escaping (FirestoreAuthenticatorResult) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                self.firebaseCrashlyticsService.writeLog(message: "ERROR: Password reset failed with error: \(error.localizedDescription)")
                return completion(FirestoreAuthenticatorResult.failure(error))
            }
            
            return completion(FirestoreAuthenticatorResult.success)
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Failed to logout user")
            print(error.localizedDescription)
        }
    }
    
}
