//
//  FirestoreRepositoryServiceProtocol.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 13/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

protocol FirestoreRepositoryServiceProtocol {
    
    func currentUserId() throws -> String
    
    func create<T: Encodable & FIRIdentifiable>(
        for encodableObject: T,
        in collectionPath: FIRCollectionPath,
        completion: @escaping (DatabaseResult, _ docId: String?) -> Void)
    
    func read<T: Decodable>(
        from collectionPath: FIRCollectionPath,
        returning objectType: T.Type,
        withSnapshotListener: Bool,
        completion: @escaping (DatabaseResult, [T]) -> Void) -> String?
    
    func readById<T: Decodable>(
        docId: String,
        from collectionPath: FIRCollectionPath,
        returning objectType: T.Type,
        withSnapshotListener: Bool,
        completion: @escaping (DatabaseResult, T?) -> Void) -> String?
    
    func readByIds<T: Decodable>(
        docIds: [String],
        from collectionPath: FIRCollectionPath,
        returning objectType: T.Type,
        completion: @escaping (DatabaseResult, [T]) -> Void)
    
    func readByQuery<T: Decodable>(
        from collectionPath: FIRCollectionPath,
        whereField fieldName: String,
        queryType: FIRWhereQueryField,
        valueIs fieldValue: Any,
        returning objectType: T.Type,
        withSnapshotListener: Bool,
        completion: @escaping (DatabaseResult, [T]) -> Void) -> String?
    
    func update<T: Encodable & FIRIdentifiable>(
        for encodableObject: T,
        in collectionPath: FIRCollectionPath,
        completion: @escaping (DatabaseResult) -> Void)
    
    func delete<T: FIRIdentifiable>(
        for encodableObject: T,
        in collectionPath: FIRCollectionPath,
        completion: @escaping (DatabaseResult) -> Void)
    
    func setupLeaderboardProfilesQuery(completion: @escaping (DatabaseResult, [FIRProfile], Bool) -> Void)
    
    func getLeaderboardProfiles(completion: @escaping (DatabaseResult, [FIRProfile], Bool) -> Void)
    
    func removeListener(with id: String)
    
    func removeAllListeners()
}
