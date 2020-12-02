//
//  UITextField-ValidateText.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 24/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import UIKit

extension UITextField {
    func validateText(validationType: ValidatorType) throws -> String {
        let validator = VaildatorFactory.validatorFor(type: validationType)
        return try validator.validated(self.text!)
    }
}

extension String {
    func validateText(validationType: ValidatorType) throws -> String {
        let validator = VaildatorFactory.validatorFor(type: validationType)
        return try validator.validated(self)
    }
}
