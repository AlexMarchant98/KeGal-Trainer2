//
//  LoginPresenterProtocol.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 14/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation

protocol LoginPresenterProtocol {
    func loginButtonTapped(_ email: String?, _ password: String?)
    func appleSignInButtonTapped(idToken: String, nonce: String)
    func displaySignup()
    func didTapForgotPassword()
}
