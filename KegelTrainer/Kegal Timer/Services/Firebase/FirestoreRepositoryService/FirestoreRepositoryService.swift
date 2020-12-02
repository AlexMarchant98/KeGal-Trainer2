//
//  FirestoreRepositoryService.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 13/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth

extension Firestore: FirestoreDatabaseProtocol {}
extension Auth: FirebaseAuthProtocol {}
extension CollectionReference: CollectionReferenceProtocol {}

fileprivate var listeners = Dictionary<String, ListenerRegistration>()

class FirestoreRepositoryService: FirestoreRepositoryServiceProtocol {
    
    let firebaseCrashlyticsService: FirebaseCrashlyticsServiceProtocol
    let firebaseAuth: FirebaseAuthProtocol
    let firestoreDatabase: FirestoreDatabaseProtocol
    
    var leaderboardQuery: Query?
    var allProfilesLoaded: Bool = false
    
    init(
        _ firebaseCrashlyticsService: FirebaseCrashlyticsServiceProtocol,
        firebaseAuth: FirebaseAuthProtocol? = nil,
        firestoreDatabase: FirestoreDatabaseProtocol? = nil) {
        self.firebaseCrashlyticsService = firebaseCrashlyticsService
        self.firebaseAuth = firebaseAuth ?? Auth.auth()
        self.firestoreDatabase = firestoreDatabase ?? Firestore.firestore()
    }
    
    internal func reference(to collectionPath: FIRCollectionPath) -> CollectionReferenceProtocol {
        return firestoreDatabase.collection(collectionPath.getPath())
    }
    
    internal func currentUserId() throws -> String {
        guard let currentUserId = firebaseAuth.currentUser?.uid else { throw FirestoreRepositoryError.notAuthenticated }
        return currentUserId
    }
    
    func create<T: Encodable & FIRIdentifiable>(
        for encodableObject: T,
        in collectionPath: FIRCollectionPath,
        completion: @escaping (DatabaseResult, _ docId: String?) -> Void) {
        
        do {
            let ref = reference(to: collectionPath).document()
            var obj = encodableObject
            obj.id = ref.documentID
            let json = try obj.toJson()
            ref.setData(json) { error in
                if let error = error {
                    self.firebaseCrashlyticsService.writeLog(message: "ERROR: Failed to add document: \(error)")
                    print(error)
                    completion(DatabaseResult.failed, nil)
                } else {
                    completion(DatabaseResult.success, ref.documentID)
                }
            }
        } catch {
            self.firebaseCrashlyticsService.writeLog(message: "ERROR: Failed to encode object document to JSON: \(error)")
            completion(DatabaseResult.failed, nil)
        }
    }
    
    func read<T: Decodable>(
        from collectionPath: FIRCollectionPath,
        returning objectType: T.Type,
        withSnapshotListener: Bool,
        completion: @escaping (DatabaseResult, [T]) -> Void) -> String? {
        
        if(withSnapshotListener) {
            
            let listener = reference(to: collectionPath).addSnapshotListener { (snapshot, error) in
                let objects = [T]()
                
                if let error = error {
                    self.firebaseCrashlyticsService.writeLog(message: "ERROR: Failed to read documents at path '\(collectionPath.getPath())': \(error)")
                    completion(DatabaseResult.failed, objects)
                } else {
                    var objects = [T]()
                    for document in snapshot!.documents {
                        do {
                            let object = try document.decode(as: objectType.self)
                            objects.append(object)
                        } catch {
                            self.firebaseCrashlyticsService.writeLog(message: "ERROR: Failed to decode document returned on read: \(error)")
                        }
                    }
                    completion(DatabaseResult.success, objects)
                }
            }
            
            return addListener(listener)
            
        } else {
            
            reference(to: collectionPath).getDocuments() { (snapshot, error) in
                var objects = [T]()
                
                if let error = error {
                    self.firebaseCrashlyticsService.writeLog(message: "ERROR: Failed to get documents at path '\(collectionPath.getPath())' \(error)")
                    completion(DatabaseResult.failed, objects)
                } else {
                    for document in snapshot!.documents {
                        do {
                            let object = try document.decode(as: objectType.self)
                            objects.append(object)
                        } catch {
                            self.firebaseCrashlyticsService.writeLog(message: "ERROR: Failed to decode document returned on read: \(error)")
                        }
                    }
                    completion(DatabaseResult.success, objects)
                }
            }
            
            return nil
        }
    }
    
