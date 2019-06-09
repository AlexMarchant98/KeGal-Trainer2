//
//  String-Stage.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 09/06/2019.
//  Copyright © 2019 Alex Marchant. All rights reserved.
//

import UIKit

extension String {
    var stage: Int {
        return Int(String(format: "%.0f", Double(self) ?? 0.1))!
    }
}
