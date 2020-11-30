//
//  CrashlyticsServiceProtocol.swift
//  PTFinder
//
//  Created by Alex Marchant on 10/03/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation

protocol FirebaseCrashlyticsServiceProtocol {
    func writeLog(message: String)
}