    func readById<T: Decodable>(
        docId: String,
        from collectionPath: FIRCollectionPath,
        returning objectType: T.Type,
        withSnapshotListener: Bool,
        completion: @escaping (DatabaseResult, T?) -> Void) -> String? {
        
        if(withSnapshotListener) {

            let listener = reference(to: collectionPath).document(docId).addSnapshotListener { (snapshot, error) in
            
                if let error = error {
                    self.firebaseCrashlyticsService.writeLog(message: "ERROR: Failed to get document by id at path '\(collectionPath.getPath()): \(error)")
                    completion(DatabaseResult.failed, nil)
                } else {
                    do {
                        let object = try snapshot!.decode(as: objectType.self)
                        completion(DatabaseResult.success, object)
                    } catch {
                        self.firebaseCrashlyticsService.writeLog(message: "ERROR: Failed to decode document with id \(docId): \(error)")
                        completion(DatabaseResult.failed, nil)
                    }
                }
            }
            
            return addListener(listener)
            
        } else {
            
            reference(to: collectionPath).document(docId).getDocument() { (snapshot, error) in
                if let error = error {
                    self.firebaseCrashlyticsService.writeLog(message: "ERROR: Failed to get document by id at path '\(collectionPath.getPath()): \(error)")
                    completion(DatabaseResult.failed, nil)
                } else {
                    do {
                        let object = try snapshot!.decode(as: objectType.self)
                        completion(DatabaseResult.success, object)
                    } catch {
                        self.firebaseCrashlyticsService.writeLog(message: "ERROR: Failed to decode document with id \(docId): \(error)")
                        completion(DatabaseResult.failed, nil)
                    }
                }
            }
            
            return nil
            
        }
    }
    
    func readByIds<T: Decodable>(
        docIds: [String],
        from collectionPath: FIRCollectionPath,
        returning objectType: T.Type,
        completion: @escaping (DatabaseResult, [T]) -> Void) {
        
        var objects = [T]()
        var docIdRequests = docIds
        for docId in docIds {
            reference(to: collectionPath).document(docId).getDocument { documentSnapshot, error in
                
            docIdRequests.removeAll(where: { $0 == docId })
                
                if let error = error {
                    self.firebaseCrashlyticsService.writeLog(message: "ERROR: Failed to get document by id at path '\(collectionPath.getPath()): \(error)")
                } else {
                    do {
                        let object = try documentSnapshot!.decode(as: objectType.self)
                        objects.append(object)
                    } catch {
                        self.firebaseCrashlyticsService.writeLog(message: "ERROR: Failed to decode document with id \(docId): \(error)")
                    }
                }
                
                if(docIdRequests.isEmpty) {
                    completion(DatabaseResult.success, objects)
                }
            }
            
        }
    }
    
    func readByQuery<T: Decodable>(
        from collectionPath: FIRCollectionPath,
        whereField fieldName: String,
        queryType: FIRWhereQueryField,
        valueIs fieldValue: Any,
        returning objectType: T.Type,
        withSnapshotListener: Bool,
        completion: @escaping (DatabaseResult, [T]) -> Void) -> String? {
        
        var query: Query!
        
        switch (queryType) {
        case .isLessThan:
            query = reference(to: collectionPath).whereField(fieldName, isLessThan: fieldValue)
        case .isLessThanOrEqualTo:
            query = reference(to: collectionPath).whereField(fieldName, isLessThanOrEqualTo: fieldValue)
        case .isEqualTo:
            query = reference(to: collectionPath).whereField(fieldName, isEqualTo: fieldValue)
        case .isGreaterThan:
            query = reference(to: collectionPath).whereField(fieldName, isGreaterThan: fieldValue)
        case .isGreaterThanOrEqualTo:
            query = reference(to: collectionPath).whereField(fieldName, isGreaterThanOrEqualTo: fieldValue)
        case .arrayContains:
            query = reference(to: collectionPath).whereField(fieldName, arrayContains: fieldValue)
        case .in:
            query = reference(to: collectionPath).whereField(fieldName, in: [fieldValue])
        }
        
        if(withSnapshotListener) {
            
            let listener = query.addSnapshotListener() { (snapshot, error) in

                var objects = [T]()
                
                if let error = error {
                    self.firebaseCrashlyticsService.writeLog(message: "ERROR: Failed to get documents with custom query at path: \(collectionPath.getPath())': \(error)")
                    completion(DatabaseResult.failed, objects)
                } else {
                    for document in snapshot!.documents {
                        do {
                            let object = try document.decode(as: objectType.self)
                            objects.append(object)
                        } catch {
                            self.firebaseCrashlyticsService.writeLog(message: "ERROR: Failed to decode document: \(error)")
                        }
                    }
                    completion(DatabaseResult.success, objects)
                }
            }
            
            return addListener(listener)
            
        } else {
            
            query.getDocuments() { (snapshot, error) in

                var objects = [T]()
            
                if let error = error {
                    self.firebaseCrashlyticsService.writeLog(message: "Error getting document: \(error)")
                    completion(DatabaseResult.failed, objects)
                } else {
                    for document in snapshot!.documents {
                        do {
                            let object = try document.decode(as: objectType.self)
                            objects.append(object)
                        } catch {
                            self.firebaseCrashlyticsService.writeLog(message: "Error decoding document: \(error)")
                        }
                    }
                    return completion(DatabaseResult.success, objects)
                }
            }
            
            return nil
            
        }
    }
    
