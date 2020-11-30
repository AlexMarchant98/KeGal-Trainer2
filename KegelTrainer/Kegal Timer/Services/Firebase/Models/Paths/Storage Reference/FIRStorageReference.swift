//
//  FIRStorageReference.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 14/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation

enum FIRStorageReference: String {
    case profilePicture
}

class FIRStoragePath {
    
    var ownerUid: String
    var imageName: String
    var storageReference: FIRStorageReference
    
    init(in storageReference: FIRStorageReference,
         ownerUid: String,
         named imageName: String) {
        self.storageReference = storageReference
        self.ownerUid = ownerUid
        self.imageName = imageName
    }
    
    func getPath() -> String {
        switch self.storageReference {
            case .profilePicture:
                return "images/\(ownerUid)/profilePicture/\(imageName)"
        }
    }
}
