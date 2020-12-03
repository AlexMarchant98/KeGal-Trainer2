//
//  LoginPresenter.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 14/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation
import FirebaseAuth

protocol LoginPresenterView {
    func invalidCredentials(error: String)
}

protocol LoginPresenterDelegate {
    func createProfile()
    func didGetProfile()
    func displaySignup()
    func didTapForgotPassword()
}

class LoginPresenter: LoginPresenterProtocol {
    
    let view: LoginPresenterView
    let delegate: LoginPresenterDelegate
    
    let firebaseAuthenticatorService: FirebaseAuthenticatorServiceProtocol
    let firestoreRepositoryService: FirestoreRepositoryServiceProtocol
    
    init(
        _ firebaseAuthenticatorService: FirebaseAuthenticatorServiceProtocol,
        _ firestoreRepositoryService: FirestoreRepositoryServiceProtocol,
        with view: LoginPresenterView,
        delegate: LoginPresenterDelegate) {
        
        self.firebaseAuthenticatorService = firebaseAuthenticatorService
        self.firestoreRepositoryService = firestoreRepositoryService
        
        self.view = view
        self.delegate = delegate
    }
    
    func displaySignup() {
        self.delegate.displaySignup()
    }
    
    func didTapForgotPassword() {
        self.delegate.didTapForgotPassword()
    }
    
    internal func appleSignInButtonTapped(idToken: String, nonce: String) {
        firebaseAuthenticatorService.authenticateWithAppleId(idToken: idToken, nonce: nonce) { result in
            switch result {
            case .success:
                self.getAccountByOwnerId()
            case .failure(let error as NSError):
                switch error.code {
                case AuthErrorCode.userNotFound.rawValue:
                    self.view.invalidCredentials(error: localizedString(forKey: "user_does_not_exist_with_apple_id_error"))
                    break
                default:
                    self.view.invalidCredentials(error: localizedString(forKey: "failed_to_login_error"))
                }
            }
        }
    }
    
    internal func loginButtonTapped(_ email: String?, _ password: String?) {
        guard let email = email, let password = password else {
            self.view.invalidCredentials(error: localizedString(forKey: "enter_valid_credentials_error"))
            return
        }
        
        if(checkInputsAreValid(email, password)) {
            tryLoginWithEmail(email: email, password: password)
        }
    }
    
    internal func checkInputsAreValid(_ email: String, _ password: String) -> Bool {
        do {
            _ = try email.validateText(validationType: ValidatorType.email)
            _ = try password.validateText(validationType: ValidatorType.requiredField(field: "Password"))
            
            return true
        } catch {
            self.view.invalidCredentials(error: (error as! ValidationError).message)
            
            return false
        }
    }
    
    internal func tryLoginWithEmail(email: String, password: String) {
        firebaseAuthenticatorService.signInWithEmail(withEmail: email, password: password) { result in
            
           switch result {
           case .success:
                self.getAccountByOwnerId()
           case .failure(_):
                self.view.invalidCredentials(error: localizedString(forKey: "email_password_combination_incorrect_error"))
           }
        }
    }
    
    internal func getAccountByOwnerId() {
        
        do {
            let currentUserId = try firestoreRepositoryService.currentUserId()
            
            let _ = self.firestoreRepositoryService.readByQuery(
                from: FIRCollectionPath(in: .profiles),
                whereField: "owner_uid",
                queryType: FIRWhereQueryField.isEqualTo,
                valueIs: currentUserId,
                returning: FIRProfile.self,
                withSnapshotListener: false) { [weak self] (result, profiles) in
                
                switch result.succeeded {
                case true:
                    if let profile = profiles.first {
                        try! CurrentUserService.shared.setUser(user: profile)
                        self?.delegate.didGetProfile()
                    } else {
                        self?.delegate.createProfile()
                    }
                case false:
                    print("Failed to read account")
                }
            }
        } catch {
            self.view.invalidCredentials(error: localizedString(forKey: "general_error"))
        }
    }
}
