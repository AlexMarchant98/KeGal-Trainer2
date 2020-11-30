//
//  CollectionReferenceProtocol.swift
//  PTFinder
//
//  Created by Alex Marchant on 26/05/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation
import FirebaseFirestore

protocol CollectionReferenceProtocol {
    
    func document() -> DocumentReference
    func document(_ docId: String) -> DocumentReference
    func getDocuments(completion: @escaping FIRQuerySnapshotBlock)
    func addSnapshotListener(_ listener: @escaping FIRQuerySnapshotBlock) -> ListenerRegistration
    func whereField(_ field: String, isLessThan value: Any) -> Query
    func whereField(_ field: String, isLessThanOrEqualTo value: Any) -> Query
    func whereField(_ field: String, isEqualTo value: Any) -> Query
    func whereField(_ field: String, isGreaterThan value: Any) -> Query
    func whereField(_ field: String, isGreaterThanOrEqualTo value: Any) -> Query
    func whereField(_ field: String, arrayContains value: Any) -> Query
    func whereField(_ field: String, in: [Any]) -> Query
    func limit(to: Int) -> Query
    func start(afterDocument: DocumentSnapshot) -> Query
    
}
