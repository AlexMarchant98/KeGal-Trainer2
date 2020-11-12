//
//  Storyboarded.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 04/06/2019.
//  Copyright © 2019 Alex Marchant. All rights reserved.
//

import Foundation
import UIKit

protocol Storyboarded {
    static func instantiate(storyboard: String) -> Self
}

extension Storyboarded where Self: UIViewController {
    static func instantiate(storyboard: String = "Main") -> Self {
        let storyboardIdentifier = String(describing: self)
        let storyboard = UIStoryboard(name: storyboard, bundle: Bundle.main)
        
        return storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as! Self
    }
}
