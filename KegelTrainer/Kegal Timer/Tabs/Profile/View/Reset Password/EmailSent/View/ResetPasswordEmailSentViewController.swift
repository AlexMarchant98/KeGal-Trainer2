//
//  ResetPasswordEmailSentViewController.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 29/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import UIKit

class ResetPasswordEmailSentViewController: UIViewController, Storyboarded {
        
    var resetPasswordEmailSentPresenter: ResetPasswordEmailSentPresenterProtocol!
    
    @IBOutlet weak var emailSentLabel: KTBody!
    @IBOutlet weak var showLoginButton: KTPrimaryButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .workoutBackgroundColor
        
        emailSentLabel.text = "A password reset email has been sent to your email.\n\nFollow the link in the email to reset your password.\n\nPlease check your spam/junk folders if you cannot find it in your normal inbox."
        emailSentLabel.numberOfLines = 0
        
        emailSentLabel.textAlignment = .center
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        resetPasswordEmailSentPresenter.showLogin()
    }

}

extension ResetPasswordEmailSentViewController: ResetPasswordEmailSentPresenterView { }

