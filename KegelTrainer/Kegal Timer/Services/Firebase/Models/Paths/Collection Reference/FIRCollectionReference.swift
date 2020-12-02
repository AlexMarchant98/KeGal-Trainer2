//
//  FIRCollectionReference.swift
//  PTFinder
//
//  Created by Alex Marchant on 09/01/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation

enum FIRCollectionReference: String {
    case profiles
}

class FIRCollectionPath {
    var docId: String?
    var collectionReference: FIRCollectionReference
    
    init(under docId: String? = nil,
         in collectionReference: FIRCollectionReference) {
        self.docId = docId
        self.collectionReference = collectionReference
    }
    
    func getPath() -> String {
        switch self.collectionReference {
            case .profiles:
                return "profiles"
        }
    }
}
