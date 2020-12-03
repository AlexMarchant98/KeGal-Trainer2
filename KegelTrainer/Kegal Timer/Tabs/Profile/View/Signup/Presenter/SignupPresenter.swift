//
//  SignupPresenter.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 24/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation
import FirebaseAuth

protocol SignupPresenterView {
    func errorOccurred(message: String)
}

protocol SignupPresenterDelegate {
    func displayLogin()
    func didSignup()
}

class SignupPresenter: SignupPresenterProtocol {
    
    let view: SignupPresenterView
    let delegate: SignupPresenterDelegate
    
    let firebaseAuthenticatorService: FirebaseAuthenticatorServiceProtocol!
    
    init(
        _ firebaseAuthenticatorService: FirebaseAuthenticatorServiceProtocol,
        with view: SignupPresenterView,
        delegate: SignupPresenterDelegate) {
        
        self.firebaseAuthenticatorService = firebaseAuthenticatorService
        
        self.view = view
        self.delegate = delegate
    }
    
    func signupButtonTapped(email: String?, password: String?, confirmPassword: String?) {
        guard
            let email = email,
            let password = password,
            let confirmPassword = confirmPassword else {
                self.view.errorOccurred(message: "Please ensure all fields are filled out.")
                return
        }
        
        if(checkInputsAreValid(email, password, confirmPassword)) {
            signupWithEmail(email: email, password: password)
        }
    }
    
    func appleSignupButtonTapped(idToken: String, nonce: String) {
        firebaseAuthenticatorService.authenticateWithAppleId(idToken: idToken, nonce: nonce) { result in
            switch result {
            case .success:
                self.delegate.didSignup()
            case .failure(let error as NSError):
                switch error.code {
                case AuthErrorCode.accountExistsWithDifferentCredential.rawValue:
                    self.view.errorOccurred(message: localizedString(forKey: "apple_id_email_already_registered_error"))
                default:
                    self.view.errorOccurred(message: localizedString(forKey: "failed_to_login_error"))
                }
           }
        }
    }
    
    func showLogin() {
        self.delegate.displayLogin()
    }
    
    internal func checkInputsAreValid(_ email: String, _ password: String, _ confirmPassword: String) -> Bool {
        do {
            let _ = try email.validateText(validationType: ValidatorType.email)
            
            let _ = try password.validateText(validationType: ValidatorType.password)
            
            let _ = try confirmPassword.validateText(validationType: ValidatorType.requiredField(field: "Confirm Password"))
            
            if(!(password == confirmPassword)) {
                self.view.errorOccurred(message: localizedString(forKey: "passwords_dont_match_error"))
                return false
            }
            
            return true
        } catch {
            self.view.errorOccurred(message: (error as! ValidationError).message)
            
            return false
        }
    }
    
    internal func signupWithEmail(email: String, password: String) {
        
        firebaseAuthenticatorService.signUpWithEmail(withEmail: email, password: password) { result in
           switch result {
               case .success:
                    self.delegate.didSignup()
               case .failure(let error):
                self.view.errorOccurred(message: localizedString(forKey: "general_error"))
           }
        }
    }
    
}
