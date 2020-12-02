//
//  ResetPasswordEmailSentPresenter.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 29/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation

protocol ResetPasswordEmailSentPresenterView {
}

protocol ResetPasswordEmailSentPresenterDelegate {
    func didTapShowLogin()
}

class ResetPasswordEmailSentPresenter: ResetPasswordEmailSentPresenterProtocol {
    
    let view: ResetPasswordEmailSentPresenterView
    let delegate: ResetPasswordEmailSentPresenterDelegate
    
    init(
        with view: ResetPasswordEmailSentPresenterView,
        delegate: ResetPasswordEmailSentPresenterDelegate) {
        
        self.view = view
        self.delegate = delegate
    }
    
    func showLogin() {
        self.delegate.didTapShowLogin()
    }
    
}
