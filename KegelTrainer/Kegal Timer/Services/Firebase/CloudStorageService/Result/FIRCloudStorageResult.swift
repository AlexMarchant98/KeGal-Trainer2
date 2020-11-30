//
//  FIRCloudStorageResult.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 14/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation

class FIRCloudStorageResult: NSObject {
    
    internal var succeeded: Bool
    
    private init(succeeded: Bool) {
        self.succeeded = succeeded
    }
    
    static let success = FIRCloudStorageResult(succeeded: true)
    
    static let failed = FIRCloudStorageResult(succeeded: false)
}
