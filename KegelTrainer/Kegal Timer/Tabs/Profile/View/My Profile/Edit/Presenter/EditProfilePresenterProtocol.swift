//
//  EditProfilePresenterProtocol.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 20/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation

protocol EditProfilePresenterProtocol {
    func getServices()
    func updateProfile(imageUrl: String)
    func cancel()
}
