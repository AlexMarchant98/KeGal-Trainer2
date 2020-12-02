//
//  EditProfilePictureView.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 20/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialTextFields
import Photos

protocol EditProfilePictureViewDelegate {
    func showPhotos()
}

class EditProfilePictureView: UIView {
    
    var parentViewController: UIViewController?
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var profilePicture: KTProfilePicture!
    @IBOutlet weak var uploadImageButton: MDCFloatingButton!
    
    var model: EditProfilePictureViewModel? {
        didSet {
            guard let model = model else {
                return
            }
            
            if let url = model.existingImageUrl {
                let _ = model.firebaseCloudStorageService.read(documentUrl: url, imageView: profilePicture)
            }
            
            self.parentViewController = model.parentViewController
        }
    }
    
    var imagePickerController: UIImagePickerController!
    var selectedProfilePictureUrl: String?
    
    var delegate: EditProfilePictureViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.backgroundColor = .clear
        
        let name = String(describing: type(of: self))
        
        Bundle.main.loadNibNamed(name, owner: self, options: nil)
        
        self.addSubview(self.view)
        
        self.view.frame = self.bounds
        self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        setupView()
    }
    
    func setupView() {
        
        self.view.backgroundColor = .clear
        
        self.imagePickerController = UIImagePickerController()
        
        uploadImageButton.setImage(UIImage(named: "camera-icon"), for: .normal)
        uploadImageButton.tintColor = .white
        uploadImageButton.setBackgroundColor(.appLightPurple)
    }
    
    @IBAction func uploadImageButtonTapped(_ sender: Any) {
        checkPhotosPermission()
    }
    
    
    func checkPhotosPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            self.selectPhoto()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                if newStatus ==  PHAuthorizationStatus.authorized {
                    self.selectPhoto()
                } else {
                    ErrorScreensCoordinator.shared.showEnablePhotoAccess()
                }
            })
        case .restricted:
            ErrorScreensCoordinator.shared.showEnablePhotoAccess()
        case .denied:
            ErrorScreensCoordinator.shared.showEnablePhotoAccess()
        @unknown default:
            ErrorScreensCoordinator.shared.showEnablePhotoAccess()
        }
    }
    
    func selectPhoto() {
        DispatchQueue.main.async {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                self.imagePickerController.delegate = self
                self.imagePickerController.sourceType = .photoLibrary
                self.parentViewController?.present(self.imagePickerController, animated: true, completion: nil)
            }
        }
    }

}

extension EditProfilePictureView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.parentViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.parentViewController?.dismiss(animated: true) {
            guard let selectedImageUrl = info[UIImagePickerController.InfoKey.imageURL] as? NSURL else {
                AlertHandlerService.shared.showWarningAlert(view: self.parentViewController!, message: "Failed to load the selected photo, please try again.")
                return
            }
            
            self.selectedProfilePictureUrl = selectedImageUrl.absoluteString
            
            if let data = NSData(contentsOf: selectedImageUrl.absoluteURL!) {
                self.profilePicture.image = UIImage(data: data as Data)
            } else {
                AlertHandlerService.shared.showWarningAlert(view: self.parentViewController!, message: "Failed to load the selected photo, please try again.")
            }
        }
    }
}
