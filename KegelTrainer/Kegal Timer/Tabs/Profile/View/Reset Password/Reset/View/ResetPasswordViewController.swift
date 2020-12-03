//
//  ResetPasswordViewController.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 29/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialTextFields

class ResetPasswordViewController: UIViewController, Storyboarded {
    
    var resetPasswordPresenter: ResetPasswordPresenterProtocol!
    
    @IBOutlet weak var emailTextBox: MDCTextField!
    @IBOutlet weak var resetPasswordButton: KTPrimaryButton!
    @IBOutlet weak var loadingView: LoadingView!
    
    var emailTextBoxController: MDCTextInputControllerOutlined!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .workoutBackgroundColor
        
        emailTextBox.setupToolbar(view: self.view)
        emailTextBox.delegate = self
        emailTextBox.textColor = .white
        emailTextBox.tintColor = .white

        emailTextBoxController = MDCTextInputControllerOutlined(textInput: emailTextBox)
        emailTextBoxController.setupKTTextFieldController()
        emailTextBoxController.placeholderText = localizedString(forKey: "email")
        emailTextBox.keyboardType = .emailAddress
    }
    
    @IBAction func resetPasswordButtonTapped(_ sender: Any) {
        setLoading(true)
        self.resetPasswordPresenter.resetPassword(email: emailTextBox.text)
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        resetPasswordPresenter.showLogin()
    }
    
    func setLoading(_ loading: Bool) {
        loadingView.setLoading(isLoading: loading)
        
        emailTextBox.isEnabled = !loading
        resetPasswordButton.isEnabled = !loading
    }

}

extension ResetPasswordViewController: ResetPasswordPresenterView {
    
    func errorOccurred(message: String) {
        setLoading(false)
        AlertHandlerService.shared.showWarningAlert(view: self, message: message)
    }
}

extension ResetPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
