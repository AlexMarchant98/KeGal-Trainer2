//
//  CreateProfilePresenterProtocol.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 14/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation

protocol CreateProfilePresenterProtocol {
    func getServices()
    func setupProfile(username: String, imageUrl: String?)
}
