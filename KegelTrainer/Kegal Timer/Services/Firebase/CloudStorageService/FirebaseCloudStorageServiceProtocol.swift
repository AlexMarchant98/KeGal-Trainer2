//
//  FirebaseCloudStorageServiceProtocol.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 14/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation
import FirebaseStorage

protocol FirebaseCloudStorageServiceProtocol {
    func create(
        localFileUrl: URL,
        storagePath: FIRStoragePath,
        completion: @escaping (FIRCloudStorageResult, _ imageUrl: String?) -> Void) -> StorageUploadTask?
    
    func read(documentUrl: URL, completion: @escaping (FIRCloudStorageResult, _ image: UIImage?) -> Void)
    
    func read(documentUrl: URL, imageView: UIImageView) -> UIImageView
    
    func delete(documentUrl: URL, completion: @escaping (FIRCloudStorageResult) -> Void)
}