    func update<T: Encodable & FIRIdentifiable>(
        for encodableObject: T,
        in collectionPath: FIRCollectionPath,
        completion: @escaping (DatabaseResult) -> Void) {
        
        do {
            let json = try encodableObject.toJson()
            
            guard let id = encodableObject.id else { throw FirestoreDataError.encodingError }
            reference(to: collectionPath).document(id).setData(json) { error in
                if let error = error {
                    self.firebaseCrashlyticsService.writeLog(message: "Error updating document: \(error)")
                    completion(DatabaseResult.failed)
                } else {
                    completion(DatabaseResult.success)
                }
            }
            
        } catch {
            self.firebaseCrashlyticsService.writeLog(message: "Error updating document: \(error)")
            completion(DatabaseResult.failed)
        }
        
    }
    
    func delete<T: FIRIdentifiable>(
            for encodableObject: T,
            in collectionPath: FIRCollectionPath,
            completion: @escaping (DatabaseResult) -> Void) {
                
        do {
            guard let id = encodableObject.id else { throw FirestoreDataError.encodingError }
            
            reference(to: collectionPath).document(id).delete() { error in
               if let error = error {
                   self.firebaseCrashlyticsService.writeLog(message: "Error deleting document: \(error)")
                   completion(DatabaseResult.failed)
               } else {
                   completion(DatabaseResult.success)
               }
           }
            
        } catch {
            self.firebaseCrashlyticsService.writeLog(message: "Error deleting document: \(error)")
            completion(DatabaseResult.failed)
        }
    }
    
    func setupLeaderboardProfilesQuery(completion: @escaping (DatabaseResult, [FIRProfile], Bool) -> Void) {
        
        leaderboardQuery = reference(to: FIRCollectionPath(in: .profiles))
            .limit(to: 10)
            .order(by: "rank", descending: false)
        
        allProfilesLoaded = false
        
        var isInitialSetup = true
        
        let listener = leaderboardQuery!.addSnapshotListener() { (snapshot, err) in

                var profiles = [FIRProfile]()
            
                if let err = err {
                    self.firebaseCrashlyticsService.writeLog(message: "ERROR: Failed to get profiles: \(err)")
                    completion(.failed, profiles, false)
                } else {
                    guard let snapshot = snapshot else {
                        self.firebaseCrashlyticsService.writeLog(message: "ERROR: Failed to get profiels as snapshot was nil")
                        completion(.failed, profiles, false)
                        return
                    }
                    
                    for document in snapshot.documents {
                        do {
                            let profile = try document.decode(as: FIRProfile.self)
                            profiles.append(profile)
                        } catch {
                            self.firebaseCrashlyticsService.writeLog(message: "Error decoding document: \(error)")
                        }
                    }
                    
                    if(isInitialSetup) {
                        isInitialSetup = false
                        if(snapshot.documents.last == nil) {
                            self.leaderboardQuery = nil
                            self.allProfilesLoaded = true
                            completion(.success, profiles, true)
                        } else {
                            self.leaderboardQuery = self.leaderboardQuery!.start(afterDocument: snapshot.documents.last!)
                            completion(.success, profiles, false)
                        }
                    } else {
                        completion(.success, profiles, false)
                    }
                }
        }
        
        let _ = addListener(listener)
    }
    
    func getLeaderboardProfiles(completion: @escaping (DatabaseResult, [FIRProfile], Bool) -> Void) {
        
        var profiles = [FIRProfile]()
        
        if(allProfilesLoaded) {
            completion(.success, profiles, true)
            return
        }
        
        if let leaderboardQuery = self.leaderboardQuery {
            leaderboardQuery.limit(to: 10).getDocuments() { documentSnapshots, err in
                    
                    if let err = err {
                        self.firebaseCrashlyticsService.writeLog(message: "ERROR: Failed to get profiles for the leaderboard: \(err)")
                        completion(.failed, profiles, false)
                    } else {
                        guard let documentSnapshots = documentSnapshots else {
                            self.firebaseCrashlyticsService.writeLog(message: "ERROR: Failed to get profiles as DocumentSnapshots was nil")
                            completion(.failed, profiles, false)
                            return
                        }
                        
                        for document in documentSnapshots.documents {
                            do {
                                let profile = try document.decode(as: FIRProfile.self)
                                profiles.append(profile)
                            } catch {
                                self.firebaseCrashlyticsService.writeLog(message: "Error decoding document: \(error)")
                            }
                        }
                        if(documentSnapshots.documents.last == nil) {
                            self.leaderboardQuery = nil
                            self.allProfilesLoaded = true
                            completion(.success, profiles, true)
                        } else {
                            self.leaderboardQuery = self.leaderboardQuery!.start(afterDocument: documentSnapshots.documents.last!)
                            completion(.success, profiles, false)
                        }
                    }
            }
        } else {
            completion(.failed, profiles, false)
        }
    }
    
    internal func addListener(_ listener: ListenerRegistration) -> String {
        let id = UUID().uuidString
        
        listeners[id] = listener
        
        return id
    }
    
    func removeListener(with id: String) {
        listeners.removeValue(forKey: id)
    }
    
    func removeAllListeners() {
        for listener in listeners {
            listener.value.remove()
        }
    }
}
