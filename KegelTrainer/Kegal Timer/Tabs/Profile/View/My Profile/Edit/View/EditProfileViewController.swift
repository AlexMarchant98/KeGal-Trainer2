//
//  EditProfileViewController.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 20/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController, Storyboarded {
    
    var editProfilePresenter: EditProfilePresenterProtocol!
    
    @IBOutlet weak var editProfilePictureView: EditProfilePictureView!
    @IBOutlet weak var updateButton: KTPrimaryButton!
    @IBOutlet weak var cancelButton: KTDestructiveButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .workoutBackgroundColor
        
        editProfilePresenter.getServices()
    }
    
    @IBAction func updateProfileButtonTapped(_ sender: Any) {
        
        if let selectedImageUrl = editProfilePictureView.selectedProfilePictureUrl {
            editProfilePresenter.updateProfile(imageUrl: selectedImageUrl)
        } else {
            AlertHandlerService.shared.showWarningAlert(view: self, message: localizedString(forKey: "select_an_image_error"))
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        editProfilePresenter.cancel()
    }

}

extension EditProfileViewController: EditProfilePresenterView {
    
    func didGetServices(_ firebaseCloudStorageService: FirebaseCloudStorageServiceProtocol) {
        editProfilePictureView.model = EditProfilePictureViewModel(
            existingImageUrl: CurrentUserService.shared.user?.profile_picture,
            parentViewController: self,
            firebaseCloudStorageService)
    }
    
    func errorOccurred(message: String) {
        AlertHandlerService.shared.showWarningAlert(view: self, message: message)
    }
}
