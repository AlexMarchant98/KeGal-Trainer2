//
//  FirebaseAuthProtocol.swift
//  PTFinder
//
//  Created by Alex Marchant on 26/05/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

protocol FirebaseAuthProtocol {
    var currentUser: User? { get }
}
