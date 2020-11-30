//
//  FirebaseCloudStorageService.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 14/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation
import FirebaseStorage
import FirebaseUI

class FirebaseCloudStorageService: FirebaseCloudStorageServiceProtocol {
    
    let firebaseCrashlyticsService: FirebaseCrashlyticsServiceProtocol
    
    let imageCache = NSCache<NSString, UIImage>()
    
    init(_ firebaseCrashlyticsService: FirebaseCrashlyticsServiceProtocol) {
        self.firebaseCrashlyticsService = firebaseCrashlyticsService
    }
    
    internal func reference(to collectionPath: FIRStoragePath) -> StorageReference {
        return Storage.storage().reference().child(collectionPath.getPath())
    }
    
    func create(
        localFileUrl: URL,
        storagePath: FIRStoragePath,
        completion: @escaping (FIRCloudStorageResult, _ imageUrl: String?) -> Void) -> StorageUploadTask? {
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let ref = reference(to: storagePath)
        
        do {
            guard let image = try UIImage(data: Data(contentsOf: localFileUrl)) else {
                self.firebaseCrashlyticsService.writeLog(message: "ERROR: Selected image to upload not found on users phone")
                completion(FIRCloudStorageResult.failed, nil)
                return nil
            }
            
            var compressed = false
            var compressionQuality: CGFloat = 0.8
            
            var data = image.jpegData(compressionQuality: compressionQuality)!
            
            while((data.count / 1024) > 150 && !compressed) {
                if(compressionQuality <= 0.1) {
                    compressed = true
                }
                compressionQuality = compressionQuality - 0.1
                data = image.jpegData(compressionQuality: compressionQuality)!
            }
            
            return ref.putData(data, metadata: metadata) { metadata, error in
                if let error = error {
                    self.firebaseCrashlyticsService.writeLog(message: "ERROR: Failed to upload image to cloud storage: \(error)")
                    return completion(FIRCloudStorageResult.failed, nil)
                }
                
                ref.downloadURL { (url, error) in
                    guard let imageUrl = url else {
                        return completion(FIRCloudStorageResult.success, nil)
                    }
                    
                    let splitUrl = String(imageUrl.absoluteString.split(separator: "?")[0])
                    
                    return completion(FIRCloudStorageResult.success, splitUrl)
                }
            }
            
        } catch {
            self.firebaseCrashlyticsService.writeLog(message: "ERROR: Selected image to upload not found on users phone: \(error)")
            completion(FIRCloudStorageResult.failed, nil)
        }
        
        return nil
    }
    
    func create(
        localFileUrls: [URL],
        storageReference: FIRStorageReference,
        ownerUid: String,
        completion: @escaping (_ imageUrls: [String]) -> Void) {
        var uploadedImageUrls = [String]()
        var failedImageUrls = [String]()
        var uploadTasks = [StorageUploadTask]()
        
        for url in localFileUrls {
            var currentTask: StorageUploadTask?
            let storagePath = FIRStoragePath(in: storageReference, ownerUid: ownerUid, named: UUID().uuidString)
            currentTask = create(localFileUrl: url, storagePath: storagePath) { (result, imageUrl) in
                switch result.succeeded {
                case true:
                    uploadedImageUrls.append(imageUrl!)
                case false:
                    failedImageUrls.append(url.absoluteString)
                }
                
                uploadTasks.removeAll(where: { $0 == currentTask })
                
                if(uploadTasks.isEmpty) {
                    completion(uploadedImageUrls)
                }
                
            }
            
            if currentTask != nil {
                uploadTasks.append(currentTask!)
            }
        }
    }
    
    func read(
        documentUrl: URL,
        completion: @escaping (FIRCloudStorageResult, _ image: UIImage?) -> Void) {
        
        if let cachedImage = imageCache.object(forKey: documentUrl.absoluteString as NSString) {
            completion(FIRCloudStorageResult.success, cachedImage)
        }
        
        let ref = Storage.storage().reference(forURL: documentUrl.absoluteString)
        
        ref.getData(maxSize: 1 * 2048 * 2048) { data, error in
          if let error = error {
            print(error.localizedDescription)
            completion(FIRCloudStorageResult.failed, nil)
          } else {
            let image = UIImage(data: data!)
            self.imageCache.setObject(image!, forKey: documentUrl.absoluteString as NSString)
            completion(FIRCloudStorageResult.success, image)
          }
        }
    }
    
    func read(
        documentUrl: URL,
        imageView: UIImageView) -> UIImageView {
        
        if let cachedImage = imageCache.object(forKey: documentUrl.absoluteString as NSString) {
            imageView.image = cachedImage
            return imageView
        }
        
        let ref = Storage.storage().reference(forURL: documentUrl.absoluteString)
        
        imageView.sd_setImage(with: ref, placeholderImage: UIImage(named: "profile-placeholder")!)
        
        return imageView
    }
    
    func delete(documentUrl: URL, completion: @escaping (FIRCloudStorageResult) -> Void) {
        let ref = Storage.storage().reference(forURL: documentUrl.absoluteString)
        
        ref.delete { error in
            if let error = error as NSError? {
                guard let errorCode = StorageErrorCode(rawValue: error.code) else {
                    self.firebaseCrashlyticsService.writeLog(message: "ERROR: Failed to delete image: \(error)")
                    completion(FIRCloudStorageResult.failed)
                    return
                }
                switch errorCode {
                case .objectNotFound:
                    self.firebaseCrashlyticsService.writeLog(message: "ERROR: Image could not be found at URL \(documentUrl.absoluteString): \(error)")
                    completion(FIRCloudStorageResult.success)
                default:
                self.firebaseCrashlyticsService.writeLog(message: "ERROR: Failed to delete image: \(error)")
                    completion(FIRCloudStorageResult.failed)
                }
            } else {
                completion(FIRCloudStorageResult.success)
            }
        }
    }
    
}

