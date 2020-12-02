//
//  DatabaseResult.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 14/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation

class DatabaseResult: NSObject {
    
    internal var succeeded: Bool
    
    private init(succeeded: Bool) {
        self.succeeded = succeeded
    }
    
    static let success = DatabaseResult(succeeded: true)
    
    static let failed = DatabaseResult(succeeded: false)
}
