//
//  FirebaseCrashlyticsService.swift
//  PTFinder
//
//  Created by Alex Marchant on 10/03/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation
import FirebaseCrashlytics

class FirebaseCrashlyticsService: FirebaseCrashlyticsServiceProtocol {
    
    init() {}
    
    func writeLog(message: String) {
        Crashlytics.crashlytics().log(message)
    }
    
}
