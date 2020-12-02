//
//  ResetPasswordPresenter.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 29/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation

protocol ResetPasswordPresenterView {
    func errorOccurred(message: String)
}

protocol ResetPasswordPresenterDelegate {
    func emailSent()
    func didTapShowLogin()
}

class ResetPasswordPresenter: ResetPasswordPresenterProtocol {
    
    let firebaseAuthenticatorService: FirebaseAuthenticatorServiceProtocol
    
    let view: ResetPasswordPresenterView
    let delegate: ResetPasswordPresenterDelegate
    
    init(
        _ firebaseAuthenticatorService: FirebaseAuthenticatorServiceProtocol,
        with view: ResetPasswordPresenterView,
        delegate: ResetPasswordPresenterDelegate) {
        
        self.firebaseAuthenticatorService = firebaseAuthenticatorService
        
        self.view = view
        self.delegate = delegate
    }
    
    func resetPassword(email: String?) {
        if(validateEmail(email: email)) {
            self.firebaseAuthenticatorService.resetPassword(email: email!) { [weak self] result in
                self?.delegate.emailSent()
            }
        }
    }
    
    func showLogin() {
        self.delegate.didTapShowLogin()
    }
    
    func validateEmail(email: String?) -> Bool {
        do {
            guard let email = email?.trimmingCharacters(in: .whitespacesAndNewlines) else {
                return false
            }
            _ = try email.validateText(validationType: ValidatorType.email)
            
            return true
        } catch {
            self.view.errorOccurred(message: (error as! ValidationError).message)
            
            return false
        }
    }
}

