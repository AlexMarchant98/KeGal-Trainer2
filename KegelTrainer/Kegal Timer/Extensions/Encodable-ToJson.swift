//
//  Encodable-ToJson.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 14/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation
import FirebaseFirestore

enum FirestoreDataError: Error {
    case encodingError
    case decodingError
}

extension Encodable {
    
    func toJson(excluding keys: [String] = [String]()) throws -> [String: Any] {
        
        let objectData = try JSONEncoder().encode(self)
        let jsonObject = try JSONSerialization.jsonObject(with: objectData, options: [])
        
        guard var json = jsonObject as? [String: Any] else { throw FirestoreDataError.encodingError }
        
        for key in keys {
            json[key] = nil
        }
        
        return json
    }
    
}
