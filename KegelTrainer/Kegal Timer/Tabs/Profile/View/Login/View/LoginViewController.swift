//
//  LoginViewController.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 14/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import UIKit
import AuthenticationServices
import CryptoKit
import MaterialComponents.MaterialTextFields

class LoginViewController: UIViewController, Storyboarded {
    
    fileprivate var currentNonce: String?
    
    @IBOutlet weak var loginTitle: KTTitle!
    @IBOutlet weak var loginDescription: KTBody!
    @IBOutlet weak var emailTextBox: MDCTextField!
    @IBOutlet weak var passwordTextBox: MDCTextField!
    @IBOutlet weak var loginButton: KTPrimaryButton!
    @IBOutlet weak var forgotPasswordButton: KTPrimaryButtonInverted!
    @IBOutlet weak var appleButtonLocation: UIButton!
    @IBOutlet weak var signupButton: KTSecondaryButton!
    @IBOutlet weak var orLabel: KTHeader!
    
    var emailTextBoxController: MDCTextInputControllerOutlined!
    var passwordTextBoxController: MDCTextInputControllerOutlined!
    
    var loginPresenter: LoginPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .workoutBackgroundColor
        
        orLabel.textColor = .white
        
        self.loginTitle.textColor = .white
        self.loginDescription.textColor = .white
        
        emailTextBox.tintColor = .white
        emailTextBox.textColor = .appGreen
        passwordTextBox.tintColor = .white
        passwordTextBox.textColor = .appGreen
        
        emailTextBox.setupToolbar(view: self.view)
        passwordTextBox.setupToolbar(view: self.view)
        
        emailTextBox.delegate = self
        passwordTextBox.delegate = self

        emailTextBoxController = MDCTextInputControllerOutlined(textInput: emailTextBox)
        emailTextBoxController.setupKTTextFieldController()
        emailTextBoxController.placeholderText = localizedString(forKey: "email")
        emailTextBox.keyboardType = .emailAddress
        
        passwordTextBoxController = MDCTextInputControllerOutlined(textInput: passwordTextBox)
        passwordTextBoxController.setupKTTextFieldController()
        
        passwordTextBoxController.placeholderText = localizedString(forKey: "password")
        passwordTextBox.isSecureTextEntry = true
        
        appleButtonLocation.isEnabled = false
        
        if #available(iOS 13.0, *) {
            setupAppleButton()
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        setLoading(true)
        
        loginPresenter.loginButtonTapped(emailTextBox.text, passwordTextBox.text)
    }
    
    @IBAction func signupButtonTapped(_ sender: Any) {
        loginPresenter.displaySignup()
    }
    
    @IBAction func forgotPasswordButtonTapped(_ sender: Any) {
        loginPresenter.didTapForgotPassword()
    }
    
    func setLoading(_ loading: Bool) {
//        loadingView.setLoading(isLoading: loading)
        
        emailTextBox.isEnabled = !loading
        passwordTextBox.isEnabled = !loading
        loginButton.isEnabled = !loading
        forgotPasswordButton.isEnabled = !loading
        signupButton.isEnabled = !loading
    }
    
}

@available(iOS 13.0, *)
extension LoginViewController {
    
    func setupAppleButton() {
        var appleLoginBtn: ASAuthorizationAppleIDButton!
        
        appleLoginBtn = ASAuthorizationAppleIDButton(type: .signIn, style: .white)
        
        appleLoginBtn.addTarget(self, action: #selector(startSignInWithAppleFlow), for: .touchUpInside)
        
        self.view.addSubview(appleLoginBtn)
        
        appleLoginBtn.translatesAutoresizingMaskIntoConstraints = false
        appleLoginBtn.layer.cornerRadius = 10
        
        NSLayoutConstraint.activate([
            appleLoginBtn.topAnchor.constraint(equalTo: self.appleButtonLocation.topAnchor),
            appleLoginBtn.leadingAnchor.constraint(equalTo: self.appleButtonLocation.leadingAnchor),
            appleLoginBtn.trailingAnchor.constraint(equalTo: self.appleButtonLocation.trailingAnchor),
            appleLoginBtn.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        appleButtonLocation.isHidden = true
    }
    
    @objc func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
}

extension LoginViewController: LoginPresenterView {
    func invalidCredentials(error: String) {
        AlertHandlerService.shared.showWarningAlert(view: self, message: error)
        
        setLoading(false)
    }
}

@available(iOS 13.0, *)
extension LoginViewController: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            loginPresenter.appleSignInButtonTapped(idToken: idTokenString, nonce: nonce)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
    
}

@available(iOS 13.0, *)
extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
