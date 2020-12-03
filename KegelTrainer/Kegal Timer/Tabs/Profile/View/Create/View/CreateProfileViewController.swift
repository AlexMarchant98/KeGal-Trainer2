//
//  CreateProfileViewController.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 14/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialTextFields

class CreateProfileViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var usernameTextField: MDCTextField!
    @IBOutlet weak var createProfileButton: MDCRaisedButton!
    @IBOutlet weak var editProfilePictureView: EditProfilePictureView!
    
    var createProfilePresenter: CreateProfilePresenterProtocol!
    
    var usernameTextFieldController: MDCTextInputControllerOutlined!
    
    var usernameIsValid: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .workoutBackgroundColor
        
        createProfilePresenter.getServices()
        
        usernameTextField.delegate = self
        usernameTextField.tintColor = .white
        usernameTextField.textColor = .appGreen
        
        usernameTextFieldController = MDCTextInputControllerOutlined(textInput: usernameTextField)
        usernameTextFieldController.activeColor = UIColor.appGreen
        usernameTextFieldController.placeholderText = localizedString(forKey: "enter_your_username")
        usernameTextFieldController.normalColor = .white
        usernameTextFieldController.inlinePlaceholderColor = .white
        usernameTextFieldController.floatingPlaceholderActiveColor = .appGreen
        usernameTextFieldController.floatingPlaceholderNormalColor = .white
        usernameTextFieldController.textInputClearButtonTintColor = .appGreen
        usernameTextFieldController.inlinePlaceholderColor = .white
        usernameTextFieldController.characterCountMax = 25
        usernameTextFieldController.leadingUnderlineLabelTextColor = .white
        usernameTextFieldController.trailingUnderlineLabelTextColor = .white
    }
    
    @IBAction func createProfileButtonTapped(_ sender: Any) {
        if(usernameIsValid) {
            if let username = usernameTextField.text {
                
                if(username.isEmpty) {
                    usernameIsValid = false
                    usernameTextFieldController.setErrorText(localizedString(forKey: "enter_a_username_error"), errorAccessibilityValue: nil)
                    return
                }
                
                createProfilePresenter.setupProfile(
                    username: username,
                    imageUrl: editProfilePictureView.selectedProfilePictureUrl)
                return
            }
        }
        usernameTextFieldController.setErrorText(localizedString(forKey: "enter_a_valid_username_error"),
            errorAccessibilityValue: nil)
    }
    
}

extension CreateProfileViewController: CreateProfilePresenterView {
    
    func didGetServices(_ firebaseCloudStorageService: FirebaseCloudStorageServiceProtocol) {
        editProfilePictureView.model = EditProfilePictureViewModel(parentViewController: self, firebaseCloudStorageService)
    }
    
    func errorOccurred(message: String) {
        AlertHandlerService.shared.showWarningAlert(view: self, message: message)
    }
}

extension CreateProfileViewController: UITextFieldDelegate {
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        if textField == usernameTextField {
            usernameIsValid = true
            usernameTextFieldController.setErrorText(nil, errorAccessibilityValue: nil)
            
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard let rawText = textField.text else {
            return true
        }
        
        var fullString = NSString(string: rawText).replacingCharacters(in: range, with: string)
        fullString = fullString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if textField == usernameTextField {
            
            if(fullString.isEmpty) {
                usernameIsValid = false
                usernameTextFieldController.setErrorText(localizedString(forKey: "enter_a_username_error"), errorAccessibilityValue: nil)
            } else {
                
                if(fullString.count > 25) {
                    usernameTextFieldController.setErrorText(localizedString(forKey: "max_length_reached_error"),
                        errorAccessibilityValue: nil)
                    usernameIsValid = false
                    
                    return false
                }
                
                let invalidCharacters = NSCharacterSet.alphanumerics.inverted
                
                let range = string.rangeOfCharacter(from: invalidCharacters)
                
                if range != nil {
                    usernameTextFieldController.setErrorText(
                        localizedString(forKey: "only_letters_and_numbers_error"),
                        errorAccessibilityValue: nil)
                    usernameIsValid = false
                    
                    return false
                } else {
                    usernameIsValid = true
                    usernameTextFieldController.setErrorText(nil, errorAccessibilityValue: nil)
                    
                    return true
                }
            }
        }
        return true
    }
}
