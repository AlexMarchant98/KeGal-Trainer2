//
//  FIRWhereQueryField.swift
//  PTFinder
//
//  Created by Alex Marchant on 22/02/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation

enum FIRWhereQueryField: String {
    case isEqualTo
    case isLessThanOrEqualTo
    case isLessThan
    case isGreaterThan
    case isGreaterThanOrEqualTo
    case arrayContains
    case `in`
}
