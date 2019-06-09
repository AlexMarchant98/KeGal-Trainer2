//
//  AlertHandling.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 09/06/2019.
//  Copyright © 2019 Alex Marchant. All rights reserved.
//

import SwiftEntryKit
import UIKit

/// Declares that a conforming type is able to handle alerts being dismissed.
protocol AlertHandling {
    func alertDismissed(type: AlertType)
}
