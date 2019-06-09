//
//  Date-StripDate.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 09/06/2019.
//  Copyright © 2019 Alex Marchant. All rights reserved.
//

import UIKit

extension Date {
    
    func stripDate() -> Date {
        let components = Calendar.current.dateComponents([.hour, .minute], from: self)
        let date = Calendar.current.date(from: components)
        return date!
    }
    
}
