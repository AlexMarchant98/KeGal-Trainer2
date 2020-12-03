//
//  SignupViewController.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 24/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialTextFields
import AuthenticationServices
import CryptoKit

class SignupViewController: UIViewController, Storyboarded {
    
    var signupPresenter: SignupPresenterProtocol!

    fileprivate var currentNonce: String?
    
    @IBOutlet weak var appleButtonLocation: UIButton!
    @IBOutlet weak var orLabel: KTHeader!
    @IBOutlet weak var emailTextBox: MDCTextField!
    @IBOutlet weak var passwordTextBox: MDCTextField!
    @IBOutlet weak var confirmPasswordTextBox: MDCTextField!
    @IBOutlet weak var nextButton: KTPrimaryButton!
    @IBOutlet weak var loginButton: KTSecondaryButton!
    @IBOutlet weak var privacyPolicyButton: KTPrimaryButtonInverted!
    @IBOutlet weak var termsAndConditionsButton: KTPrimaryButtonInverted!
    
//    @IBOutlet weak var loadingView: LoadingView!
    
    var emailTextBoxController: MDCTextInputControllerOutlined!
    var passwordTextBoxController: MDCTextInputControllerOutlined!
    var confirmPasswordTextBoxController: MDCTextInputControllerOutlined!
    
    override func viewDidLoad() {
        
        self.view.backgroundColor = .workoutBackgroundColor
        
        orLabel.textColor = .white
        
        emailTextBox.tintColor = .white
        emailTextBox.textColor = .appGreen
        passwordTextBox.tintColor = .white
        passwordTextBox.textColor = .appGreen
        confirmPasswordTextBox.tintColor = .white
        confirmPasswordTextBox.textColor = .appGreen
        
        emailTextBox.setupToolbar(view: self.view)
        passwordTextBox.setupToolbar(view: self.view)
        confirmPasswordTextBox.setupToolbar(view: self.view)
        
        emailTextBox.delegate = self
        passwordTextBox.delegate = self
        confirmPasswordTextBox.delegate = self

        emailTextBoxController = MDCTextInputControllerOutlined(textInput: emailTextBox)
        emailTextBoxController.setupKTTextFieldController()
        emailTextBoxController.placeholderText = localizedString(forKey: "email")
        emailTextBox.keyboardType = .emailAddress
        
        passwordTextBoxController = MDCTextInputControllerOutlined(textInput: passwordTextBox)
        passwordTextBoxController.setupKTTextFieldController()
        passwordTextBoxController.placeholderText = localizedString(forKey: "password")
        passwordTextBox.isSecureTextEntry = true
        
        confirmPasswordTextBoxController = MDCTextInputControllerOutlined(textInput: confirmPasswordTextBox)
        confirmPasswordTextBoxController.setupKTTextFieldController()
        confirmPasswordTextBoxController.placeholderText = localizedString(forKey: "confirm_password")
        confirmPasswordTextBox.isSecureTextEntry = true
        
        appleButtonLocation.isEnabled = false
        
        if #available(iOS 13.0, *) {
            setupAppleButton()
        }
    }
    
    func setLoading(_ loading: Bool) {
        
//        loadingView.setLoading(isLoading: loading)
        
        emailTextBox.isEnabled = !loading
        passwordTextBox.isEnabled = !loading
        confirmPasswordTextBox.isEnabled = !loading
        nextButton.isEnabled = !loading
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        setLoading(true)
        signupPresenter.signupButtonTapped(
            email: emailTextBox.text,
            password: passwordTextBox.text,
            confirmPassword: confirmPasswordTextBox.text)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        signupPresenter.showLogin()
    }
    
    @IBAction func privacyPolicyButtonTapped(_ sender: Any) {
        if let url = URL(string: "\(Constants.websiteLink)/privacy") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    @IBAction func termsAndConditionsButtonTapped(_ sender: Any) {
        if let url = URL(string: "\(Constants.websiteLink)/termsandconditions") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

@available(iOS 13.0, *)
extension SignupViewController {
    
    func setupAppleButton() {
        var appleLoginBtn: ASAuthorizationAppleIDButton!
        
        if #available(iOS 13.2, *) {
            appleLoginBtn = ASAuthorizationAppleIDButton(type: .signUp, style: .white)
        } else {
            appleLoginBtn = ASAuthorizationAppleIDButton(type: .signIn, style: .white)
        }
        
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

extension SignupViewController: SignupPresenterView {
    
    func errorOccurred(message: String) {
        AlertHandlerService.shared.showWarningAlert(view: self, message: message)
        
        setLoading(false)
    }
}

@available(iOS 13.0, *)
extension SignupViewController: ASAuthorizationControllerDelegate {

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
            
            setLoading(true)
            signupPresenter.appleSignupButtonTapped(idToken: idTokenString, nonce: nonce)
        }
  }

  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    // Handle error.
    print("Sign in with Apple errored: \(error)")
  }

}

@available(iOS 13.0, *)
extension SignupViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
           return self.view.window!
    }
}

extension SignupViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}

