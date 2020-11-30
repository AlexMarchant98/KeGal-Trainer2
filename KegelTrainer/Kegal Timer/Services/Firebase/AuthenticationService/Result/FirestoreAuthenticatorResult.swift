//
//  FirestoreAuthenticatorResult.swift
//  PTFinder
//
//  Created by Alex Marchant on 30/12/2019.
//  Copyright © 2019 Alex Marchant. All rights reserved.
//

enum FirestoreAuthenticatorResult {
    case success
    case failure(Error)
}

enum FirestoreAuthenticatorError: Error {
    case generalError
}
