//
//  SignupPresenterProtocol.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 24/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation

protocol SignupPresenterProtocol {
    func signupButtonTapped(email: String?, password: String?, confirmPassword: String?)
    func appleSignupButtonTapped(idToken: String, nonce: String)
    func showLogin()
}
