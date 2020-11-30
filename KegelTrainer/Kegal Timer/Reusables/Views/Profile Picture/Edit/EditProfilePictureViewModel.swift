//
//  EditProfilePictureViewModel.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 20/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation
import UIKit

class EditProfilePictureViewModel {
    
    let existingImageUrl: URL?
    let parentViewController: UIViewController
    let firebaseCloudStorageService: FirebaseCloudStorageServiceProtocol
    
    init(existingImageUrl: String? = nil,
         parentViewController: UIViewController,
         _ firebaseCloudStorageService: FirebaseCloudStorageServiceProtocol) {
        
        self.parentViewController = parentViewController
        self.firebaseCloudStorageService = firebaseCloudStorageService
        
        if let url = existingImageUrl {
            self.existingImageUrl = URL(string: url)!
        } else {
            self.existingImageUrl = nil
        }
    }
    
}
